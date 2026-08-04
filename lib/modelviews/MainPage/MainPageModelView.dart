import 'package:AppTroNhaToi/views/MainPage/HomePage/HomePage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/KhacPage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/nguoithuePage.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/phongPage.dart';

import 'package:flutter/material.dart';

class MainPageModelView extends ChangeNotifier {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const PhongPage(),
    const NguoiThuePage(),
    const KhacPage(),
  ];
}
