class UserLogin {
  String email;
  String password;
  bool remember;

  UserLogin({
    required this.email,
    required this.password,
    this.remember = false,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'remember': remember};
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      email: json['email'] as String,
      password: json['password'] as String,
      remember: json['remember'] as bool? ?? false,
    );
  }
}
