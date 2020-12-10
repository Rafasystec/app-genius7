import 'package:app/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {

  final String mainMessage;
  final String spanMessage;
  final VoidCallback onPressed;

  EmptyMessage(
      this.mainMessage,
      {
        this.spanMessage,
        this.onPressed
      }
  );


  Widget build(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              child: Icon(
                Icons.info_outline,
                size: 50,
                color: themeColor,
              ),
              visible: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 20, 2, 8),
              child: SizedBox(
                child: FlatButton(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: primaryColor),
                      text: mainMessage,
                      children: <TextSpan>[
                        getSpanText()
                      ],
                    )
                  ),
                  onPressed: onPressed,
                ),
              ),
            ),
          ],
        ),
      );
    }

  TextSpan getSpanText(){
      if(spanMessage != null) {
        return TextSpan(text: spanMessage,
            style: TextStyle(color: Colors.blueAccent));
      }else{
        return TextSpan(text: '',
            style: TextStyle(color: Colors.blueAccent));
      }
    }
}