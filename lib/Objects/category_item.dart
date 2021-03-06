import 'package:app/response/response_rating.dart';

class CategoryItem{
  final int id;
  final String description;
  final String shortDescription;
  final num rate;
  final String price;
  final String iconUrl;
  final String ref;
  final List<String> listImagesUrl;
  final List<ResponseRating> ratings;

  CategoryItem(this.id,this.description,this.shortDescription,this.rate,this.price,this.iconUrl,this.ref,{this.listImagesUrl,this.ratings});
}