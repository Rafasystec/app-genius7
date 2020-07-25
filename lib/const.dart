import 'dart:ui';

import 'package:flutter/material.dart';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

const String ID_USER_CLI_FIREBASE = "id-user-cli-firebase";
const String ID_USER_PRO_FIREBASE = "id-user-pro-firebase";
const String NICK_NAME = "nickname";
const String PHOTO_URL = "photoUrl";
const String ABOUT_ME = 'aboutMe';
const String RESTAURANT_PATH = 'restaurant-doc-path';

BoxDecoration btnBoxDecoration() {
  return BoxDecoration(
    color: Color(0xffdd4b39),
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //         <--- border radius here
    ),
  );
}

