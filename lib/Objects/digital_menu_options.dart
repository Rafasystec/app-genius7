import 'package:app/enums/enum_type_area.dart';

class DigitalMenuOptions{

  final int idRestaurant;
  final int idTable;
  final String refRestaurant;
  final bool isEditMode;
  final TypeArea typeArea;
  DigitalMenuOptions(this.idRestaurant,this.idTable,this.refRestaurant,this.typeArea,{this.isEditMode = false});

}