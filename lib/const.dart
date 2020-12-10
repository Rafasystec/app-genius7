import 'dart:ui';

import 'package:flutter/material.dart';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

//const String ID_USER_CLI_FIREBASE = "id-user-cli-firebase";
//const String ID_USER_PRO_FIREBASE = "id-user-pro-firebase";
const String NICK_NAME            = "nickname";
const String PHOTO_URL            = "photoUrl";
const String ABOUT_ME             = 'aboutMe';
const String RESTAURANT_PATH      = 'restaurant-doc-path';
const String SALES_PATH           = 'sales-doc-path';
const String USER_REF             = 'user-ref';
const String RESTAURANT_IMG_PATH  = 'rest-photo-url';

//Constants for collections on Firebase
const String COLLECTION_RESTAURANT  = 'restaurants';
const String COLLECTION_STORE       = 'stores';
const String COLLECTION_AGENDA      = 'agenda';
const String COLLECTION_PRO         = 'pro';

//------------------------------------------
//To use in shared preferences
//------------------------------------------
const String HAS_MORE_ESTABLISHMENTS = 'has-more-establishments';
//------------------------------------------
//shared preferences for restaurant
//-----------------------------------------
const String REST_ACTIVE    = 'rest-active';
const String REST_ADDRESS   = 'rest-address';
const String REST_AVATAR    = 'rest-avatar';
const String REST_ID        = 'rest-id';
const String REST_IMAGES    = 'rest-images';
const String REST_LAT       = 'rest-lat';
const String REST_LNG       = 'rest-long';
const String REST_NAME      = 'rest-name';
const String REST_USER      = 'rest-user-ref';
const String REST_EDIT_MODE = 'rest-edit-mode';
//------------------------------------------
// Restaurant firebase fields
//------------------------------------------
const String FB_REST_ACTIVE   = 'active';
const String FB_REST_ADDRESS  = 'address';
const String FB_REST_AVATAR = 'avatar';
const String FB_REST_ID     = 'id';
const String FB_REST_IMAGES = 'images';
const String FB_REST_LAT    = 'lat';
const String FB_REST_LONG   = 'long';
const String FB_REST_NAME   = 'name';
const String FB_REST_USER   = 'user-ref';
const String FB_REST_PHONE  = 'phone';
const String FB_REST_RATE   = 'rate';
//------------------------------------------
//API KEY for google places
//------------------------------------------
const kGoogleApiKey = "AIzaSyDkZ2v9YBayX6ofccseKHzOzm6Z5YVYM4Q";

BoxDecoration btnBoxDecoration() {
  return BoxDecoration(
    color: Color(0xffdd4b39),
    borderRadius: BorderRadius.all(
        Radius.circular(5.0) //         <--- border radius here
    ),
  );
}

