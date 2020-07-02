


import 'dart:convert';

import 'package:app/response/response_pro_area.dart';
import 'package:app/webservice/client_ws.dart';

void getAll() async{
   var response = await client().get('$ROOT_URL/area',headers: getHeaderWithAuthentication());
   final List<dynamic> decodedJson = jsonDecode(response.body);
   final List<ResponseProArea> areas = List();
   for(Map<String,dynamic> element in decodedJson){
     areas.add(ResponseProArea(element['description'],element['count']));
   }
}