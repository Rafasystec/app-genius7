import 'dart:async';

import 'package:app/components/image_circle.dart';
import 'package:app/response/response_my_orders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'dialog.dart';

class ItemMenuOrder extends StatefulWidget {
  final ResponseMyOrder order;
  ItemMenuOrder(this.order);
  @override
  _ItemMenuOrderState createState() => _ItemMenuOrderState();
}

class _ItemMenuOrderState extends State<ItemMenuOrder> {
  String timeToArrive = "00:00:00";
  Stopwatch stopwatch = Stopwatch();
  bool started    = false;
  bool stopped    = true;
  int initHour    = 0;
  int initMinute  = 0;
  int initSecond  = 0;
  final duration = const Duration(seconds: 1);

  void startTime(){
    Timer(duration, keepRunning);
  }

  void keepRunning(){
    if(stopwatch.isRunning){
      startTime();
    }
    setState(() {
//      timeToArrive = (initHour+stopwatch.elapsed.inHours).toString().padLeft(2,'0')+":"
//          + ((initMinute+stopwatch.elapsed.inMinutes)%60).toString().padLeft(2,'0')+":"
//          + ((initSecond+stopwatch.elapsed.inSeconds)%60).toString().padLeft(2,'0');
      updateTimeArrival(initHour+stopwatch.elapsed.inHours, initMinute+stopwatch.elapsed.inMinutes, initSecond+stopwatch.elapsed.inSeconds);
    });
  }

  void startStopWatch(){
    setState(() {
      started = true;
      stopped = false;
    });
    stopwatch.start();
    startTime();
  }
  void stopStopWatch(){
    setState(() {
      started = false;
      stopped = true;
    });
    stopwatch.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          height: 100,
          width: 60,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: getImageFromURL(widget.order.item.iconUrl),
        ),
        title:  Column(
          children: <Widget>[
            Text(widget.order.item.description),
            //Date and time when the order was made
            Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.order.timeOrder),style: TextStyle(color: Colors.deepPurple,fontSize: 12.0),),

          ],
        ),
        subtitle: Column(
          children: <Widget>[
            Text(widget.order.item.shortDescription),
            Container(
              height: 5,
            ),
            Container(
              height: 26.0,
              width: 150,
              child: Center(
                child: RaisedButton(
                  onPressed: (){
                    Future.sync(() => onCancel())
                        .then((value) {
                      if(value){
                        //TODO cancel item on server and update view
                        Fluttertoast.showToast(msg:'Item cancelado');
//                        Navigator.of(context).pop(widget._responseCliAgenda);
                      }else{
                        Fluttertoast.showToast(msg: 'Não foi cancelado');
                      }
                    });

                  },
                  color: Colors.red,
                  child: Text('CANCELAR',style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
        trailing: Container(
          height: 60,
          width: 64,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(timeToArrive),
                Text('${widget.order.item.price}',style: TextStyle(color: Colors.green),),
                getIconsFromStatus(widget.order.status),
//                Center(
//                  child: RaisedButton(
//                    child: Text('CANCEL'),
//                  ),
//                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getIconsFromStatus(Status status){
    switch(status){
      case Status.OTHER:
        return Icon(Icons.not_listed_location,color: Colors.orange,);
        break;
      case Status.OPEN:
        return Icon(Icons.access_alarm,color: Colors.blue,);
        break;
      case Status.CLOSE:
        return Icon(Icons.check_circle_outline,color: Colors.green,);
        break;
      case Status.CANCEL:
        return Icon(Icons.cancel,color: Colors.red,);
        break;
      case Status.EXPIRED:
        return Icon(Icons.alarm_off,color: Colors.grey,);
        break;
      default:
        return Icon(Icons.warning,color: Colors.blueGrey,);
        break;
    }
  }

  @override
  void initState() {
    var iniTime = widget.order.timeOrder;
    var timeNow = DateTime.now();
    var diff = timeNow.difference(iniTime);
    initHour = diff.inHours;
    initMinute = diff.inMinutes;
    initSecond = diff.inSeconds;
    if(initHour >= 2 || widget.order.status != Status.OPEN ) {
      updateTimeArrival(initHour, initMinute, initSecond);
      widget.order.status = Status.EXPIRED;
    }else{
      startStopWatch();
    }
    super.initState();
  }
  @override
  void dispose() {
    stopStopWatch();
    super.dispose();
  }

  void updateTimeArrival(int hour,int minute,int second){
    timeToArrive = hour.toString().padLeft(2,'0')+":"
        + (minute%60).toString().padLeft(2,'0')+":"
        + (second%60).toString().padLeft(2,'0');
  }

  Future<bool> onCancel() {
    var value = openDialogYesNo(context,'Tem certeza que deseja cancelar?',title: 'Cancelar Item',icon: Icons.cancel);
    return Future.value(value);
  }
}
