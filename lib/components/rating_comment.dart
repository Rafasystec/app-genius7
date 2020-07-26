import 'package:app/components/pro_rating.dart';
import 'package:app/components/screen_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RatingComment extends StatelessWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final bool isLogged;
  RatingComment(this.snapshot,{this.isLogged = false});
  @override
  Widget build(BuildContext context) {
    int length = snapshot.data.documents.length;
    return length == 0 ? emptyContainer(context) : listComments(context,length) ;
  }
  Widget emptyContainer(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(visible: isLogged, child: Text('Nenhum comentário, seja o primeiro')),
          //TODO add edit text to comment
          Visibility(
            visible: isLogged,
            child: formFieldText('Faça seu comentário', (value) {
              if (value.isEmpty) {
                return 'Por favor informar o nome do prato';
              }
              return null;
            },),
          ),
          SizedBox(height: 15,),
          Visibility(visible: isLogged, child: appButtonTheme(context, 'COMENTAR', ()=> Fluttertoast.showToast(msg: 'Comentado. Value!'))),
          Container(
            padding: EdgeInsets.all(8.0),
              child: Visibility(
                  visible: !isLogged,
                  child: appButtonTheme(context, 'LOGAR E COMENTAR', ()=> Fluttertoast.showToast(msg: 'Realizar login e commentar'))
              )
          ),
          Container(
              padding: EdgeInsets.all(8.0),
              child: Visibility(
                child: Text('LOGAR é quando você utiliza as suas credencias para entrar no App.'),
              )
          )
        ],
      ),
    );
  }

  Widget listComments(BuildContext context, int length){
    return Column(
      children: <Widget>[
        formFieldText('Faça seu comentário', (value) {
          if (value.isEmpty) {
            return 'Comentário está vazio';
          }
          return null;
        },),
        SizedBox(height: 15,),
        appButtonTheme(context, 'COMENTAR', ()=> Fluttertoast.showToast(msg: 'Comentado. Value!'),height: 30),
        Container(
          height: 200,
          child: ListView.builder(
              itemCount: length,
              itemBuilder: (BuildContext context, int index){
                DocumentSnapshot item = snapshot.data.documents[index];
                return buildRatingFromSnapshot(context,item);
              }
          ),
        )
      ],
    );
  }
}
