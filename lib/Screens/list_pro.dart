import 'package:flutter/material.dart';

class ListPro extends StatelessWidget{
  final int idAreaPro;
  ListPro(this.idAreaPro);
  @override
  Widget build(BuildContext context) {
    debugPrint('Area id: $idAreaPro');
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Profissionais'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Text('Title', style: TextStyle(fontSize: 24.0)),
              subtitle: Text('Sub'),
            ),
          ),
        ],
      ),
    );
  }

}