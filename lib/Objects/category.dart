import 'package:app/Objects/category_item.dart';

class Category{
  final int id;
  final String description;
  final List<CategoryItem> itens;
  Category(this.id,this.description,this.itens);
}