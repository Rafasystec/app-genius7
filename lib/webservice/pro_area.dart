


import 'dart:convert';

import 'package:app/response/response_pro_area.dart';
import 'package:app/util/preferences.dart';
import 'package:app/webservice/client_ws.dart';

Future<List<ResponseProArea>> getAllProAreas() async{
   var token = await getAppToken();
   var response = await client().get('$ROOT_URL/area',headers: getHeaderWithAuthentication(token)).timeout(Duration(seconds: 3));
   final List<dynamic> decodedJson = jsonDecode(response.body);
   final List<ResponseProArea> areas = List();
   for(Map<String,dynamic> area in decodedJson){
     areas.add(ResponseProArea.fromJson(area));
   }
   return areas;
}