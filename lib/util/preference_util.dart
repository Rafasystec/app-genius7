import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil{

  static void clear(SharedPreferences prefs){
    prefs.clear();
  }
}

