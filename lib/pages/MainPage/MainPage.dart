import 'package:AppTroNhaToi/pages/MainPage/KhacPage/khacPage.dart';
import 'package:AppTroNhaToi/pages/MainPage/PhongPage/phongPage.dart';
import 'package:flutter/material.dart';
import 'HomePage/HomePage.dart';
import 'NguoiThuePage/nguoithuePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const PhongPage(),
    const NguoiThuePage(),
    const KhacPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF2D7A3A),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Tổng quan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Phòng"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Người thuê",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Khác"),
        ],
      ),
    );
  }
}
