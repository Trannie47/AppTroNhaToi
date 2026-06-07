import 'package:AppTroNhaToi/core/network/AuthApiClient.dart';
import 'package:AppTroNhaToi/models/user_login.dart';

class AuthRepository{
  final AuthApiClient _authApiClient= AuthApiClient();

  Future<UserLogin?> Login({
    String? username,
    String? email,
    required String password,
  }) async{
    return await _authApiClient.loginWithApi(
        username: username,
        email: email,
        password: password
    );
  }
}