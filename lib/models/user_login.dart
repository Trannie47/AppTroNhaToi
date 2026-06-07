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
