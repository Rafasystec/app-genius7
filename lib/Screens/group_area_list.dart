
import 'package:app/Screens/Profile.dart';
import 'package:app/Screens/list_pro.dart';
import 'package:app/components/centered_message.dart';
import 'package:app/components/progress_bar.dart';
import 'package:app/response/response_group_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class ScreenGroupAreas extends StatelessWidget {

  Future<List<ResponseGroupList>> _is() async{
    List<ResponseGroupList> list = new List();
    list.add(ResponseGroupList(1,'https://blogdaliga.com.br/wp-content/uploads/2019/08/alvenaria.jpg','ALVENARIA'));
    list.add(ResponseGroupList(2,'https://img.stpu.com.br/?img=https://s3.amazonaws.com/pu-mgr/default/a0R0f00001Fdh3JEAR/5d8e1f15e4b09720b65d1d2f.jpg&w=710&h=462','ESTÉTICA'));
    list.add(ResponseGroupList(3,'https://conteudo.imguol.com.br/c/entretenimento/85/2020/03/10/produtos-de-limpeza-1583862507502_v2_1254x837.jpg','CUIDADOS DO LAR'));
    list.add(ResponseGroupList(4,'https://www.quadrilatero.ind.br/cache/images/85-pt-br-1170x520.jpg','MARCENARIA'));
    list.add(ResponseGroupList(5,'https://novovarejo.com.br/wp-content/uploads/2020/02/qual-autopeca-mais-vendida-1170x694.jpg','AUTO-PEÇAS'));
    list.add(ResponseGroupList(6,'https://omecanico.com.br/wp-content/uploads/2020/01/oficina-m%C3%B3vel_1.jpg','OFICINAS'));
    list.add(ResponseGroupList(7,'https://omecanico.com.br/wp-content/uploads/2020/01/oficina-m%C3%B3vel_1.jpg','OFICINAS'));
    list.add(ResponseGroupList(8,'https://omecanico.com.br/wp-content/uploads/2020/01/oficina-m%C3%B3vel_1.jpg','OFICINAS'));
    list.add(ResponseGroupList(9,'https://omecanico.com.br/wp-content/uploads/2020/01/oficina-m%C3%B3vel_1.jpg','OFICINAS'));
    list.add(ResponseGroupList(10,'https://omecanico.com.br/wp-content/uploads/2020/01/oficina-m%C3%B3vel_1.jpg','OFICINAS'));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Escolha um grupo'),
        ),
        body: FutureBuilder<List<ResponseGroupList>>(
          future: Future.delayed(Duration(seconds: 1)).then((value) => _is() ) ,
          builder: (context , snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return ProgressBar();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if(snapshot.hasData) {
                  final List<ResponseGroupList> areas = snapshot.data;
                  if (areas.isNotEmpty) {
                    return InitialList(areas);
                  }
                }else if(snapshot.hasError){
                  return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
                }
                break;
            }
            return CenteredMessage('No entry found!',icon: Icons.warning,);

          },),
      );
  }

}

class InitialList extends StatelessWidget{
  final List<ResponseGroupList> list;
  InitialList(this.list);
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index){
          var item = list[index];
          return InitialListItem(item);
        });
  }
}

class InitialListItem extends StatelessWidget{
  final ResponseGroupList _groupList;
  InitialListItem(this._groupList);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListPro(_groupList.groupId)));
        },
        child: ListTile(
          leading: _groupList.bunner != null
              ? CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
              width: 50.0,
              height: 50.0,
              padding: EdgeInsets.all(15.0),
            ),
            imageUrl: _groupList.bunner,
            width: 80.0,
            height: 50.0,
            fit: BoxFit.cover,
          )
              : Icon(
            Icons.warning,
            size: 50.0,
            color: greyColor,
          ),
          title: Text(_groupList.description),
          subtitle: Text('Manicure, cabeleleira...'),
          trailing: Icon(Icons.more_vert),
        ),
      ),
    );

  }

  Future<void> _showMyDialog(BuildContext context, String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
      },
    );
  }



}
