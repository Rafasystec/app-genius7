
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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