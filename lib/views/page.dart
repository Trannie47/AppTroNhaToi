import 'package:AppTroNhaToi/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'MainPage/MainPage.dart';
import 'TrangDangNhap/TrangDangNhap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = AuthViewModel();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: authViewModel.checkAutoLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const MainPage(); // Token ccòn -> Vào trang chủ
          }
          return const TrangDangNhap(); // Token chết hoặc chưa đăng nhập -> Vào Login
        },
      ),
    );
  }
}
