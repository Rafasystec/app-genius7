import 'dart:io';

import 'package:app/Screens/digital_menu_read_qrcode.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/enums/from_screen_enum.dart';
import 'package:app/home.dart';
import 'package:app/login.dart';
import 'package:app/restaurant/home.dart';
import 'package:app/restaurant/settings.dart';
import 'package:app/sales/choice_account.dart';
import 'package:app/settings.dart';
import 'package:app/util/app_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/choice.dart';
import 'main.dart';

import 'const.dart';

class ChooseTypeAccount extends StatefulWidget {
  @override
  _ChooseTypeAccountState createState() => _ChooseTypeAccountState();
}

class _ChooseTypeAccountState extends State<ChooseTypeAccount> {
  bool isLoading = false;
  SharedPreferences prefs;
  String refRestaurant;
  String refUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  List<Choice> mainChoices = const <Choice>[
    const Choice(0,title: 'Perfil', icon: Icons.settings),
    const Choice(1,title: 'Fechar', icon: Icons.close),
    const Choice(2,title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    refRestaurant = prefs.getString(RESTAURANT_PATH) ?? '';
    refUser       = prefs.getString(USER_REF) ?? '';
  }


  @override
  Widget build(BuildContext context) {

    Future<Null> handleSignOut() async {
      this.setState(() {
        isLoading = true;
      });

      bool isSignedIn = await googleSignIn.isSignedIn();
      if(isSignedIn) {
        await FirebaseAuth.instance.signOut();
        await googleSignIn.disconnect();
        await googleSignIn.signOut();
      }
      prefs = await SharedPreferences.getInstance();
      prefs.clear();
      this.setState(() {
        isLoading = false;
      });

      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
    }


    void onItemMenuPress(Choice choice) {
      if (choice.id == 2) {
        handleSignOut();
      }else if(choice.id == 1){
        exit(0);
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escolha uma conta',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return mainChoices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
          child: buildItem(context)
      ) ,
    );
  }
  Widget buildItem(BuildContext context) {

    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context).translate('are_you_costumer'))),
          appButtonTheme(context, AppLocalizations.of(context).translate('i_want_a_service'),
                  ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreenCostumerService(currentUserId: '2512',)))),

          SizedBox(height: 10,),
            appButtonTheme(context, AppLocalizations.of(context).translate('digital_menu'), ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenReadQrCode(TypeArea.RESTAURANT)))),
            SizedBox(height: 10,),
            Container(
                padding: EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context).translate('are_you_a_restaurant'))),
            SizedBox(height: 10,),
            appButtonTheme(context, AppLocalizations.of(context).translate('service_provider'), ()=>Fluttertoast.showToast(msg: 'Ainda não implementado!')),
            SizedBox(height: 10,),
            appButtonTheme(context, AppLocalizations.of(context).translate('restaurant'), () async {
                prefs         = await SharedPreferences.getInstance();
                refRestaurant = prefs.getString(RESTAURANT_PATH) ?? '';
                refUser       = prefs.getString(USER_REF) ?? '';
                if(refUser == null || refUser.isEmpty){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginScreen(FromScreen.LOGIN_RESTAURANT)));
                }else {
                  restaurantIsRegister(context);
                }
              }
            ),
            SizedBox(height: 10,),
            appButtonTheme(context, AppLocalizations.of(context).translate('products'), (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SalesChoiceAccountScreen()));
            })
          ],
        )
    );

  }

  void restaurantIsRegister(BuildContext context) {
    if(refRestaurant != null && refRestaurant.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreenRestaurant()));
      }else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ScreenSettings(refUser,TypeArea.RESTAURANT))).then((value){
          if(refRestaurant != null && refRestaurant.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreenRestaurant()));
          }
        });
      }
  }
}




