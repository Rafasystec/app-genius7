import 'package:app/Objects/menu.dart';
import 'package:app/Objects/point.dart';

class Restaurant{
  final int id;
  final String docRef;
  final bool active;
  final Point point;
  final Menu menu;
  Restaurant(this.id,this.docRef,this.active,this.point,this.menu);

}