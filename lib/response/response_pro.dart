import 'package:app/response/response_address.dart';
import 'package:app/response/response_rating.dart';

class ResponsePro {
  final int idPro;
  final String name;
  final int rant;
  final String url;
  final String about;
  final int attendances;
  final int amountRate;
  final List<ResponseRating> ratings;
  final ResponseAddress address;
  final String idUserFirebase;

  ResponsePro(this.idPro,this.name,this.rant,this.url,this.about,this.attendances,this.amountRate,this.ratings,this.idUserFirebase,{this.address});
}