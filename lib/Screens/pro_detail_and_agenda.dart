import 'package:app/Screens/chat.dart';
import 'package:app/Screens/screen_pro_agenda.dart';
import 'package:app/components/pro_rating.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/const.dart';
import 'package:app/login.dart';
import 'package:app/response/response_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenProDetailAgenda extends StatelessWidget{

  final ResponsePro _responsePro;
  ScreenProDetailAgenda(this._responsePro);


  @override
  Widget build(BuildContext context) {
    SharedPreferences prefs;
    String idClientFirebase;
    Future<String> readLocal() async {
      prefs = await SharedPreferences.getInstance();
      idClientFirebase = prefs.getString(USER_REF) ?? '';
      return idClientFirebase;
    }
    return
       Scaffold(
        appBar: AppBar(
          title: Text('Agenda'),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () => Navigator.pop(context),
//            )
//          ],
        ),
        body: Column(
          children: <Widget>[
            CardTop(_responsePro),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
                },
                child: Container(
                  decoration: btnBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.calendar_today,color: Colors.white),
                        tooltip: 'Ver a agenda do profissional',
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
                        },
                      ),
                      Text('Ver a agenda',style: TextStyle(color: Colors.white,fontSize: 24.0))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: InkWell(
                onTap: (){
                  readLocal().then((value){
                    if(value.isEmpty){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(title: 'Faça o login',)));
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chat(peerId: _responsePro.idUserFirebase,peerAvatar: 'avatar',)));
                    }
                  });
                },
                child: Container(
                  decoration: btnBoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.chat,color: Colors.white,),
                        tooltip: 'Faça uma pergunta',
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chat(peerId: 'peerID',peerAvatar: 'avatar',)));
                        },
                      ),
                      Text('Faça uma pergunta',style: TextStyle(color: Colors.white,fontSize: 24.0),)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    _responsePro.about,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 15,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _responsePro.ratings == null? 0 : _responsePro.ratings.length,
                  itemBuilder: (BuildContext context, int index){
                    var item = _responsePro.ratings[index];
                    return ProRating(item);
                  }),
            ),
          ],
        ),
    );

  }
//  BoxDecoration btnBoxDecoration() {
//    return BoxDecoration(
//      color: Color(0xffdd4b39),
//      borderRadius: BorderRadius.all(
//          Radius.circular(5.0) //         <--- border radius here
//      ),
//    );
//  }
}

class CardTop extends StatelessWidget {
  final ResponsePro _responsePro;
  CardTop(this._responsePro);
  @override
  Widget build(BuildContext context) {
    return  ProDetails(_responsePro);
  }
}
