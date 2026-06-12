import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ThietBiPageViewModel extends ChangeNotifier {

  int currentIndex = 0;

  List<ThietBi> dsThietBi = [

    ThietBi(
      thietBiID: 1,
      tenThietBi: "Máy lạnh Daikin 1HP",
      loai: "Điều hòa",
      giaTri: 8500000,
      ngayMua: DateTime(2023,1),
      trangThai: "Tốt",
    ),

    ThietBi(
      thietBiID: 2,
      tenThietBi: "Tủ lạnh mini 90L",
      loai: "Tủ lạnh",
      giaTri: 3500000,
      ngayMua: DateTime(2022,3),
      trangThai: "Đang sửa",
    ),

    ThietBi(
      thietBiID: 3,
      tenThietBi: "Máy lạnh Panasonic 1.5HP",
      loai: "Điều hòa",
      giaTri: 12000000,
      ngayMua: DateTime(2022,6),
      trangThai: "Tốt",
    ),
  ];

  List<ThietBi> get dsHienThi {

    switch (currentIndex) {

      case 1:
        return dsThietBi
            .where((e) => e.trangThai == "Tốt")
            .toList();

      case 2:
        return dsThietBi
            .where((e) => e.trangThai == "Đang sửa")
            .toList();

      default:
        return dsThietBi;
    }
  }

  void changeTab(int index) {

    currentIndex = index;

    notifyListeners();
  }

  int get tongSoThietBi => dsThietBi.length;

  int get tongDangDung =>
      dsThietBi.where((e) => e.trangThai == "Tốt").length;

  int get tongHongSua =>
      dsThietBi.where((e) => e.trangThai == "Đang sửa").length;
}