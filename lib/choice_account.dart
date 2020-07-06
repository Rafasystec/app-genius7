import 'package:flutter/material.dart';

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
      )
    );
  }
}
