


import 'dart:convert';

import 'package:app/response/response_address.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/response/response_pro_area.dart';
import 'package:app/response/response_rating.dart';
import 'package:app/util/preferences.dart';
import 'package:app/webservice/client_ws.dart';

Future<List<ResponsePro>> getAllProfessionalByArea(int areaId) async{
//   var token = await getAppToken();
//   var response = await client().get('$ROOT_URL/area',headers: getHeaderWithAuthentication(token)).timeout(Duration(seconds: 3));
//   final List<dynamic> decodedJson = jsonDecode(response.body);
//   final List<ResponseProArea> areas = List();
//   for(Map<String,dynamic> area in decodedJson){
//     areas.add(ResponseProArea.fromJson(area));
//   }
   List<ResponsePro> list = List();
   List<ResponseRating> ratings = List();
//   ratings.add(ResponseRating('https://image.freepik.com/vetores-gratis/empresaria-elegante-avatar-feminino_24877-18073.jpg','Flávia Lima Audenite','Gostei mais ou menos do serviço. Deixou muito a desejar mas tudo bem né.'));
//   ratings.add(ResponseRating('https://publicdomainvectors.org/photos/Female-cartoon-avatar.png','Lívia Andrade','Gostei muito do serviço. Muito bem feito, foi indicação de uma amiga muito próxima. Já o coloquei nos meus favotitos. Indico muito mesmo. App tambme é muito bom'));
//   ratings.add(ResponseRating('https://images.vexels.com/media/users/3/145908/preview2/52eabf633ca6414e60a7677b0b917d92-criador-de-avatar-masculino.jpg','Raul Paz de Andrade','Gostei do serviço mas ele não é pontual, além disso tratou minha vó muito mal'));
   list.add(new ResponsePro(0, 'João da Silva', 3, 'https://www.ansocial.com.br/wp-content/uploads/2018/07/eletricista-1.jpg',
       'The hit region of an icon button will, if possible, be at least kMinInteractiveDimension pixels in size, regardless of the actual iconSize, to satisfy the '
           'touch target size requirements in the Material Design specification. The alignment controls how the icon itself is positioned within the hit region.',28,16,ratings
       ,'UGctTBpSQvRmeFVRnFSg', address: ResponseAddress('Messejana','Rua 8')));
   return list;
}