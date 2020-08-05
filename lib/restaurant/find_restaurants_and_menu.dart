import 'package:app/components/screen_util.dart';
import 'package:app/response/response_local_restaurant.dart';
import 'package:app/response/response_rating.dart';
import 'package:app/restaurant/local_restaurant_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchForMenusAndRestaurants extends StatefulWidget {
  @override
  _SearchForMenusAndRestaurantsState createState() => _SearchForMenusAndRestaurantsState();
}

class _SearchForMenusAndRestaurantsState extends State<SearchForMenusAndRestaurants> {
  //List<ResponseLocalRestaurant> restaurants;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesquisa'),),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('restaurants').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
//                  var item = restaurants[index];
                DocumentSnapshot item = snapshot.data.documents[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocalRestaurantDetailScreen(item)));
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




