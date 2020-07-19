

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appButtonTheme(BuildContext context,String label, VoidCallback onPressedAction ){
  return ButtonTheme(
    minWidth: 220.0,
    height: 70.0,
    child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: BorderSide(color: Colors.red),
        ),
        onPressed: onPressedAction,
        child: Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
        color: Color(0xffdd4b39),
        highlightColor: Color(0xffff7f7f),
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
  );
}