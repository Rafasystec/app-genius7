


import 'dart:convert';

import 'package:app/response/response_address.dart';
import 'package:app/response/response_cli_agenda.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/response/response_pro_area.dart';
import 'package:app/response/response_rating.dart';
import 'package:app/util/preferences.dart';
import 'package:app/webservice/client_ws.dart';

Future<List<ResponseCliAgenda>> getAllCliAgenda(int idCli) async{
//   var token = await getAppToken();
//   var response = await client().get('$ROOT_URL/area',headers: getHeaderWithAuthentication(token)).timeout(Duration(seconds: 3));
//   final List<dynamic> decodedJson = jsonDecode(response.body);
//   final List<ResponseProArea> areas = List();
//   for(Map<String,dynamic> area in decodedJson){
//     areas.add(ResponseProArea.fromJson(area));
//   }
   List<ResponseCliAgenda> list = List();
//   List<ResponseRating> ratings = List();
//   ratings.add(ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'));
//   ratings.add(ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'));
//   ratings.add(ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal'));
   list.add(ResponseCliAgenda(1,'18/07/2018 as 11:00','Sebastian'));
   list.add(ResponseCliAgenda(2,'15/06/2018 as 13:00','Lucas de Oliveira'));
   list.add(ResponseCliAgenda(3,'05/06/2018 as 10:00','Jonh '));
   return list;
}