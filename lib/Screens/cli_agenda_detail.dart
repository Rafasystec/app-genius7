import 'dart:io';

import 'package:app/components/dialog.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/response/response_cli_agenda.dart';
import 'package:app/response/response_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const.dart';

class ScreenCliAgendaDetail extends StatefulWidget {
  final ResponseCliAgenda _responseCliAgenda;
  ScreenCliAgendaDetail(this._responseCliAgenda);
  @override
  _ScreenCliAgendaDetailState createState() => _ScreenCliAgendaDetailState();
}

class _ScreenCliAgendaDetailState extends State<ScreenCliAgendaDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ProDetails(widget._responseCliAgenda.responsePro),
            Container(
              height: 5,
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today,color: Colors.blue,size: 50.0,),
                title: Text(widget._responseCliAgenda.date),
                subtitle: Text(widget._responseCliAgenda.namePro),
                trailing: Text(widget._responseCliAgenda.value,style: TextStyle(color: Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold),),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 30.0,minWidth: double.infinity),
              child: RaisedButton(
                onPressed:() {
                  Future.sync(() => onCancel())
                  .then((value) {
                    if(value){
                      //TODO cancel agenda on server
                      Fluttertoast.showToast(msg:'Agenda cancelada');
                      Navigator.of(context).pop(widget._responseCliAgenda);
                    }
                  });
                },
                child: Text('CANCELAR'),
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(5, 0, 5, 6),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<bool> onCancel() {
    var value = openDialogYesNo(context,'Tem certeza que deseja cancelar?',title: 'Cancelar Agenda',icon: Icons.cancel);
    return Future.value(value);
  }

}
