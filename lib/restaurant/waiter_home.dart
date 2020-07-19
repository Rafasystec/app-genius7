import 'package:app/Objects/waiter.dart';
import 'package:app/Objects/waiter_table.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/restaurant/table_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WaiterMainScreen extends StatefulWidget {
//  final Waiter waiter;
//  WaiterMainScreen(this.waiter);
  @override
  _WaiterMainScreenState createState() => _WaiterMainScreenState();
}

class _WaiterMainScreenState extends State<WaiterMainScreen> {
  //TODO Check if is logged in and get info on server
  Waiter waiter = new Waiter(1, 'João Kamargo', <WaiterTable>[
    WaiterTable(25,58,1),
    WaiterTable(26,59,1),
    WaiterTable(27,60,1),
    WaiterTable(28,61,1),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESAS'),
      ),
      body: Container(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              height: 500,
              child: ListView.builder(
                itemCount: waiter.tables != null ? waiter.tables.length : 0,
                 itemBuilder: (BuildContext context, int index){
                   var table = waiter.tables[index];
                   return Column(
                     children: <Widget>[
                       SizedBox(height: 10,),
                       appButtonTheme(context, 'MESA: ${table.number}', (){
                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => TableDetailScreen(table)));
                       })
                     ],
                   );
                 },
              ),
            )
          ],
        ),
      ),
    );
  }
}
