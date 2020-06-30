
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;

//import 'main.reflectable.dart' show initializeReflectable;
@jsonSerializable
class RequestCredential{
  @JsonProperty(name: 'userId')
  final int userId;
  @JsonProperty(name: 'email')
  final String email;
  @JsonProperty(name: 'pwd')
  final String pwd;

  RequestCredential(this.email,this.pwd,{this.userId});
//  factory RequestCredential.fromJson(Map<String, dynamic> json) {
//    return RequestCredential(
////      id: json['id'],
////      title: json['title'],
//    );
//  }

//  void main(){
////    print(JsonMapper.serialize(RequestCredential('email', 'yes',userId: 0)));
//  print('Hello Word');
//  }
}