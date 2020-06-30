class RequestCredential{
  final int userId;
  final String email;
  final String pwd;

  RequestCredential(this.email,this.pwd,{this.userId});
//  factory RequestCredential.fromJson(Map<String, dynamic> json) {
//    return RequestCredential(
////      id: json['id'],
////      title: json['title'],
//    );
//  }
}