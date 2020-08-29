import 'dart:io';

import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/global_param.dart';
import 'package:app/util/preference_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

import '../const.dart';

class ScreenSettings extends StatefulWidget {
  final String userRef;
  final bool isEdit;
  final TypeArea typeArea;
  ScreenSettings(this.userRef,this.typeArea,{this.isEdit = false});
  @override
  _ScreenSettingsState createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {


  File avatarImageFile;
  String photoUrl,name, address = '';
  String currentCollection;
  ImagePicker _picker;
  bool isLoading      = false,
       isLoggedIn     = false,
       showRemoveAll  = false;
  String refDoc;
  SharedPreferences prefs;
  TextEditingController controllerRestaurantName;
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  double lat,lng = 0;
  List<GalleryItem> _galleryItems = List();
  List<String> urls       = List();
  List<String> urlsFromDB = List();
  List<File> files        = List();
  bool isEditMode         = false;
  /// See this for crop detail: https://pub.dev/packages/image_cropper
  Future addImageGalleryOrCamera(bool fromCamera, List<GalleryItem> galleryItems,int maxImages) async {
    setState(() {
      isLoading = true;
    });
    if(galleryItems != null) {
      if (galleryItems.length >= maxImages) {
        Fluttertoast.showToast(msg: '${AppLocalizations.of(context).translate('you_can_just_add')} ${GlobalParameters.maxImageAmount} ${AppLocalizations.of(context).translate('images')}');
        return;
      }
    }
    PickedFile pickerFile ;
    if(fromCamera) {
      pickerFile = await _picker.getImage(source: ImageSource.camera);
    }else{
      pickerFile = await _picker.getImage(source: ImageSource.gallery);
    }
    if (pickerFile != null) {
      File croppedFile;
      try {
        croppedFile = await getCompressedCropImage(pickerFile);
      }catch(e){
        setState(() {
          isLoading = false;
        });
      }
      if(croppedFile == null){
        setState(() {
          isLoading = false;
        });
      }
     if(galleryItems != null ) {
       setState(() {
         showRemoveAll = true;
         files.add(croppedFile);
         galleryItems.add(GalleryItem(
           galleryItems.length, id: galleryItems.length.toString(),
           resource: croppedFile.path,
           isSvg: false,
           isLocal: true,));
         isLoading = false;
       });
     }else{
       setState(() {
         avatarImageFile = croppedFile;
         isLoading = false;
       });
     }
    }
  }

  void handleSaveData() {
    if(!validation()){
      return;
    }
    setState(() {
      isLoading = true;
    });

    if(isEditMode){
      Firestore.instance
//          .collection(COLLECTION_RESTAURANT)
          .collection(currentCollection)
          .document(refDoc)
      .updateData({FB_REST_NAME: name
      }).then((data) async {
        prefs.setString(REST_NAME, name);
        uploadFile();
        uploadGallery();
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('save_success'));
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }else {
      Firestore.instance
//          .collection(COLLECTION_RESTAURANT)
          .collection(currentCollection)
          .add({FB_REST_NAME: name,
        FB_REST_ACTIVE: true,
        FB_REST_AVATAR: photoUrl,
        //'id':2,
        FB_REST_LAT: lat,
        FB_REST_LONG: lng,
        FB_REST_RATE: 0,
        FB_REST_ADDRESS: address,
        FB_REST_IMAGES: urls,
        FB_REST_USER: widget.userRef}).then((data) async {
        refDoc = data.documentID;
        if(widget.typeArea == TypeArea.SALES){
          await prefs.setString(SALES_PATH, refDoc);
        }else{
          await prefs.setString(RESTAURANT_PATH, refDoc);
        }
        PreferenceUtil.setRestPreferenceFromDocument(await data.get(),TypeArea.RESTAURANT);
        uploadFile();
        uploadGallery();
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('save_success'));
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  void readLocal() async {
    prefs         = await SharedPreferences.getInstance();
    if(widget.typeArea == TypeArea.SALES) {
      refDoc = prefs.getString(SALES_PATH) ?? '';
    }else {
      refDoc = prefs.getString(RESTAURANT_PATH) ?? '';
    }
    photoUrl      = prefs.getString(REST_AVATAR) ?? '';
    setState(() {
      var tempIsEdit = prefs.getBool(REST_EDIT_MODE);
      if(tempIsEdit != null){
        isEditMode = tempIsEdit;
      }else{
        isEditMode = false;
      }
      if(refDoc.trim().isEmpty){
        isLoggedIn = false;
      }else{
        isLoggedIn = true;
      }
      if(isEditMode){
        var name = prefs.getString(REST_NAME);
        controllerRestaurantName = TextEditingController(text: name);
        address       = prefs.getString(REST_ADDRESS);
        urlsFromDB    = prefs.getStringList(REST_IMAGES);
        _galleryItems = getGalleryItems(urlsFromDB);
      }else{
        controllerRestaurantName = TextEditingController();
      }
    });


    // Force refresh input
//    setState(() {});
  }

  void deleteGallery(){
    var refDocument = Firestore.instance
//        .collection(COLLECTION_RESTAURANT)
        .collection(currentCollection)
        .document(refDoc);
    if(refDocument != null) {
      String ref = refDocument.documentID;
      if(ref.isNotEmpty) {
        refDocument.updateData({FB_REST_IMAGES: FieldValue.delete()}).then((value) =>
            Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('deleted_images')));
      }
    }
    setState(() {
      urls            = List();
      files           = List();
      _galleryItems   = List();
      showRemoveAll   = false;
    });
  }

  Future uploadFile() async {
    if(avatarImageFile == null)return;
//    String fileName = '$COLLECTION_RESTAURANT/$refRestaurant/main_$refRestaurant';
    String fileName = '$currentCollection/$refDoc/main_$refDoc';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
//              .collection(COLLECTION_RESTAURANT)
              .collection(currentCollection)
              .document(refDoc)
              .updateData({FB_REST_AVATAR: photoUrl,
                           FB_REST_ID: refDoc}).then((data) async {
//            await prefs.setString(RESTAURANT_IMG_PATH, photoUrl);
            setState(() {
              isLoading = false;
            });
            prefs.setString(REST_AVATAR , photoUrl);
            Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('update_success'));
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }


  Future uploadGallery() async {
    bool hasError = false;
    if(files == null || files.length == 0){
      return;
    }
    int index = 0;
    Fluttertoast.showToast(msg: 'Uploading files ...');
    setState(() {
      isLoading = true;
    });
    for(File file in files ){
//      String fileName = '$COLLECTION_RESTAURANT/$refRestaurant/${++index}_${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}.jpg';
      String fileName = '$currentCollection/$refDoc/${++index}_${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}.jpg';
      StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(file);
      StorageTaskSnapshot storageTaskSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            String url = downloadUrl;
            Fluttertoast.showToast(msg: 'image $index uploaded!');
            setState(() {
              urls.add(url);
              urlsFromDB.add(url);
            });
            if(urls.length == files.length){
              setState(() {
                isLoading = true;
                if (!hasError) {
                  Firestore.instance
                      .collection(currentCollection)
//                      .collection(COLLECTION_RESTAURANT)
                      .document(refDoc)
                      .updateData({'images': urlsFromDB}).then((data) async {
                    setState(() {
                      isLoading = false;
                    });
                    prefs.setStringList(REST_IMAGES,  urlsFromDB);
                    Fluttertoast.showToast(msg: "Upload success");
                  }).catchError((err) {
                    setState(() {
                      isLoading = false;
                    });
                    Fluttertoast.showToast(msg: err.toString());
                  });
                }
              });
            }
          }, onError: (err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: 'This file is not an image');
          });
        } else {
          hasError =true;
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        }
      }, onError: (err) {
        hasError = true;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.typeArea == TypeArea.SALES) {
      currentCollection = COLLECTION_STORE;
    }else{
      currentCollection = COLLECTION_RESTAURANT;
    }
    _picker = ImagePicker();
    readLocal();

  }

  bool validation(){
    bool result = true;
    name = controllerRestaurantName.text;
    if(!isEditMode) {
      if (address == null || address.isEmpty) {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context).translate('inform_the_address'));
        result = false;
      }
      if(files.isEmpty || files.length < 3){
        Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('add_at_least'));
        result = false;
      }
      if(avatarImageFile == null){
        Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('add_main_image'));
        result = false;
      }
    }
    if(name == null || name.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_restaurant_name'));
      result = false;
    }
    return result;
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: AppLocalizations.of(context).translate('lang_country_code'),
      components: [Component(Component.country, AppLocalizations.of(context).translate('place_country_code'))],
    );
    displayPrediction(p);
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      print("${p.description} - $lat/$lng");
      setState(() {
        address = p.description;
        this.lat = lat;
        this.lng = lng;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('save').toUpperCase()),
            onPressed: () async {
              if(!isLoading) {
                setState(() {
                  isLoading = true;
                });
                handleSaveData();
              }else{
                Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('please_wait'));
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                getMainPhotoContainer(avatarImageFile,photoUrl,()=>addImageGalleryOrCamera(false,null,0)),
                formField(context, controllerRestaurantName, (value){
                    name = value;
                }, AppLocalizations.of(context).translate('restaurant_name'), null),
//                SizedBox(height: 20.0,),
//                appButtonTheme(context,'SAVE',handleSaveData),
                SizedBox(height: 20.0,),
                buildAppButtonForAddress(context),
                SizedBox(height: 20.0,),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('${AppLocalizations.of(context).translate('your_address')}: $address'),
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    appButtonTheme(context, AppLocalizations.of(context).translate('gallery'), ()=>addImageGalleryOrCamera(false,_galleryItems,GlobalParameters.maxImageAmount) ,height: 25.0, minWidth: 80.0),
                    SizedBox(width: 20.0,),
                    appButtonTheme(context, AppLocalizations.of(context).translate('camera'), ()=>addImageGalleryOrCamera(true,_galleryItems,GlobalParameters.maxImageAmount) ,height: 25.0, minWidth: 80.0),
                  ],
                ),
                SizedBox(height: 20.0,),
                Visibility(
                  visible: showRemoveAll,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: appButtonTheme(context, AppLocalizations.of(context).translate('remove_all_images'), deleteGallery,height: 35.0, icon: Icon(Icons.remove_circle)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(AppLocalizations.of(context).translate('explain_delete_image')),
                        ),
                      )
                    ],
                  ),
                ),
                GalleryView(_galleryItems),
              ],
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget buildAppButtonForAddress(BuildContext context) {
    if(isEditMode){
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(child: Text(AppLocalizations.of(context).translate('only_pro_user_can_change_address'))),
      );
    }else {
      return appButtonTheme(
          context, AppLocalizations.of(context).translate('your_address'),
          _handlePressButton, height: 35.0);
    }
  }
}
