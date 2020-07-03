

import 'dart:collection';

import 'package:app/util/preferences.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'logging_interceptor.dart';

const String ROOT_URL = 'http://192.168.100.8:8080';
HttpClientWithInterceptor client (){
  return HttpClientWithInterceptor.build(interceptors:[LoggingInterceptor()]);
}

Map<String, String> getHeader(){
  return <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
}

Map<String, String> getHeaderWithAuthentication(String token){
  return HashMap.from(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token'
  });

}