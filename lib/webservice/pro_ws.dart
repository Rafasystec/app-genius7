



import 'package:app/response/response_address.dart';
import 'package:app/response/response_pro.dart';
import 'package:app/response/response_rating.dart';

Future<List<ResponsePro>> getAllProfessionalByArea(int areaId) async{

   List<ResponsePro> list = List();
   List<ResponseRating> ratings = List();
   list.add(new ResponsePro(0, 'João da Silva', 3, 'https://www.ansocial.com.br/wp-content/uploads/2018/07/eletricista-1.jpg',
       'The hit region of an icon button will, if possible, be at least kMinInteractiveDimension pixels in size, regardless of the actual iconSize, to satisfy the '
           'touch target size requirements in the Material Design specification. The alignment controls how the icon itself is positioned within the hit region.',28,16,ratings
       ,'UGctTBpSQvRmeFVRnFSg', address: ResponseAddress('Messejana','Rua 8')));
   return list;
}