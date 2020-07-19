import 'package:app/Objects/waiter_table.dart';

class Waiter{
  final int id;
  final String name;
  final List<WaiterTable> tables;

  Waiter(this.id,this.name,this.tables);
}