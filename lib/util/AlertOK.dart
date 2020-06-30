
import 'package:flutter/material.dart';

class AlertOK extends StatelessWidget {
  final String title;
  final String body;
  final String detail;
  AlertOK(this.title, this.body,{this.detail});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(body),
            Visibility(
              visible: detail != null,
              child: Text(detail),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
//  Alert(Context context)
//  Future<void> _showMyDialog() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('AlertDialog Title'),
//          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                Text('This is a demo alert dialog.'),
//                Text('Would you like to approve of this message?'),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Approve'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
}