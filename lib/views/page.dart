import 'package:flutter/material.dart';
import 'TrangDangNhap/TrangDangNhap.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrangDangNhap(),
    );
  }
}
