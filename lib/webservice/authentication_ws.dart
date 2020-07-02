

import 'dart:convert';

import 'package:app/Objects/ResponseAuthentication.dart';
import 'package:app/webservice/client_ws.dart';
import 'package:http/http.dart';



  Future<ResponseAuthentication> doLogin(String email, String pwd) async {
    final Response response = await client().post(
      '$ROOT_URL/auth',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'pwd':pwd
      }),
    );
    if(response.statusCode == 201 || response.statusCode == 200){
      return ResponseAuthentication.fromJson(json.decode(response.body));
    }else{
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load ResponseAuthentication');
    }
  }
