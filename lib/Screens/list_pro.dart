import 'package:app/response/response_pro.dart';
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
      body: ListProfessionals([new ResponsePro(0, 'João da Silva', 3, 'https://www.ansocial.com.br/wp-content/uploads/2018/07/eletricista-1.jpg', 'about',28,16),
        new ResponsePro(0, 'Livia Medeiros', 4, 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSCc-fFn2VwF5grWGXzx8h3nGriDuGKn_fRbA&usqp=CAU', 'about',46,40)
      ]),
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
    var row = Container(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.redAccent,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                _responseAreaPro.url != null ? _responseAreaPro.url : "",
                height: 150.0,
                width: 100.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4.0),
              height: 150.0,

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 10),
                    height: 50,
                    width: 220.0,
                    child: Text(_responseAreaPro.name,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white,fontSize: 20.0),)),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 16),
                    width: 220.0,
                    child: Text(
                      '${_responseAreaPro.attendances} Atendimentos',
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white
                      ),
                      maxLines: 2,)),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(child: Row(mainAxisSize: MainAxisSize.min,
                        children: [
                        Icon(Icons.star, color: _responseAreaPro.rant > 0 ? Colors.green[500] : Colors.black),
                        Icon(Icons.star, color: _responseAreaPro.rant > 1 ? Colors.green[500] : Colors.black),
                        Icon(Icons.star, color: _responseAreaPro.rant > 2 ? Colors.green[500] : Colors.black),
                        Icon(Icons.star, color: _responseAreaPro.rant > 3 ? Colors.green[500] : Colors.black),
                        Icon(Icons.star, color: _responseAreaPro.rant > 4 ? Colors.green[500] : Colors.black),
                        Text('(${_responseAreaPro.amountRate})', style: TextStyle(color: Colors.yellow),)
                        ])),
                ),
              ],
            )

          ),

        ],
      ),
    );
    return Card(
      color: Colors.blueGrey,
      child: row,
    );
//    return Card(
//      child: ListTile(
//        onTap: () {
////            Navigator.of(context).push(MaterialPageRoute(
////                builder: (context) => ListPro(_responseAreaPro.id)));
//        },
//        leading: ClipRRect(
//          borderRadius: BorderRadius.circular(8.0),
//          child: Image.network(
//            _responseAreaPro.url != null ? _responseAreaPro.url : "",
//            height: 150.0,
//            width: 100.0,
//          ),
//        ),
//        title: Text(_responseAreaPro.name),
//        subtitle: Text(_responseAreaPro.about),
//      ),
//    );
  }
}