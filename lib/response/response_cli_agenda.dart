import 'package:app/response/response_pro.dart';

class ResponseCliAgenda{
  final int idAgenda;
  final String date;
  final String namePro;
  final ResponsePro responsePro;
  final String value;
  ResponseCliAgenda(this.idAgenda,this.date,this.namePro,this.responsePro,{this.value = 'R\$0,00'});

}