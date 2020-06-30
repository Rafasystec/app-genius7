import 'package:app/Objects/Location.dart';
import 'package:app/Objects/user.dart';
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



  /** _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
               image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
              
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
}*/

}

class InitialList extends StatelessWidget{
  List<ResponseAreaPro> list = [
    ResponseAreaPro('Encanador','200 profissionais'),
    ResponseAreaPro('Eletricista','458 profissionais'),
    ResponseAreaPro('Manicure','986 profissionais'),];
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index){
          var item = list[index];
          return InitialListItem(item.title,item.description);
        });
//    return Column(
//      children: <Widget>[
//        InitialListItem(),
//        InitialListItem()
//      ],
//    );
  }
}

class InitialListItem extends StatelessWidget{
  final String title;
  final String subtitle;
  InitialListItem(this.title,this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: (){
          _showMyDialog(context,title,subtitle);
        },
        leading: Icon(Icons.monetization_on),
        title: Text(title),
        subtitle: Text(subtitle),
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
