import 'package:AppTroNhaToi/core/network/AuthApiClient.dart';
import 'package:AppTroNhaToi/models/user_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository{
  final AuthApiClient _authApiClient= AuthApiClient();
  final _storage= const FlutterSecureStorage(); // Nơi bảo mật lưu Token

  Future<UserData?> Login({
    String? username,
    String? email,
    required String password,
  }) async{
    final result= await _authApiClient.loginWithApi(
                    username: username,
                    email: email,
                    password: password
                  );
    if(result !=null && result.accessToken !=null){
      //ghi token vào bộ nhớ an toàn
      await _storage.write(key: "KEY_ACCESS_TOKEN", value: result.accessToken);
      print ("Đac ghi token vào ${result.accessToken}");
    }
    return result;
  }
}