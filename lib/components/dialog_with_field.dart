import 'package:flutter/material.dart';

import '../const.dart';

Future<String> openDialogField(BuildContext context, {String title = 'Aviso', IconData icon = Icons.info_outline}) async {
    String result;
    TextEditingController controllerEdit = TextEditingController();
   return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
          children: <Widget>[
            Container(
              color: themeColor,
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
              height: 150.0,
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
                  Container(
                    height: 50,
                    child: TextField(
                      autofocus: true,
                      controller: controllerEdit,
                      maxLength: 60,
                      onChanged: (value){
                        result = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, result);
              },
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.save,
                      color: primaryColor,
                    ),
                    margin: EdgeInsets.only(right: 10.0),
                  ),
                  Text(
                    'OK',
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        );
      });

}