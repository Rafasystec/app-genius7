
import 'package:app/Objects/category_item.dart';

class ResponseMyOrder{


  final DateTime timeOrder;
  final CategoryItem item;
  Status status;
  ResponseMyOrder(this.item,this.timeOrder,this.status);

}


enum Status{
  OTHER,
  OPEN,
  CLOSE,
  CANCEL,
  EXPIRED
}