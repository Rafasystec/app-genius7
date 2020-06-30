import 'dart:collection';

class HttpHeader{


  Map<String, String> getHeader(){
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Map<String, String> getHeaderWithAuthentication(){
   return HashMap.from(<String, String>{
     'Content-Type': 'application/json; charset=UTF-8',
   });

  }

}