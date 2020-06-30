class ResponseAuthentication{

  final int userId;
  final String userName;
  final String token;
  final String type;

  ResponseAuthentication({this.userId,this.token,this.type,this.userName});

  factory ResponseAuthentication.fromJson(Map<String, dynamic> json) {
    return ResponseAuthentication(
      userId: json['userId'],
      userName: json['userName'],
      token: json['token'],
      type: json['type'],
    );
  }

}