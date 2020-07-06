import 'package:app/Screens/screen_pro_agenda.dart';
import 'package:app/components/pro_rating.dart';
import 'package:app/components/prod_detail.dart';
import 'package:app/response/response_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenProDetailAgenda extends StatelessWidget{

  final ResponsePro _responsePro;
  ScreenProDetailAgenda(this._responsePro);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
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
                  decoration: myBoxDecoration(),
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
              child: Container(
                decoration: myBoxDecoration(),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.chat,color: Colors.white,),
                      tooltip: 'Faça uma pergunta',
                      onPressed: null,
                    ),
                    Text('Faça uma pergunta',style: TextStyle(color: Colors.white,fontSize: 24.0),)
                  ],
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

      ),
    );

  }
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //         <--- border radius here
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
