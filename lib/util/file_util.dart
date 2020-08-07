
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../const.dart';

Future<File> getCompressedCropImage(PickedFile pickerFile) async{
  var compressed = await FlutterImageCompress.compressAndGetFile(pickerFile.path, pickerFile.path.replaceAll('.jpg', '${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}.jpg') ,quality: 100);

  File croppedFile = await ImageCropper.cropImage(
      sourcePath: compressed.path,
      //aspectRatio:CropAspectRatio() ,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
  );
  return croppedFile;
}

Widget getMainPhotoContainer(File avatarImageFile, String photoUrl, VoidCallback onPressed){
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
            onPressed:  onPressed,//()=>addImageGalleryOrCamera(false,null,0),
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

List<String> getImagesFromSnapshot(List<dynamic> list){
  List<String> items = List();
  if(list != null) {
    for (dynamic element in list) {
      items.add(element);
    }
  }
  return items;
}

//Future uploadFile(String path, File file,{FutureOr<R> onValue(T value)}) async {
//  //String fileName = '$COLLECTION_RESTAURANT/$refRestaurant/main_$refRestaurant';
//  StorageReference reference = FirebaseStorage.instance.ref().child(path);
//  StorageUploadTask uploadTask = reference.putFile(file);
//  StorageTaskSnapshot storageTaskSnapshot;
//  uploadTask.onComplete.then((value) {
//    if (value.error == null) {
//      storageTaskSnapshot = value;
//      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//        photoUrl = downloadUrl;
//        Firestore.instance
//            .collection(COLLECTION_RESTAURANT)
//            .document(refRestaurant)
//            .updateData({FB_REST_AVATAR: photoUrl,
//          FB_REST_ID: refRestaurant}).then((data) async {
//          await prefs.setString(RESTAURANT_IMG_PATH, photoUrl);
//          setState(() {
//            isLoading = false;
//          });
//          Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('update_success'));
//        }).catchError((err) {
//          setState(() {
//            isLoading = false;
//          });
//          Fluttertoast.showToast(msg: err.toString());
//        });
//      }, onError: (err) {
//        setState(() {
//          isLoading = false;
//        });
//        Fluttertoast.showToast(msg: 'This file is not an image');
//      });
//    } else {
//      setState(() {
//        isLoading = false;
//      });
//      Fluttertoast.showToast(msg: 'This file is not an image');
//    }
//  }, onError: (err) {
//    setState(() {
//      isLoading = false;
//    });
//    Fluttertoast.showToast(msg: err.toString());
//  });
//}