import 'package:app/home.dart';
import 'package:app/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

import 'const.dart';

class ChooseTypeAccount extends StatefulWidget {
  @override
  _ChooseTypeAccountState createState() => _ChooseTypeAccountState();
}

class _ChooseTypeAccountState extends State<ChooseTypeAccount> {
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
              return choices.map((Choice choice) {
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
}

Widget buildItem(BuildContext context) {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 220.0,
            height: 70.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Colors.red),
              ),
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text(
                  'SOU CLIENTE',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Color(0xffdd4b39),
                highlightColor: Color(0xffff7f7f),
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)
            ),
          ),
          SizedBox(height: 10,),
          ButtonTheme(
            minWidth: 220.0,
            height: 70.0,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Colors.red),
              ),
                onPressed: (){
                  Fluttertoast.showToast(msg: 'Ainda não implementado');
                },
                child: Text(
                  'SOU PROFISSIONAL',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Color(0xffdd4b39),
                highlightColor: Color(0xffff7f7f),
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
          ),
          ],
      )
      );

}
