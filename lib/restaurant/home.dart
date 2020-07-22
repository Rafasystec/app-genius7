
import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/restaurant/waiter_home.dart';
import 'package:flutter/material.dart';

import 'build_menu_digital.dart';

class HomeScreenRestaurant extends StatefulWidget {
  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<HomeScreenRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurante'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              appButtonTheme(context, 'MENU DIGITAL', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenu(DigitalMenuOptions(
                1,0
              ))))),
              SizedBox(height: 10,),
              appButtonTheme(context, 'EDITAR MENU DIGITAL', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen()))),
              SizedBox(height: 10,),
              appButtonTheme(context, 'SOU GARÇOM', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => WaiterMainScreen())))
            ],
          ),
        ),
      ),
    );
  }
}
