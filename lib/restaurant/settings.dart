import 'dart:io';

import 'package:app/components/gallery_example_item.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/global_param.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  _ScreenSettingsState createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {


  File avatarImageFile;
  String photoUrl,name, address = '';
  ImagePicker _picker;
  bool isLoading,isLoggedIn, showRemoveAll = false;
//  bool isLoggedIn = false;
  String refRestaurant;
  SharedPreferences prefs;
  TextEditingController controllerRestaurantName;
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  double lat,lng = 0;
  List<GalleryItem> _galleryItems = List();
  List<String> urls = List();
  List<File> files = List();

  /// See this for crop detail: https://pub.dev/packages/image_cropper
  Future addImageGalleryOrCamera(bool fromCamera, List<GalleryItem> galleryItems,int maxImages) async {
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
     File croppedFile = await getCompressedCropImage(pickerFile);
     if(galleryItems != null ) {
       setState(() {
         showRemoveAll = true;
         files.add(croppedFile);
         galleryItems.add(GalleryItem(
           galleryItems.length, id: galleryItems.length.toString(),
           resource: croppedFile.path,
           isSvg: false,
           isLocal: true,));
         isLoading = true;
       });
     }else{
       setState(() {
         avatarImageFile = croppedFile;
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
    Firestore.instance
        .collection(COLLECTION_RESTAURANT)
        .add({'name': name, 'active': true, 'avatar': photoUrl,'id':2,'lat':lat,'long':lng,'rate':0, 'address':address, 'images':urls}).then((data) async {
      refRestaurant = data.documentID;
      await prefs.setString(RESTAURANT_PATH, refRestaurant);

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
  }

  void readLocal() async {
    prefs         = await SharedPreferences.getInstance();
    refRestaurant = prefs.getString(RESTAURANT_PATH) ?? '';
    photoUrl      = prefs.getString(RESTAURANT_IMG_PATH) ?? '';
    if(refRestaurant.trim().isEmpty){
      isLoggedIn = false;
    }else{
      isLoggedIn = true;
    }
    // Force refresh input
    setState(() {});
  }

  void deleteGallery(){
    var refDoc = Firestore.instance
        .collection(COLLECTION_RESTAURANT)
        .document(refRestaurant);
    if(refDoc != null) {
      String ref = refDoc.documentID;
      if(ref.isNotEmpty) {
        refDoc.updateData({'images': FieldValue.delete()}).then((value) =>
            Fluttertoast.showToast(msg: 'Imagens apagadas'));
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
    String fileName = '$COLLECTION_RESTAURANT/$refRestaurant/main_$refRestaurant';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection(COLLECTION_RESTAURANT)
              .document(refRestaurant)
              .updateData({'avatar': photoUrl,
                           'id': refRestaurant}).then((data) async {
            await prefs.setString(RESTAURANT_IMG_PATH, photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
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
    bool isComplete = false;
    int index = 0;
    Fluttertoast.showToast(msg: 'Uploading files ...');
    for(File file in files ){
      String fileName = '$COLLECTION_RESTAURANT/$refRestaurant/${++index}_${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}.jpg';
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
            });
            if(urls.length == files.length){
              setState(() {
                isComplete = true;
                isLoading = false;
                if (!hasError) {
                  Firestore.instance
                      .collection(COLLECTION_RESTAURANT)
                      .document(refRestaurant)
                      .updateData({'images': urls}).then((data) async {
                    setState(() {
                      isLoading = true;
                    });
                    Fluttertoast.showToast(msg: "Upload success");
                  }).catchError((err) {
                    setState(() {
                      isLoading = true;
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
    _picker = ImagePicker();
    readLocal();

  }

  bool validation(){
    bool result = true;

    if(address == null || address.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_address'));
      result = false;
    }
    if(name == null || name.isEmpty){
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('inform_the_restaurant_name'));
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

  Widget getMainPhotoContainer(){
    return Container(
      child: Center(
        child: Stack(
          children: <Widget>[
            (avatarImageFile == null)
                ? ( photoUrl != null && photoUrl != ''
                ? Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  width: 90.0,
                  height: 90.0,
                  padding: EdgeInsets.all(20.0),
                ),
                imageUrl: photoUrl,
                width: 90.0,
                height: 90.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              clipBehavior: Clip.hardEdge,
            )
                : Icon(
              Icons.account_circle,
              size: 90.0,
              color: greyColor,
            ))
                : Material(
              child: Image.file(
                avatarImageFile,
                width: 90.0,
                height: 90.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              clipBehavior: Clip.hardEdge,
            ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: primaryColor.withOpacity(0.5),
              ),
              onPressed: ()=>addImageGalleryOrCamera(false,null,0),
              padding: EdgeInsets.all(30.0),
              splashColor: Colors.transparent,
              highlightColor: greyColor,
              iconSize: 30.0,
            ),
          ],
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
        actions: <Widget>[
          FlatButton(
            child: Text(AppLocalizations.of(context).translate('save').toUpperCase()),
            onPressed: (){
              handleSaveData();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                getMainPhotoContainer(),
                formField(context, controllerRestaurantName, (value){
                    name = value;
                }, AppLocalizations.of(context).translate('restaurant_name'), null),
//                SizedBox(height: 20.0,),
//                appButtonTheme(context,'SAVE',handleSaveData),
                SizedBox(height: 20.0,),
                appButtonTheme(context, AppLocalizations.of(context).translate('your_address'), _handlePressButton,height: 35.0),
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
        ],
      ),
    );
  }
}
