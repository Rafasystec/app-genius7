import 'dart:async';

import 'package:app/enums/from_screen_enum.dart';
import 'package:app/restaurant/home.dart';
import 'package:app/util/app_locations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/loading.dart';
import 'const.dart';
import 'home.dart';
///This login file well server both for client and pro
class LoginScreen extends StatefulWidget {
  LoginScreen(this.fromScreen,{Key key, this.title = 'Login'}) : super(key: key);

  final String title;
  final FromScreen fromScreen;

  @override
  LoginScreenState createState() => LoginScreenState();
}



class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      redirectToCorrectHomeScreen();
      //Closes this login page
      Navigator.pop(context);

    }

    this.setState(() {
      isLoading = false;
    });
  }

  void redirectToCorrectHomeScreen() {
     switch(widget.fromScreen){
      case FromScreen.LOGIN_CLIENT:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: prefs.getString(USER_REF))),
        );
        break;
      case FromScreen.LOGIN_RESTAURANT:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenRestaurant()),
        );
        break;
      case FromScreen.LOGIN_PRO:
        /// TODO: Handle this case.
        break;
    }
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if(googleUser == null){
      this.setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('invalid_user'));
      return;
    }
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
          await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'email':firebaseUser.email,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString(USER_REF, currentUser.uid);
        await prefs.setString(NICK_NAME, currentUser.displayName);
        await prefs.setString(PHOTO_URL, currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString(USER_REF, documents[0]['id']);
        await prefs.setString(NICK_NAME, documents[0]['nickname']);
        await prefs.setString(PHOTO_URL, documents[0]['photoUrl']);
        await prefs.setString(ABOUT_ME, documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('sign_in_success'));
      this.setState(() {
        isLoading = false;
      });

//      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: firebaseUser.uid)));
      redirectToCorrectHomeScreen();
    } else {
      Fluttertoast.showToast(msg: AppLocalizations.of(context).translate('sign_in_fail'));
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    AppLocalizations.of(context).translate('sing_in_with_google'),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));
  }
}
