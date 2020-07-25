
import 'package:app/Objects/category.dart';
import 'package:app/Objects/category_item.dart';
import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Objects/menu.dart';
import 'package:app/Objects/point.dart';
import 'package:app/Objects/restaurant.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/const.dart';
import 'package:app/login.dart';
import 'package:app/restaurant/waiter_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'build_menu_digital.dart';

class HomeScreenRestaurant extends StatefulWidget {
  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<HomeScreenRestaurant> {
  SharedPreferences prefs;
  String userId;
  String restaurantDoc;
  @override
  void initState() {
    readLocal();
    super.initState();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(ID_USER_CLI_FIREBASE);
    restaurantDoc = prefs.getString(RESTAURANT_PATH);
  }
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
              appButtonTheme(context, 'EDITAR MENU DIGITAL', (){
                Future.sync(() => seeDigitalMenu());
              }),
              SizedBox(height: 10,),
              appButtonTheme(context, 'SOU GARÇOM', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => WaiterMainScreen())))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> seeDigitalMenu() async{
//    if(userId == null){
//      //TODO call login page
//      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
//    }else{
        Restaurant restaurant = await getRestaurantFromFirebase(restaurantDoc);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen(restaurant)));
//      }

//    }
  }

  Future<Restaurant> getRestaurantFromFirebase(String dofRefRestaurant) async{
    Menu digitalMenu = Menu();
    QuerySnapshot result = await Firestore.instance.collection('restaurants').where('id', isEqualTo: dofRefRestaurant).getDocuments();
    if(result.documents.length > 0) {
      final List<DocumentSnapshot> documents = result.documents;
      var id = documents[0]['id'];
      var ref = documents[0].documentID;
      var active = documents[0]['active'];
      QuerySnapshot menu = await documents[0].reference.collection("menu")
          .getDocuments();
      if (menu.documents.length > 0) {
        final List<DocumentSnapshot> categories = menu.documents;
        digitalMenu.categories = new List();
        for (DocumentSnapshot category in categories) {
          var refCateg = category.documentID;
//            int idCateg       = category['id'];
          String descCateg = category['desc'];
          QuerySnapshot itemsCollection = await category.reference.collection(
              "itens").getDocuments();
          List<CategoryItem> categItens = new List();
          if (itemsCollection.documents.length > 0) {
            for (DocumentSnapshot item in itemsCollection.documents) {
              var ref = item.documentID;
              var code = item['code'];
              var desc = item['desc'];
              var detail = item['detail'];
              var price = item['price'];
              var rate = item['rate'];
              var icon = item['icon'];
              categItens.add(CategoryItem(0, desc, detail, rate,
                  formatCurrency(price), icon));
            }
          }
          digitalMenu.categories.add(Category(0, descCateg, categItens));
        }
      }
      Restaurant restaurant = Restaurant(id, ref, active,
          Point(documents[0]['lat'], documents[0]['long']),
          digitalMenu);
      return restaurant;
      }else{
        return null;
      }
  }

}
