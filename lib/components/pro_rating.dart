import 'package:app/response/response_pro.dart';
import 'package:app/response/response_rating.dart';
import 'package:flutter/material.dart';

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
