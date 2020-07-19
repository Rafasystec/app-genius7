import 'dart:async';

import 'package:app/Objects/category_item.dart';
import 'package:app/components/image_circle.dart';
import 'package:app/components/item_order_detail.dart';
import 'package:app/response/response_my_orders.dart';
import 'package:flutter/material.dart';

class ScreenDigitalMenuMyOrders extends StatefulWidget {

  @override
  _ScreenDigitalMenuMyOrdersState createState() => _ScreenDigitalMenuMyOrdersState();
}

class _ScreenDigitalMenuMyOrdersState extends State<ScreenDigitalMenuMyOrders> {

  List<ResponseMyOrder> list = <ResponseMyOrder>[
    ResponseMyOrder(
        CategoryItem(1,'058 - PEIXE A CANOA','peixe frito inteiro com arroz, batata frita, baião de 2 e farofa',4,'R\$ 78,50','https://media-cdn.tripadvisor.com/media/photo-s/11/07/1e/74/peixe-frito.jpg'),
        DateTime(2020,7,18,11,20),Status.OPEN),
    ResponseMyOrder(
        CategoryItem(1,'058 - PEIXE A CANOA','peixe frito inteiro com arroz, batata frita, baião de 2 e farofa',4,'R\$ 78,50','https://media-cdn.tripadvisor.com/media/photo-s/11/07/1e/74/peixe-frito.jpg'),
        DateTime(2020,7,18,11,40),Status.CLOSE)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('Total da conta ate o momento: '),
                                Text('R \$ 120,00',style: TextStyle(color: Colors.red),)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Tempo de permanência na mesa:'),
                                Text('1 h e 18 min',style: TextStyle(color: Colors.red),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var order = list[index];
                        return Container(
//                  child: getItemDetail(order),
                          child: ItemMenuOrder(order),
                        );
                      }
                  ),
                ),

              ],
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.access_alarm,color: Colors.blue,),
                  Text('Esperando', style: TextStyle(color: Colors.blue))
                ],
              ),
              Container(
                height: 10,
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.check_circle_outline,color: Colors.green,),
                  Text('Entregue', style: TextStyle(color: Colors.green),)
                ],
              ),
              Container(
                height: 10,
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.cancel,color: Colors.red,),
                  Text('Cancelado', style: TextStyle(color: Colors.red))
                ],
              ),
              Container(
                height: 10,
                width: 10,
              ),
              Column(
                children: <Widget>[
                  Icon(Icons.alarm_off,color: Colors.grey,),
                  Text('Expirou', style: TextStyle(color: Colors.grey))
                ],
              )
            ],
          ),
        ],
      )


    );
  }
}
