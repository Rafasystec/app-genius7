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
    WaiterTable(25,58,1,EnumTableStatus.OPEN),
    WaiterTable(26,59,1,EnumTableStatus.OPEN),
    WaiterTable(27,60,1,EnumTableStatus.BUSY),
    WaiterTable(28,61,1,EnumTableStatus.BUSY),
    WaiterTable(29,80,1,EnumTableStatus.RESERVED),
    WaiterTable(30,80,1,EnumTableStatus.RESERVED),
    WaiterTable(31,82,1,EnumTableStatus.RESERVED),
    WaiterTable(32,83,1,EnumTableStatus.RESERVED),
    WaiterTable(33,90,1,EnumTableStatus.RESERVED),
    WaiterTable(34,101,1,EnumTableStatus.RESERVED),
    WaiterTable(35,103,1,EnumTableStatus.RESERVED),
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MESAS'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
//            padding: EdgeInsets.all(8),
//            height: 500,
              child: ListView.builder(
                itemCount: waiter.tables != null ? waiter.tables.length : 0,
                 itemBuilder: (BuildContext context, int index){
                   var table = waiter.tables[index];
                   return Column(
                     children: <Widget>[
                       SizedBox(height: 10,),
                       appButtonTable(context, table, (){
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
  Widget appButtonTable(BuildContext context,WaiterTable table, VoidCallback onPressedAction,{double minWidth = 220.0,double height = 70.0} ){
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: Colors.red),
          ),
          onPressed: onPressedAction,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Text(getTableLabelDescription(table), style: TextStyle(fontSize: 16.0)),
              getIconTableFromStatus(table),
              ]
          ),
          color: getColorFromStatus(table),
          highlightColor: Color(0xffff7f7f),
          splashColor: Colors.transparent,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
    );
  }

  Widget getIconTableFromStatus(WaiterTable table){
    switch(table.status){
    case EnumTableStatus.OPEN :
      return Icon(Icons.check_circle);
      break;
    case EnumTableStatus.BUSY:
      return Icon(Icons.cancel);
      break;
    case EnumTableStatus.RESERVED:
      return Icon(Icons.restaurant);
      break;
    default :
      return Icon(Icons.warning);
    break;
    }
  }

  Color getColorFromStatus(WaiterTable table){
    switch(table.status){
      case EnumTableStatus.OPEN :
        return Color(0xff2ea44f);
        break;
      case EnumTableStatus.RESERVED :
        return Color(0xff17a2b8);
        break;
      default :
        return Color(0xffdd4b39);
        break;
    }
  }

  String getTableLabelDescription(WaiterTable table){
    String result = 'MESA: ${table.number}';
    switch(table.status){
      case EnumTableStatus.OPEN :
        result += ' - LIVRE';
        break;
      case EnumTableStatus.BUSY:
        result += ' - OCUPADA';
        break;
      case EnumTableStatus.RESERVED:
        result += ' - RESERVADA';
        break;
      default :
        result += ' ';
        break;
    }
    return result;
  }
}
