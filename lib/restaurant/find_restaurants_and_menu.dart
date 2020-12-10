import 'package:app/components/screen_util.dart';
import 'package:app/const.dart';
import 'package:app/enums/enum_type_area.dart';
import 'package:app/response/response_local_restaurant.dart';
import 'package:app/response/response_rating.dart';
import 'package:app/restaurant/local_restaurant_detail.dart';
import 'package:app/util/app_locations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
///This will be use to products too.
class SearchForMenusAndRestaurants extends StatefulWidget {
  final TypeArea type;
  SearchForMenusAndRestaurants(this.type);
  @override
  _SearchForMenusAndRestaurantsState createState() => _SearchForMenusAndRestaurantsState();
}

class _SearchForMenusAndRestaurantsState extends State<SearchForMenusAndRestaurants> {
  //List<ResponseLocalRestaurant> restaurants;
  String currentCollection;
  @override
  void initState() {
    if(widget.type == TypeArea.SALES){
      currentCollection = COLLECTION_STORE;
    }else{
      currentCollection = COLLECTION_RESTAURANT;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate('search')),),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection(currentCollection).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Text(AppLocalizations.of(context).translate('loading_bar'));
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                DocumentSnapshot item = snapshot.data.documents[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocalRestaurantDetailScreen(item,widget.type)));
                    },
                      child: getItemLocalRestaurantDetail(item)
                  );
                });
          }
        ),
      ),
    );
  }
}




