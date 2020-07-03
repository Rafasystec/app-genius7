import 'package:flutter/material.dart';

class AlertOk extends StatelessWidget {
  final String title;
  final String body;
  AlertOk(this.body,{this.title = 'Advice'});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(body),
//                Text('Would you like to approve of this message?'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
