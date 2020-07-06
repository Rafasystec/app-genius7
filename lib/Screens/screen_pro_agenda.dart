

//import 'package:app/components/event.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;



//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'dooboolab flutter calendar',
//      theme: new ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
//        // counter didn't reset back to zero; the application is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: new MyHomePage(title: 'Flutter Calendar Carousel Example'),
//    );
//  }
//}



class ScreenAgendaPro extends StatefulWidget {
  ScreenAgendaPro({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ScreenAgendaPro> {
  DateTime _currentDate = DateTime(2020, 7, 6);
  DateTime _currentDate2 = DateTime(2020, 7, 6);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2020, 7, 3));
  DateTime _targetDateTime = DateTime(2020, 7, 6);
  List<Event> _events = new List();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
//    decoration: new BoxDecoration(
//        color: Colors.white,
//        borderRadius: BorderRadius.all(Radius.circular(1000)),
//        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.calendar_today,
      color: Colors.blue,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2020, 7, 6): [
      new Event(
        date: new DateTime(2020, 7, 6,10,0,0),
        title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 6,10,0,0)),
        icon: _eventIcon,
      ),
      ],
      new DateTime(2020, 7, 10): [
        new Event(
          date: new DateTime(2020, 7, 10,10,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,10,0,0)),
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 7, 10,11,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,11,0,0)),
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 7, 10,13,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,13,0,0)),
          icon: _eventIcon,
        ),
      ],
      new DateTime(2020,7,11):[
        new Event(
          date: new DateTime(2020, 7, 11,9,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 11,9,0,0)),
          icon: _eventIcon,
        ),
      ],
      new DateTime(2020, 7, 13): [
        new Event(
          date: new DateTime(2020, 7, 13,10,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,10,0,0)),
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 7, 13,11,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,11,0,0)),
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2020, 7, 13,13,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,13,0,0)),
          icon: _eventIcon,
        ),new Event(
          date: new DateTime(2020, 7, 13,14,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,14,0,0)),
          icon: _eventIcon,
        ),new Event(
          date: new DateTime(2020, 7, 13,15,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,15,0,0)),
          icon: _eventIcon,
        ),new Event(
          date: new DateTime(2020, 7, 13,16,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,16,0,0)),
          icon: _eventIcon,
        ),new Event(
          date: new DateTime(2020, 7, 13,17,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,17,0,0)),
          icon: _eventIcon,
        ),new Event(
          date: new DateTime(2020, 7, 13,18,0,0),
          title: DateFormat('dd/MM/yyyy HH:mm').format(new DateTime(2020, 7, 10,18,0,0)),
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
//    _markedDateMap.add(
//        new DateTime(2020, 7, 25),
//        new Event(
//          date: new DateTime(2020, 7, 25),
//          title: 'Event 5',
//          icon: _eventIcon,
//        ));
//
//    _markedDateMap.add(
//        new DateTime(2020, 7, 10),
//        new Event(
//          date: new DateTime(2020, 7, 10),
//          title: 'Event 4',
//          icon: _eventIcon,
//        ));
//
//    _markedDateMap.addAll(new DateTime(2020, 7, 11), [
//      new Event(
//        date: new DateTime(2020, 7, 11),
//        title: 'Event 1',
//        icon: _eventIcon,
//      ),
//      new Event(
//        date: new DateTime(2020, 7, 11),
//        title: 'Event 2',
//        icon: _eventIcon,
//      ),
//      new Event(
//        date: new DateTime(2019, 2, 11),
//        title: 'Event 3',
//        icon: _eventIcon,
//      ),
//    ]);
  print('Event size ${_events.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.blue,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        print('current date date $_currentDate2');
//        _events = new List();
        events.forEach((event) => print(event.title));
//        events.forEach((event) => _events.add(event));
      _events = events;
      },
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(
          side: BorderSide(color: Colors.red)
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.white,
      ),
       markedDateShowIcon: true,
      markedDateMoreShowTotal: true,
      todayButtonColor: Colors.blue,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      selectedDayButtonColor: Colors.purple,
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },

    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //custom icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarousel,
              ), // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: EdgeInsets.only(
                  top: 8.0,
                  bottom: 2.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          _currentMonth,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        )),
                    FlatButton(
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month -1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    FlatButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month +1);
                          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 260,
//                color: Colors.blue,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ), //
              Container(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 2),
                height: 250,
                child: GetEventList(_events),
              )
            ],
          ),
        ));
  }
}

class GetEventListState extends State<GetEventList>{
//  final List<Event> _events ;
//  GetEventListState(this._events);
  @override
  Widget build(BuildContext context) {
//    _events.add(Event(title: 'Text 1 ',date:  DateTime(2020, 7, 6)));
    return ListView.builder(
        itemCount: widget._events.length,
        itemBuilder: (BuildContext context , int index){
          var event = widget._events[index];
          return InkWell(
            onTap: (){
              int mod = index%2;
              if(mod == 0){
                _showMyDialog('Aviso', 'Essa agenda está ocupada');
              }else{
                _showMyDialog('Confirmação', 'O profissional receberá sua solicitação da agenda e irá responser se aceita ou não. Por favor aguarde a confimação do profissional.');
              }
            },
            child: Container(
              height: 50,
              child: Card(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today,color: Colors.blue,),
                    Text(event.title),
                    Visibility(
                      visible: index%2 == 0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.alarm_off,color: Colors.red,),
                            Text(' ocupada',style: TextStyle(color: Colors.red),)
                          ],
                        )),
                    Visibility(
                      visible: index%2 > 0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.alarm_on,color: Colors.green,),
                            Text(' marcar',style: TextStyle(color: Colors.green),)
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> _showMyDialog(String title, String body) async {
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

class GetEventList extends StatefulWidget {
  final List<Event> _events ;//= new List();
  GetEventList(this._events);
  @override
  State<StatefulWidget> createState() {
    return GetEventListState();
  }
}

