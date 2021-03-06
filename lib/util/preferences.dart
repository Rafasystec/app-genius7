
import 'package:app/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_APP_TOKEN = 'app.token';
void setAppToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(KEY_APP_TOKEN, token);
}

getAppToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(KEY_APP_TOKEN);
}

Future<String> getUserID() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(USER_REF);
}

bool isUserLogin(){
  var userID = getUserID();
  bool resul = false;
  userID.then((value) => {
    if(value.isEmpty){
      resul = false
    }else{
      resul = true
    }
  });
  return resul;
}