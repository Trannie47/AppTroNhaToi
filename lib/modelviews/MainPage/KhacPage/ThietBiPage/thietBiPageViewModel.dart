import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ThietBiPageViewModel extends ChangeNotifier {
  int currentIndex = 0;

  final ThietBiProvider _serviceTB;

  bool get isLoading => _serviceTB.isLoading;

  ThietBiPageViewModel(this._serviceTB) {
    _serviceTB.addListener(_onThietBiUpdate);

    Future.microtask(() => _serviceTB.fetchAll());
  }

  List<ThietBi> dsThietBi = [];

  void _onThietBiUpdate() {
    dsThietBi = List.from(_serviceTB.list);
    notifyListeners();
  }

  Future<void> refresh() => _serviceTB.fetchAll();

  @override
  void dispose() {
    _serviceTB.removeListener(_onThietBiUpdate);
    super.dispose();
  }
  List<Phong> dsPhong = [
    Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),

    Phong(phongID: 2, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
  ];

  List<LapRap> dsLapRap = [
    LapRap(id: 1, phongID: 1, thietBiID: 1),

    LapRap(id: 2, phongID: 1, thietBiID: 2),

    LapRap(id: 3, phongID: 2, thietBiID: 3),
  ];



  List<ThietBi> get dsHienThi {
    switch (currentIndex) {
      case 1:
        return dsThietBi.where((e) => e.trangThai == "Tốt").toList();

      case 2:
        return dsThietBi.where((e) => e.trangThai == "Đang sửa").toList();

      default:
        return dsThietBi;
    }
  }

  void changeTab(int index) {
    currentIndex = index;

    notifyListeners();
  }

  int get tongSoThietBi => dsThietBi.length;

  int get tongDangDung => dsThietBi.where((e) => e.trangThai == "Tốt").length;

  int get tongHongSua =>
      dsThietBi.where((e) => e.trangThai == "Đang sửa").length;
}
