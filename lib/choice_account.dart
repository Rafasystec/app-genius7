import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'const.dart';

class ChooseTypeAccount extends StatefulWidget {
  @override
  _ChooseTypeAccountState createState() => _ChooseTypeAccountState();
}

class _ChooseTypeAccountState extends State<ChooseTypeAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escolha uma conta',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
