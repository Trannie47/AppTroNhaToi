import 'dart:convert';

import 'package:AppTroNhaToi/models/view_model/user_login.dart';
import 'package:AppTroNhaToi/values/shareKey.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainPage/MainPage.dart';

class TrangDangNhap extends StatefulWidget {
  const TrangDangNhap({Key? key}) : super(key: key);

  @override
  State<TrangDangNhap> createState() => _TrangDangNhapState();
}

class _TrangDangNhapState extends State<TrangDangNhap> {
  bool isHidden = true;
  bool remember = false;

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  String? errorUser;
  String? errorPass;
  String? errorServer;

  void showError(String message) {
    setState(() {
      errorServer = message;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        errorServer = null;
      });
    });
  }

  Future<void> handleLogin() async {
    setState(() {
      errorUser = null;
      errorPass = null;
      errorServer = null;

      if (userController.text.trim().isEmpty) {
        errorUser = "Vui lòng nhập tài khoản";
      }

      if (passController.text.trim().isEmpty) {
        errorPass = "Vui lòng nhập mật khẩu";
      }
    });

    if (errorUser != null || errorPass != null) return;

    if (userController.text != "admin" || passController.text != "123") {
      showError("Tài khoản/Mật khẩu chưa đúng yêu cầu nhập lại");
    } else {
      if (remember) {
        UserLogin userLogin = UserLogin(
          email: userController.text,
          password: passController.text,
          remember: remember,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(ShareKeys.user, jsonEncode(userLogin.toJson()));
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  InputDecoration inputStyle(String hint, String? error) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  void initState() {
    super.initState();
    checkRememberedLogin();
  }

  Future<void> checkRememberedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userLoginString = prefs.getString(ShareKeys.user);
    if (userLoginString != null) {
      final userLoginJson = jsonDecode(userLoginString);
      UserLogin userLogin = UserLogin.fromJson(userLoginJson);

      if (userLogin.remember) {
        userController.text = userLogin.email;
        passController.text = userLogin.password;
        handleLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // BACKGROUND
          Positioned.fill(
            child: Image.asset('assets/images/bg_tro.png', fit: BoxFit.cover),
          ),

          // OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),

          // BANNER LỖI TRÊN CÙNG
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: errorServer != null ? 0 : -100,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorServer ?? "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ✅ LOGO - cố định, luôn hiển thị
                Image.asset(
                  'assets/images/Logo_NoBG.png',
                  width: 140,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.home, size: 100, color: Colors.white),
                ),

                const SizedBox(height: 20),

                // ✅ Form nằm trong Expanded + SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom -
                            220, // trừ logo + padding
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// USER
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Tài khoản"),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: userController,
                                decoration: inputStyle(
                                  "Nhập tài khoản",
                                  errorUser,
                                ),
                              ),
                              const SizedBox(height: 16),

                              /// PASS
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Mật khẩu"),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: passController,
                                obscureText: isHidden,
                                decoration: inputStyle("Mật khẩu", errorPass)
                                    .copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          isHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isHidden = !isHidden;
                                          });
                                        },
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 12),

                              /// REMEMBER
                              Row(
                                children: [
                                  Checkbox(
                                    value: remember,
                                    onChanged: (value) {
                                      setState(() {
                                        remember = value!;
                                      });
                                    },
                                  ),
                                  const Text("Ghi nhớ mật khẩu"),
                                ],
                              ),
                              const SizedBox(height: 10),

                              /// BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D7A3A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: handleLogin,
                                  child: const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
