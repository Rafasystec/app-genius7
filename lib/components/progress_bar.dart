import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressBar extends StatelessWidget {
  final String message;
  ProgressBar({this.message = 'loading'});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(message)
        ],
      ),
    );
  }
}
