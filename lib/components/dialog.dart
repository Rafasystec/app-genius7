import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';

Future<bool> openDialogYesNo(BuildContext context,String message, {String title = 'Aviso', IconData icon = Icons.info_outline}) async {
  switch (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
          children: <Widget>[
            Container(
              color: themeColor,
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
              height: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Icon(
                      icon,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white70, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.cancel,
                      color: primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Text(
                    'NÂO',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Text(
                    'SIM',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        );
      })) {
    case 0:
      return false;
      break;
    case 1:
      return true;
      break;
    default:
      return false;
      break;
  }
}