import 'package:app/Objects/category_item.dart';
import 'package:app/components/image_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget getItemDetail(CategoryItem item){
  return Container(
    height: 100,
    child: Card(
      child: ListTile(
        leading: Container(
          height: 100,
          width: 60,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: getImageFromURL(item.iconUrl),
        ),
        title: Text(item.description),
        subtitle: Text(item.shortDescription),
        trailing: Container(
          height: 60,
          width: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('${NumberFormat("###.0#").format(item.rate ?? 0) }'),
                  Icon(Icons.star,color: Colors.yellowAccent,),
                ],
              ),
              Text('${item.price}',style: TextStyle(color: Colors.green),),
            ],
          ),
        ),
      ),
    ),
  );
}