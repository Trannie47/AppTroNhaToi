import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

class PhuongTienNguoiThuePageViewModel extends ChangeNotifier {
  final NguoiThue nguoiThue;

  List<PhuongTien> dsPhuongTien;

  PhuongTienNguoiThuePageViewModel({
    required this.nguoiThue,
    required this.dsPhuongTien,
  });

  void themPhuongTien(PhuongTien xe) {
    dsPhuongTien.add(xe);
    notifyListeners();
  }

  void xoaPhuongTien(PhuongTien xe) {
    dsPhuongTien.remove(xe);
    notifyListeners();
  }

  List<PhuongTien> get xeMay {
    return dsPhuongTien
        .where((e) => e.loaiXe == 0)
        .toList();
  }

  List<PhuongTien> get oTo {
    return dsPhuongTien
        .where((e) => e.loaiXe == 1)
        .toList();
  }

  List<PhuongTien> get xeDap {
    return dsPhuongTien
        .where((e) => e.loaiXe == 2)
        .toList();
  }
}