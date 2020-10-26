import 'package:app/Objects/digital_menu_options.dart';
import 'package:app/Screens/digital_menu.dart';
import 'package:app/components/gallery_view.dart';
import 'package:app/components/rating_comment.dart';
import 'package:app/components/screen_util.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/util/app_locations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class LocalRestaurantDetailScreen extends StatefulWidget {
  final DocumentSnapshot restaurant;
  final TypeArea typeArea;
  LocalRestaurantDetailScreen(this.restaurant,this.typeArea);
  @override
  _LocalRestaurantDetailScreenState createState() => _LocalRestaurantDetailScreenState();
}

class _LocalRestaurantDetailScreenState extends State<LocalRestaurantDetailScreen> {
  bool _isLogged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant['name']),),
      body: Column(
        children: <Widget>[

          getItemLocalRestaurantDetail(widget.restaurant),
          Container(
            height: 15,
          ),
          GalleryView(getGalleryItems(getStringList(widget.restaurant['images']))),
          Container(
            height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  appButtonTheme(context, 'VER LOCAL', ()=>openMapsSheet(context,
                                      widget.restaurant['name'],
                                      widget.restaurant['address']
                                      ,Coords(widget.restaurant['lat'],widget.restaurant['long'])),minWidth: 100),
                  SizedBox(width: 20,),
                  appButtonTheme(context,
                      widget.typeArea == TypeArea.RESTAURANT ? AppLocalizations.of(context).translate('see_menu') : AppLocalizations.of(context).translate('products'),
                      ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenDigitalMenu(DigitalMenuOptions(2,0,widget.restaurant.documentID,TypeArea.RESTAURANT)))) ,minWidth: 100),
                ],
              )
          ),
          SizedBox(height: 10,),
          Expanded(
            child: StreamBuilder(
                stream: Firestore.instance.collection(widget.restaurant.reference.path+'/reviews').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return const Text('Loading...');
                  return RatingComment(snapshot,widget.restaurant.reference.path,isLogged: _isLogged,);
                }
            ),
          ),
        ],
      ),
    );
  }

  openMapsSheet(context, final String title, final String description, Coords coords) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  List<String> getStringList(List<dynamic> list){
    List<String> result = List();
    for(dynamic item in list){
      result.add(item as String);
    }
    return result;
  }

}
