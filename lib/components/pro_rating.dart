import 'package:app/components/screen_util.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/response/response_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProRating extends StatelessWidget {
  final ResponseRating _rating;
  ProRating(this._rating);
  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children : <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(_rating.url != null ? _rating.url:""),
            ),
//            Icon(Icons.star)
          ] ,
        ),
        title: Text(_rating.name),
        subtitle: Text(
        _rating.comment
        ),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
    ));
  }
}

Widget buildRatingFromSnapshot(BuildContext context,DocumentSnapshot item){
  ResponseRating rating = ResponseRating(
        item['avatar'], item['user-name'], item['comment']);
    return ProRating(rating);

}
