import 'package:app/Screens/digital_menu_read_qrcode.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/enums/from_screen_enum.dart';
import 'package:app/login.dart';
import 'package:app/restaurant/home.dart';
import 'package:app/restaurant/settings.dart';
import 'package:app/sales/home.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/preference_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class SalesChoiceAccountScreen extends StatefulWidget {
  @override
  _SalesChoiceAccountScreenState createState() => _SalesChoiceAccountScreenState();
}

class _SalesChoiceAccountScreenState extends State<SalesChoiceAccountScreen> {
  SharedPreferences prefs;
  String refSales, refUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('choose_account')),
      ),
      body: Center(child: buildItem(context)),
    );
  }

  Widget buildItem(BuildContext context) {

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appButtonTheme(context, AppLocalizations.of(context).translate('i_m_client'), ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenReadQrCode(TypeArea.SALES)))),
            SizedBox(height: 10,),
            appButtonTheme(context, AppLocalizations.of(context).translate('i_m_seller'), () async {
              prefs         = await SharedPreferences.getInstance();
              refSales      = prefs.getString(SALES_PATH) ?? '';
              refUser       = prefs.getString(USER_REF) ?? '';
              if(refUser == null || refUser.isEmpty){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(FromScreen.JUST_CLOSE))).then((value) async {
                  if(value == null) return;
                  String userId = value as String;
                  if(userId.isNotEmpty){
                    final QuerySnapshot result = await Firestore.instance.collection(
                        COLLECTION_STORE).where(
                        'user-ref', isEqualTo: prefs.getString(USER_REF)).getDocuments();
                    final List<DocumentSnapshot> documents = result.documents;
                    if (documents.length == 1) {
                      PreferenceUtil.setRestPreferenceFromDocument(documents[0],TypeArea.SALES);
                      goToHomeScreenSeller(context);
                    } else if (documents.length > 1) {
                      prefs.setBool(HAS_MORE_ESTABLISHMENTS, true);
                    }
                  }
              });
              }else {
                isStoreRegistered(context);
              }
            }),
          ],
        )
    );
  }

  void isStoreRegistered(BuildContext context) {
    if(refSales != null && refSales.isNotEmpty) {
      goToHomeScreenSeller(context);
    }else{
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScreenSettings(refUser,TypeArea.SALES))).then((value){
        if(refSales != null && refSales.isNotEmpty) {
          goToHomeScreenSeller(context);
        }
      });
    }
  }

  void goToHomeScreenSeller(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreenStore()));
  }
}
