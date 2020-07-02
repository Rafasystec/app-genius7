
import 'dart:convert';

import 'package:app/webservice/client_ws.dart';
import 'package:app/webservice/logging_interceptor.dart';
import 'package:http/http.dart';


void  findAll() async{

  final Response response = await client().get('https://viacep.com.br/ws/60822155/json');

}

Future<bool> signUpOnServerWithEmailAndPassword(String email,
    String password, String confpwd) async {
  try {
    final Response response = await client().post(
    'http://192.168.100.19:8080/user',
    headers: getHeader(),
    body: jsonEncode(<String, Object>{
      'id':0,
      'email': email,
      'pwd':password,
      'type':'CLI'
      }),
    );
    print('Signed up:');
    if(response.statusCode == 201 || response.statusCode == 200){
      return true;
    }else{
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load ResponseAuthentication');
    }
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
  }
}

