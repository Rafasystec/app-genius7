import 'package:app/response/response_rating.dart';

class ResponseLocalRestaurant {
  final int id;
  final String name;
  final String address;
  final String urlLogo;
  final int rate;
  final String distance;
  final List<ResponseRating> ratings;
  ResponseLocalRestaurant(this.id,this.name,this.address,this.urlLogo,this.rate,this.distance,{this.ratings});
}