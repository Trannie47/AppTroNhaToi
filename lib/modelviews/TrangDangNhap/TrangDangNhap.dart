import 'dart:convert';
import 'package:AppTroNhaToi/models/user_login.dart';
import 'package:AppTroNhaToi/core/values/shareKey.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrangDangNhapModelView extends ChangeNotifier {
  bool isHidden = true;
  bool remember = false;

  final TextEditingController userController =
      TextEditingController();

  final TextEditingController passController =
      TextEditingController();

  String? errorUser;
  String? errorPass;
  String? errorServer;

  Future<bool> dangNhap() async {
  errorUser = null;
  errorPass = null;
  errorServer = null;

  if (userController.text.trim().isEmpty) {
    errorUser = "Vui lòng nhập tài khoản";
  }

  if (passController.text.trim().isEmpty) {
    errorPass = "Vui lòng nhập mật khẩu";
  }

  notifyListeners();

  if (errorUser != null || errorPass != null) {
    return false;
  }

  if (userController.text != "admin" ||
      passController.text != "123") {
    errorServer =
        "Tài khoản/Mật khẩu chưa đúng yêu cầu nhập lại";

    notifyListeners();
    return false;
  }

  // if (remember) {
  //   UserLogin userLogin = UserLogin(
  //     email: userController.text,
  //     password: passController.text,
  //     remember: remember,
  //   );
  //
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   await prefs.setString(
  //     ShareKeys.user,
  //     jsonEncode(userLogin.toJson()),
  //   );
  // }

  return true;
}

  // Future<bool> checkRememberedLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userLoginString = prefs.getString(ShareKeys.user);
  //   if (userLoginString != null) {
  //     final userLoginJson = jsonDecode(userLoginString);
  //     UserLogin userLogin = UserLogin.fromJson(userLoginJson);
  //
  //     if (userLogin.remember) {
  //       userController.text = userLogin.email;
  //       passController.text = userLogin.password;
  //       dangNhap();
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  void togglePassword() {
    isHidden = !isHidden;
    notifyListeners();
  }

  void setRemember(bool value) {
    remember = value;
    notifyListeners();
  }
}
