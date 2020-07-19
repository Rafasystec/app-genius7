


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
   var response = ResponsePro(0, 'João da Silva', 3, 'https://www.ansocial.com.br/wp-content/uploads/2018/07/eletricista-1.jpg',
       'The hit region of an icon button will, if possible, be at least kMinInteractiveDimension pixels in size, regardless of the actual iconSize, to satisfy the '
           'touch target size requirements in the Material Design specification. The alignment controls how the icon itself is positioned within the hit region.',28,16,null
       ,'id-user-firebase', address: ResponseAddress('Messejana','Rua 8'));
   list.add(ResponseCliAgenda(1,'18/07/2018 as 11:00','Sebastian', response,value: 'R\$ 100,00'));
   list.add(ResponseCliAgenda(2,'15/06/2018 as 13:00','Lucas de Oliveira',response,value: 'R\$ 150,00'));
   list.add(ResponseCliAgenda(3,'05/06/2018 as 10:00','Jonh ',response,value: 'R\$ 120,00'));
   return list;
}