import 'package:app/Objects/Location.dart';
import 'package:app/Objects/user.dart';
import 'package:app/Screens/Profile.dart';
import 'package:app/Screens/list_pro.dart';

import 'package:app/components/centered_message.dart';
import 'package:app/components/progress_bar.dart';
import 'package:app/response/ResponseAreaPro.dart';
import 'package:app/response/response_group_list.dart';
import 'package:app/response/response_pro_area.dart';
import 'package:app/util/AlertOK.dart';
import 'package:app/webservice/pro_area.dart';
import 'package:flutter/material.dart';
//import 'package:momentum/Objects/user.dart';

class ScreenGroupAreas extends StatelessWidget {

  Future<List<ResponseGroupList>> _is() async{

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Escolha um grupo'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
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
      ),
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
  final ResponseGroupList _responseAreaPro;
  InitialListItem(this._responseAreaPro);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 400.0,
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.redAccent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            _responseAreaPro.bunner != null ? _responseAreaPro.bunner : "",
            height: 150.0,
            width: 100.0,
            fit: BoxFit.fill,
          ),
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
