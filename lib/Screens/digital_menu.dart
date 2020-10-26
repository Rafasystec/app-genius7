import 'package:app/Objects/category.dart';
import 'package:app/Objects/category_item.dart';
import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu_item.dart';
import 'package:app/Screens/digital_menu_my_orders.dart';
import 'package:app/components/choice.dart';
import 'package:app/components/dialog_with_field.dart';
import 'package:app/components/digital_menu_item.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/components/scroll_parent.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/response/response_menu_item.dart';
import 'package:app/restaurant/build_menu_digital.dart';
import 'package:app/restaurant/settings.dart';
import 'package:app/util/app_locations.dart';
import 'package:app/util/file_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';


class ScreenDigitalMenu extends StatefulWidget {
  final DigitalMenuOptions options;
  //final TypeArea typeArea;
//  ScreenDigitalMenu(this.options,{this.typeArea = TypeArea.RESTAURANT});
  ScreenDigitalMenu(this.options);
  @override
  _ScreenDigitalMenuState createState() => _ScreenDigitalMenuState();
}

class _ScreenDigitalMenuState extends State<ScreenDigitalMenu> {
  ScrollController _controller;
  String category;
  List<Choice> menuChoices = const <Choice>[
    const Choice(0,title: 'Pedidos', icon: Icons.bookmark_border),
//    const Choice(1,title: 'Fechar', icon: Icons.close),
//    const Choice(2,title: 'Log out', icon: Icons.exit_to_app),
  ];
  List<Category> _categories;
  SharedPreferences prefs;

  @override
  void initState() {
    _controller = ScrollController();
//    Future<List<Category>> future = getCategories();
//    future.then((value) => _categories = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text( widget.options.typeArea == TypeArea.RESTAURANT ? AppLocalizations.of(context).translate('menu') : AppLocalizations.of(context).translate('catalog')),
        actions: <Widget>[
          Visibility(
//            visible: !widget.options.isEditMode,
            visible: false,
            child: PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return menuChoices.map((Choice choice) {
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
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: widget.options.isEditMode,
        child: FloatingActionButton.extended(
          onPressed: () async{
            var refRest = widget.options.refRestaurant;
            if(refRest == null || refRest.isEmpty) {
              prefs = await SharedPreferences.getInstance();
              Fluttertoast.showToast(msg: 'Você precisa configurar o ser perfil primeiro.');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenSettings(prefs.getString(USER_REF),widget.options.typeArea)));
            }else {
              category = await onGetCategoryName();
              print('save category: $category');
              if (refRest != null && refRest.isNotEmpty) {
                Firestore.instance.collection(
                    getCollection()).add({
                  'desc': category}).then((value) {
                  if (value != null) {
                    Fluttertoast.showToast(
                        msg: AppLocalizations.of(context).translate('saved'));
                    print('Document ID: ${value.documentID}');
                  }
                });
              } else {

              }
            }
          },
          label: Text(AppLocalizations.of(context).translate('add_category'),style: TextStyle(color: Colors.black),),
          icon: Icon(Icons.add,color: Colors.black,semanticLabel: AppLocalizations.of(context).translate('add_category'),),
          backgroundColor: Color(0xfff5a623),
        ),
      ),
      body:  StreamBuilder(
        stream: Firestore.instance.collection(getCollection()).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return buildListView(snapshot);
        }
      ),
    );
  }

  String getCollection() {
    if(widget.options.typeArea == TypeArea.RESTAURANT) {
      return '$COLLECTION_RESTAURANT/${widget.options.refRestaurant}/menu';
    }else {
      return '$COLLECTION_STORE/${widget.options.refRestaurant}/menu';
    }
  }

    Widget buildListView(AsyncSnapshot snapshot) {
      return snapshot.data.documents.length > 0 ? ListView.builder(
          padding: const EdgeInsets.all(2),
          controller: _controller,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot item = snapshot.data.documents[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(item['desc'],style: TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic),),
                      Visibility(
                        visible: widget.options.isEditMode,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Colors.red),
                          ),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen(widget.options.refRestaurant, item.documentID,widget.options.typeArea)));
                          },
                          child: Text(AppLocalizations.of(context).translate('add_item')),
                        ),
                      )
                    ]),
                Container(
                  height: 250,
                  child: StreamBuilder(
                      stream: item.reference.collection("itens").snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) return const Text('Loading...');
                        return (snapshot.data.documents.length > 0  ? listCategoryItem(snapshot.data.documents)
                            : buildContainerToAddItem(context,item));
                      }
                  ),
                ),
              ],
            );
          }
      ) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text('Nenhuma categoria ainda')),
      );
    }

    Widget buildContainerToAddItem(BuildContext context, DocumentSnapshot category) {
      return widget.options.isEditMode ? Container(
        height: 50.0,
        child: appButtonTheme(context,'Add the first item \n for ${category['desc']}?',(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen(widget.options.refRestaurant,category.documentID,widget.options.typeArea)));
        },height: 50.0),
      ) : SizedBox(height: 5,);
    }

    Widget listCategoryItem(List<DocumentSnapshot> docs){
      return ScrollParent(
        child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context,int index){
              DocumentSnapshot item = docs[index];
              return GestureDetector(
                onTap: () async{
                  if(widget.options.isEditMode){
                    ResponseMenuItem menuItem = ResponseMenuItem(item['desc'],item['category'],item['detail'],item['price'].toDouble(),getImagesFromSnapshot(item['images']),item['id'],item['icon'],item['rate']);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuildDigitalMenuScreen(widget.options.refRestaurant,item['category'],widget.options.typeArea , isEdit: true,item: menuItem,)));
                  }else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ScreenDigitalMenuItem(
                                categoryItemFromSnapshot(item))));
                  }
                  //Fluttertoast.showToast(msg: 'Click');
                },
                child: getItemDetail(categoryItemFromSnapshot(item)),
              );
            }
        ),
        controller: _controller,
      ) ;
    }

    CategoryItem categoryItemFromSnapshot(DocumentSnapshot item) => CategoryItem(0,item['desc'],item['detail'],item['rate'],formatCurrency(item['price']),item['icon'],item.reference.path, listImagesUrl: getImagesFromSnapshot(item['images']));

    void onItemMenuPress(Choice choice) {
      if (choice.id == 0) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenuMyOrders()));
      }
    }



    Future<String> onGetCategoryName() {
      var value = openDialogField(context,title: AppLocalizations.of(context).translate('category_name'));
      return Future.value(value);
    }
  }




