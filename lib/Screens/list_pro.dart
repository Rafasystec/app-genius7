import 'package:app/Screens/pro_detail_and_agenda.dart';
import 'package:app/components/centered_message.dart';
import 'package:app/components/empty_message.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/components/progress_bar.dart';
import 'package:app/const.dart';
import 'package:app/response/response_address.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/webservice/pro_ws.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
      body: WillPopScope(
        child: Container(
          child: StreamBuilder(
            stream: Firestore.instance.collection(COLLECTION_PRO).where('id-area',isEqualTo: idAreaPro).snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData) return Center(
                  child:CircularProgressIndicator()
              );
              if(snapshot.hasData && snapshot.data.documents.length > 0) {
                return ListProfessionals(snapshot.data);
              }if(snapshot.hasError){
                return Center(
                  child: Text(
                      'Error occurred'
                  ),
                );
              }else {
                return EmptyMessage(AppLocalizations.of(context).translate('no_pro_found'));
              }
            },
          ),
        ),  
      ),
    );
  }


}

class ListProfessionals extends StatelessWidget{
  final QuerySnapshot _snapshot;
  ListProfessionals(this._snapshot);
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _snapshot.documents.length,
        itemBuilder: (BuildContext context, int index){
          DocumentSnapshot item = _snapshot.documents[index];
          return GetList(snapshotToResponse(item));
        });
  }
  ResponsePro snapshotToResponse(DocumentSnapshot doc){
    if(doc != null){
      return ResponsePro(0,doc['name'],doc['rate'],doc['photo'],doc['about'],doc['num_att'],doc['amount-rate'],null,doc['user-ref'],
          address : ResponseAddress(doc['district'],doc['street']));
    }else return null;
  }
}

class GetList extends StatelessWidget {
  final ResponsePro _responseAreaPro;
  GetList(this._responseAreaPro);
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ScreenProDetailAgenda(_responseAreaPro)));
      },
      child:
        ProDetails(_responseAreaPro),

    );

  }
}