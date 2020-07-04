import 'package:app/Screens/pro_detail_and_agenda.dart';
import 'package:app/components/centered_message.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/components/progress_bar.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/webservice/pro_ws.dart';
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
      body: FutureBuilder<List<ResponsePro>>(
        future: Future.delayed(Duration(seconds: 1)).then((value) => getAllProfessionalByArea(idAreaPro)),
        builder: (context,snapshot){
          switch(snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return ProgressBar();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if(snapshot.hasData) {
                final List<ResponsePro> pros = snapshot.data;
                if (pros.isNotEmpty) {
                  return ListProfessionals(pros);
                }
              }else if(snapshot.hasError){
                return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
              }
              break;
          }
          return CenteredMessage('No entry found!',icon: Icons.warning,);
        },
      ),
    );
  }
}

class ListProfessionals extends StatelessWidget{
  final List<ResponsePro> list;
  ListProfessionals(this.list);
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index){
          var item = list[index];
          return GetList(item);
        });
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