import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/Screens/group_area_list.dart';
import 'package:app/components/empty_message.dart';
import 'package:app/response/response_cli_agenda.dart';
import 'package:app/util/app_locations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app/const.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Screens/cli_agenda_detail.dart';
import 'components/choice.dart';
import 'const.dart';
import 'main/main_widget.dart';
import 'settings.dart';

class HomeScreenCostumerService extends StatefulWidget {
  final String currentUserId;

  HomeScreenCostumerService({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreenCostumerService> {
  HomeScreenState({Key key, @required this.currentUserId});


  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  List<ResponseCliAgenda> agendas = new List();
  List<Choice> choices = const <Choice>[
    const Choice(0, title: 'Perfil', icon: Icons.settings),
    const Choice(1, title: 'Log out', icon: Icons.exit_to_app),
  ];


  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();

  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid ? showNotification(message['notification']) : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      //TODO see where to put this token later
//      Firestore.instance.collection('users').document(currentUserId).updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS     = new IOSInitializationSettings();
    var initializationSettings        = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }



  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.flutterchatdemo' : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }


  @override
  Widget build(BuildContext context) {
    final String homeLabel = AppLocalizations.of(context).translate('key');
    Future<Null> handleSignOut() async {
      this.setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      this.setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
    }

    void onItemMenuPress(Choice choice) {
      if (choice.id == 1) {
        handleSignOut();
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
      }
    }

    Widget getMainContent(){
      return Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection(COLLECTION_AGENDA).where('user-ref', isEqualTo: widget.currentUserId).snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData) return Center(
                child:CircularProgressIndicator()
            );
            if(snapshot.hasData && snapshot.data.documents.length > 0) {
              return getListViewBuild(snapshot);
            }if(snapshot.hasError){
              return Center(
                child: Text(
                    AppLocalizations.of(context).translate('error_on_load_data')
                ),
              );
            }else {
              return EmptyMessage(
                  AppLocalizations.of(context).translate('click_on_agenda_message')
                  ,spanMessage: AppLocalizations.of(context).translate('or_click_here'),onPressed: (){goToGroupAreas(context);});
            }
          },
        ),
      );
    }



    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('home_screen'),
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
          ],

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToGroupAreas(context);
        },
        child: Icon(Icons.calendar_today,color: Colors.black,),
        backgroundColor: Color(0xfff5a623),
      ),
      body: WillPopScope(
        child: getMainContent(),
        //onWillPop: onBackPress,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }

  ResponseCliAgenda documentToAgenda(DocumentSnapshot doc){
    if(doc != null){
      return ResponseCliAgenda(doc['id'],doc['date'],doc['name_pro'],null);
    }else return null;
  }

  ListView getListViewBuild(AsyncSnapshot snapshot){
    return ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot item = snapshot.data.documents[index];
          return GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        ScreenCliAgendaDetail(
                            documentToAgenda(item))));
                if (result != null) {
                  setState(() {
                    agendas.remove(result);
                  });
                }
              },
              child: getCarPro(documentToAgenda(item))
          );
        });
  }

  void goToGroupAreas(BuildContext context) {
     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenGroupAreas()));
  }

//  Widget listCliAgenda(){
//    return ListView.builder(
//        itemCount: agendas.length,
//        itemBuilder: (BuildContext context,int index){
//          var item = agendas[index];//list[index];
//          return GestureDetector(
//            onTap: () async{
//              final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenCliAgendaDetail(item)));
//              if(result != null) {
//                setState(() {
//                  agendas.remove(result);
//                });
//              }
//            },
//            child:
//          );
//        }
//    );
//  }
  Widget getCarPro(ResponseCliAgenda agenda){
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today,color: Colors.blue,size: 50.0,),
        title: Text('agenda.date'),
        subtitle: Text('agenda.namePro'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}

//Stack(
//children: <Widget>[
//FutureBuilder<List<ResponseCliAgenda>>(
//future: Future.delayed(Duration(seconds: 1)).then((value) => getAllCliAgenda(0)),
//builder: (context,snapshot){
//switch(snapshot.connectionState) {
//case ConnectionState.none:
//break;
//case ConnectionState.waiting:
//return ProgressBar();
//break;
//case ConnectionState.active:
//break;
//case ConnectionState.done:
//
//if(snapshot.hasError){
//return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
//}else{
//if(snapshot.hasData) {
//agendas = snapshot.data;
//if(agendas == null || agendas.isEmpty) {
//return showEmptyListMessage(context);
//}else{
//return listCliAgenda();
//}
//} else{
//return showEmptyListMessage(context);
//}
//}
////                    if(snapshot.hasData) {
////                      agendas = snapshot.data;
////                      if(agendas == null || agendas.isEmpty) {
////                        return showEmptyListMessage(context);
////                      }else{
////                        return listCliAgenda();
////                      }
////
////                    }else if(snapshot.hasError){
////                      return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
////                    }
//break;
//}
//return CenteredMessage('No entry found!',icon: Icons.warning,);
//},
//),
//// Loading
//Positioned(
//child: isLoading ? const Loading() : Container(),
//)
//],
//),

