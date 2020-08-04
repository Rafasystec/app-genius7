import 'package:app/util/app_locations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoriesScreen extends StatefulWidget {
  final String refRestaurant;
  CategoriesScreen(this.refRestaurant);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('categories')),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Fluttertoast.showToast(msg: 'That will save and list categories');
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
                child: Text('The first thing you need to do is register the categories of your menu')),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Center(
                        child: Text('Category name'),
                      ),
                      IconButton(
                        onPressed: (){

                        },
                        icon: Icon(Icons.add),
                      )
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add,color: Colors.black,),
        backgroundColor: Color(0xfff5a623),
      ),
    );
  }
}
