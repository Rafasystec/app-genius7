import 'package:app/response/response_pro.dart';
import 'package:flutter/material.dart';

class ProDetails extends StatelessWidget {
  final ResponsePro _responsePro;
  ProDetails(this._responsePro);
  @override
  Widget build(BuildContext context) {
    return   Card(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Colors.redAccent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _responsePro.url != null ? _responsePro.url : "",
                  height: 120.0,
                  width: 100.0,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 4.0),
                height: 120.0,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        height: 50,
                        width: 220.0,
                        child: Text(_responsePro.name,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.black,fontSize: 20.0),)),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                        width: 220.0,
                        child: Text(
                          'Bairro: ${_responsePro.address.district} ',
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black38
                          ),
                          maxLines: 2,)),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        width: 220.0,
                        child: Text(
                          '${_responsePro.attendances} Atendimentos',
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black38
                          ),
                          maxLines: 2,)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(child: Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: _responsePro.rant > 0 ? Colors.yellow[500] : Colors.black26),
                            Icon(Icons.star, color: _responsePro.rant > 1 ? Colors.yellow[500] : Colors.black26),
                            Icon(Icons.star, color: _responsePro.rant > 2 ? Colors.yellow[500] : Colors.black26),
                            Icon(Icons.star, color: _responsePro.rant > 3 ? Colors.yellow[500] : Colors.black26),
                            Icon(Icons.star, color: _responsePro.rant > 4 ? Colors.yellow[500] : Colors.black26),
                            Text('(${_responsePro.amountRate})', style: TextStyle(color: Colors.green),)
                          ])),
                    ),
                  ],
                )

            ),

          ],
        ),
      ),
    );
  }
}
