import 'package:app/Objects/Location.dart';
import 'package:app/Objects/user.dart';
import 'package:app/Screens/list_pro.dart';
import 'package:app/response/ResponseAreaPro.dart';
import 'package:flutter/material.dart';
//import 'package:momentum/Objects/user.dart';

class Profile extends StatelessWidget {
  final User user = User();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Áreas de atuação'),
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
        body: Container(
          child: Center(
              child: InitialList()
              //child: _displayUserData(user.profileData),
            ),
        ),
      ),
    );
  }

}

class InitialList extends StatelessWidget{
  List<ResponseAreaPro> list = [
    ResponseAreaPro('Encanador','200 profissionais','iconURL',1),
    ResponseAreaPro('Eletricista','458 profissionais','iconURL',2),
    ResponseAreaPro('Manicure','986 profissionais','iconURL',3),];
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
  final ResponseAreaPro _responseAreaPro;
  InitialListItem(this._responseAreaPro);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListPro(_responseAreaPro.idArea)));
        },
        leading: Image.network(_responseAreaPro.iconURL),
        title: Text(_responseAreaPro.title),
        subtitle: Text(_responseAreaPro.description),
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
