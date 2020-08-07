import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/Screens/agenda_cli_detail.dart';
import 'package:app/Screens/group_area_list.dart';
import 'package:app/response/response_cli_agenda.dart';
import 'package:app/webservice/cli_ws.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//------------------------------------------------------
//TODO put de chat in other screen
//------------------------------------------------------
//import 'package:flutter_chat_demo/chat.dart';
//------------------------------------------------------
//import 'package:flutter_chat_demo/const.dart';
//import 'package:flutter_chat_demo/settings.dart';
//import 'package:flutter_chat_demo/widget/loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Screens/cli_agenda_detail.dart';
import 'components/centered_message.dart';
import 'components/choice.dart';
import 'components/loading.dart';
import 'components/progress_bar.dart';
import 'const.dart';
import 'main.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId);
}

class HomeScreenState extends State<HomeScreen> {
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



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
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
        child: Stack(
          children: <Widget>[
            FutureBuilder<List<ResponseCliAgenda>>(
              future: Future.delayed(Duration(seconds: 1)).then((value) => getAllCliAgenda(0)),
              builder: (context,snapshot){
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return ProgressBar();
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:

                    if(snapshot.hasError){
                      return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
                    }else{
                      if(snapshot.hasData) {
                        agendas = snapshot.data;
                        if(agendas == null || agendas.isEmpty) {
                          return showEmptyListMessage(context);
                        }else{
                          return listCliAgenda();
                        }
                      } else{
                        return showEmptyListMessage(context);
                      }
                    }
//                    if(snapshot.hasData) {
//                      agendas = snapshot.data;
//                      if(agendas == null || agendas.isEmpty) {
//                        return showEmptyListMessage(context);
//                      }else{
//                        return listCliAgenda();
//                      }
//
//                    }else if(snapshot.hasError){
//                      return CenteredMessage('Sorry! We got an error',icon: Icons.error,);
//                    }
                    break;
                }
                return CenteredMessage('No entry found!',icon: Icons.warning,);
              },
            ),
            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        //onWillPop: onBackPress,
      ),
    );
  }

  Center showEmptyListMessage(BuildContext context) {
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(
              Icons.info_outline,
              size: 50,
              color: themeColor,
            ),
            visible: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 20, 2, 8),
            child: SizedBox(
              child: FlatButton(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16,color: primaryColor),
                    text: 'Você ainda não possui nenhuma agenda, para agendar um serviço primeiro procure pelo o profissional clicando no ícone de calendário',
                    children: <TextSpan>[
                      TextSpan(text: ' ou clique nessa mensagem.', style: TextStyle(color: Colors.blueAccent))
                    ],
                  ),
                ),
                onPressed: (){
                  goToGroupAreas(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToGroupAreas(BuildContext context) {
     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenGroupAreas()));
  }

  Widget listCliAgenda(){
    return ListView.builder(
        itemCount: agendas.length,
        itemBuilder: (BuildContext context,int index){
          var item = agendas[index];//list[index];
          return GestureDetector(
            onTap: () async{
              final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenCliAgendaDetail(item)));
              if(result != null) {
                setState(() {
                  agendas.remove(result);
                });
              }
            },
            child: Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today,color: Colors.blue,size: 50.0,),
                title: Text(item.date),
                subtitle: Text(item.namePro),
                trailing: Icon(Icons.more_vert),
              ),
            ),
          );
        }
    );
  }

}

