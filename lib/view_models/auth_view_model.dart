import 'package:AppTroNhaToi/models/user_login.dart';
import 'package:AppTroNhaToi/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';

class AuthViewModel extends ChangeNotifier{
  final AuthRepository _authRepository= AuthRepository();

  Future<UserData?> login(String input, String pass) async {
    notifyListeners();

    String? finalUsername;
    String? finalEmail;

    final emailRegex= RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(emailRegex.hasMatch(input)){
      finalEmail= input;
    }
    else{
      finalUsername= input;
    }
    try{
      final result= await _authRepository.Login(
        username: finalUsername,
        email: finalEmail,
        password: pass,
      );
      if(result!=null){
        notifyListeners();
        return result;
      }
      return null;
    }catch(e){
      notifyListeners();
      return null;
    }
  }

  Future<bool> checkAutoLoginStatus() async{
    final profile= await _authRepository.checkCurrentProfile();
    return profile != null;
  }
}