import 'package:retrofit/call_adapter.dart';

class UserLogin {
  final int id;
  final String username;
  final String email;

  UserLogin({
    required this.id,
    required this.username,
    required this.email
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email};
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class UserData{
  final String? accessToken;
  final UserLogin? user;

  UserData({this.accessToken,this.user});

  factory UserData.fromJson(Map<String,dynamic> json){
    return UserData(
      accessToken: json['access_token'] as String? ,
      user: json['user'] !=null
            ? UserLogin.fromJson(json['user'] as Map<String,dynamic>)
            : null
    );
  }
}
