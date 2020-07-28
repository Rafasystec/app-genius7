import 'dart:ffi';
import 'dart:io';

import 'package:app/components/screen_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

import '../const.dart';

class ScreenSettings extends StatefulWidget {
  @override
  _ScreenSettingsState createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {


  File avatarImageFile;
  String photoUrl,name = '';
  ImagePicker _picker;
  bool isLoading,isLoggedIn = false;
//  bool isLoggedIn = false;
  String refRestaurant;
  SharedPreferences prefs;
  TextEditingController controllerRestaurantName;
  Mode _mode = Mode.overlay;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  Future getImage() async {
    final pikerFile =  await _picker.getImage(source: ImageSource.camera);
    if (pikerFile != null) {
      setState(() {
        avatarImageFile = File(pikerFile.path);
        isLoading = true;
      });
    }
    //Upload should be on save method
    //uploadFile();
  }

  void handleSaveData() {
//    focusNodeNickname.unfocus();
//    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection(COLLECTION_RESTAURANT)
        .add({'name': name, 'active': true, 'avatar': photoUrl,'id':2,'lat':2516486486.1684864,'long':41814984191941.181891,'rate':0}).then((data) async {
//      await prefs.setString('nickname', nickname);
//      await prefs.setString('aboutMe', aboutMe);
//      await prefs.setString(RESTAURANT_IMG_PATH, photoUrl);
      refRestaurant = data.documentID;
      await prefs.setString(RESTAURANT_PATH, refRestaurant);

      uploadFile();
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Salvo com sucesso!");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    refRestaurant = prefs.getString(RESTAURANT_PATH) ?? '';
    photoUrl = prefs.getString(RESTAURANT_IMG_PATH) ?? '';
    if(refRestaurant.trim().isEmpty){
      isLoggedIn = false;
    }else{
      isLoggedIn = true;
    }
//    controllerNickname = TextEditingController(text: nickname);
//    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  Future uploadFile() async {
    String fileName = '$COLLECTION_RESTAURANT/$refRestaurant';
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
              .updateData({'avatar': photoUrl}).then((data) async {
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

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    readLocal();

  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "fr",
      components: [Component(Component.country, "fr")],
    );

    displayPrediction(p);
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
//    homeScaffoldKey.currentState.showSnackBar(
//      SnackBar(content: Text(response.errorMessage)),
//    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      print("${p.description} - $lat/$lng");
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
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
                          onPressed: getImage,
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
                ),
//                formFieldText('Nome do Restaurante', (value) {
//                  if (value.isEmpty) {
//                    return 'Por favor informe o nome do restaurante';
//                  }
//                  name = value;
//                  return null;
//                },
//                ),
              formField(context, controllerRestaurantName, (value){
                  name = value;
              }, 'Nome do Restaurante', null),
                appButtonTheme(context,'SAVE',handleSaveData),
                RaisedButton(
                  onPressed: _handlePressButton,
                  child: Text("Search places"),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
