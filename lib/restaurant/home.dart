
import 'package:app/Objects/category.dart';
import 'package:app/Objects/category_item.dart';
import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Objects/menu.dart';
import 'package:app/Objects/point.dart';
import 'package:app/Objects/restaurant.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/choice.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/const.dart';
import 'package:app/main.dart';
import 'package:app/restaurant/qrcode_screen.dart';
import 'package:app/restaurant/settings.dart';
import 'package:app/restaurant/waiter_home.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/file_util.dart';
import 'package:app/util/preference_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreenRestaurant extends StatefulWidget {
  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<HomeScreenRestaurant> {
  SharedPreferences prefs;
  String userId;
  String restaurantDoc;
  List<Choice> choices = const <Choice>[
    const Choice(0, title: 'Perfil', icon: Icons.settings),
    const Choice(1, title: 'Log out', icon: Icons.exit_to_app),
  ];
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void initState() {
    readLocal();
    getEstablishmentsFromThatUser();
    super.initState();
  }

  Future getEstablishmentsFromThatUser() async {
    //------------------------------------------------------------
    //NOTE: we need to check if the user has one restaurant or more
    //------------------------------------------------------------
    prefs = await SharedPreferences.getInstance();
    bool hasMore = prefs.getBool(HAS_MORE_ESTABLISHMENTS) == null ? false : prefs.getBool(HAS_MORE_ESTABLISHMENTS);
    if(!hasMore) {
      var address = prefs.getString(REST_ADDRESS);
      if( address == null || address.isEmpty) {
        final QuerySnapshot result = await Firestore.instance.collection(
            COLLECTION_RESTAURANT).where(
            'user-ref', isEqualTo: prefs.getString(USER_REF)).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 1) {
          PreferenceUtil.setRestPreferenceFromDocument(documents[0]);
        } else if (documents.length > 1) {
          prefs.setBool(HAS_MORE_ESTABLISHMENTS, true);
        }
      }
    }
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(USER_REF);
    restaurantDoc = prefs.getString(RESTAURANT_PATH);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('restaurant')),
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
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(AppLocalizations.of(context).translate('see_my_menu_digital_explain')),
                ),
              ),
              appButtonTheme(context, AppLocalizations.of(context).translate('my_digital_menu'), ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenu(DigitalMenuOptions(
                1,0,restaurantDoc
              ))))),
              SizedBox(height: 10,),
              appButtonTheme(context, 'EDITAR MENU DIGITAL', (){
                Future.sync(() => seeDigitalMenu());
              }),
              SizedBox(height: 10,),
              appButtonTheme(context, 'GERAR QR-CODE', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRCodeScreen(restaurantDoc)));
              }),
              SizedBox(height: 10,),
              Visibility(visible: false, child: appButtonTheme(context, 'SOU GARÇOM', ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => WaiterMainScreen()))))
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
//        Restaurant restaurant = await getRestaurantFromFirebase(restaurantDoc);
//        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen(restaurant)));
        if(restaurantDoc == null || restaurantDoc.isEmpty){
            restaurantDoc = prefs.getString(RESTAURANT_PATH);
        }
        var options = DigitalMenuOptions(1, 2,restaurantDoc,isEditMode: true);
        Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ScreenDigitalMenu(options)));
//      }

//    }
  }

  Future<Restaurant> getRestaurantFromFirebase(String dofRefRestaurant) async{
    Menu digitalMenu = Menu();
    QuerySnapshot result = await Firestore.instance.collection(COLLECTION_RESTAURANT).where(FB_REST_ID, isEqualTo: dofRefRestaurant).getDocuments();
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
                  formatCurrency(price), icon,item.reference.path));
            }
          }
          digitalMenu.categories.add(Category(0, descCateg, categItens));
        }
      }
      Restaurant restaurant = Restaurant(0, ref, active,
          Point(documents[0]['lat'], documents[0]['long']),
          digitalMenu);
      return restaurant;
      }else{
        return null;
      }
  }

  void onItemMenuPress(Choice choice) async {
    if (choice.id == 1) {
      handleSignOut();
    } else {
      prefs = await SharedPreferences.getInstance();
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenSettings(prefs.getString(USER_REF))));
    }
  }


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

      prefs = await SharedPreferences.getInstance();
      prefs.clear();
//      PreferenceUtil.clear(prefs);

      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
    }

}
