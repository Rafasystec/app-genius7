
import 'package:app/Screens/chat.dart';
import 'package:app/Screens/screen_pro_agenda.dart';
import 'package:app/components/pro_rating.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/const.dart';
import 'package:app/enums/from_screen_enum.dart';
import 'package:app/login.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/util/app_locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenProDetailAgenda extends StatelessWidget{

  final ResponsePro _responsePro;
  ScreenProDetailAgenda(this._responsePro);


  @override
  Widget build(BuildContext context) {

    return
       Scaffold(
        appBar: AppBar(
          title: Text('Agenda'),
        ),
        body: Column(
          children: <Widget>[
            CardTop(_responsePro),
            buttonSeeAgenda(context),
            buttonDoAQuestion(context),
            showAboutPro(),
//            getProRating(),
          ],
        ),
    );
  }

  Widget getProRating(){
    _responsePro.ratings != null || _responsePro.ratings.isNotEmpty  ? expandedProRating()  : Center(child: Text('no rating'),);
  }

  Widget expandedProRating(){
    return Expanded(
      child: ListView.builder(
          itemCount: _responsePro.ratings == null? 0 : _responsePro.ratings.length,
          itemBuilder: (BuildContext context, int index){
            var item = _responsePro.ratings[index];
            return ProRating(item);
          }),
    );
  }

  Widget showAboutPro(){
    return Padding(
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
    );
  }

  Widget buttonSeeAgenda(BuildContext context){
    return Padding(
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
                tooltip: AppLocalizations.of(context).translate('see_pro_agenda'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAgendaPro(title: 'Agenda',)));
                },
              ),
              Text(AppLocalizations.of(context).translate('see_agenda'),style: TextStyle(color: Colors.white,fontSize: 24.0))
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonDoAQuestion(BuildContext context){
    SharedPreferences prefs;
    String idClientFirebase;
    Future<String> readLocal() async {
      prefs = await SharedPreferences.getInstance();
      idClientFirebase = prefs.getString(USER_REF) ?? '';
      return idClientFirebase;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: InkWell(
        onTap: (){
          readLocal().then((value){
            if(value.isEmpty){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(FromScreen.LOGIN_CLIENT, title: 'Faça o login',)));
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
    );
  }
}

class CardTop extends StatelessWidget {
  final ResponsePro _responsePro;
  CardTop(this._responsePro);
  @override
  Widget build(BuildContext context) {
    return  ProDetails(_responsePro);
  }
}
