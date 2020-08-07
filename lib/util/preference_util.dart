import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import 'file_util.dart';

class PreferenceUtil{

  static void clear(SharedPreferences prefs){
    prefs.clear();
  }

  static void setRestPreferenceFromDocument(DocumentSnapshot document) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(REST_EDIT_MODE, true);
    prefs.setString(RESTAURANT_PATH, document.documentID);
    prefs.setBool(REST_ACTIVE   , document[FB_REST_ACTIVE]);
    prefs.setString(REST_ADDRESS, document[FB_REST_ADDRESS]);
    prefs.setString(REST_AVATAR , document[FB_REST_AVATAR]);
    prefs.setStringList(REST_IMAGES,  getImagesFromSnapshot(document[FB_REST_IMAGES]));
    prefs.setString(REST_ID   , document[FB_REST_ID]);
    prefs.setDouble(REST_LAT  , document[FB_REST_LAT]);
    prefs.setDouble(REST_LNG  , document[FB_REST_LONG]);
    prefs.setString(REST_NAME , document[FB_REST_NAME]);
    prefs.setString(REST_USER , document[FB_REST_USER]);
  }
}

