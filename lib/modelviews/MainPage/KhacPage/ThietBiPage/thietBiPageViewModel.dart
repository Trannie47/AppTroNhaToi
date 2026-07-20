import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPageModel.dart';
import 'package:flutter/material.dart';

class ThietBiPageViewModel extends ChangeNotifier {
  final ThietBiProvider _serviceTB;
  final txtSearch = TextEditingController();

  bool get isLoading => _serviceTB.isLoading;

  ThietBiPageViewModel(this._serviceTB) {
    _serviceTB.addListener(_onThietBiUpdate);

    Future.microtask(() => _serviceTB.fetchAll());
  }

  List<ThietBiPageModel> dsThietBi = [];

  void _onThietBiUpdate() {
    dsThietBi = List.from(_serviceTB.list);
    notifyListeners();
  }

  Future<void> refresh() => _serviceTB.fetchAll();

  void search() {
    notifyListeners();
  }

  @override
  void dispose() {
    txtSearch.dispose();
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

  List<ThietBiPageModel> get dsHienThi {
    final keyword = txtSearch.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      return dsThietBi;
    }

    return dsThietBi.where((e) {
      return (e.thietBi.tenThietBi ?? "").toLowerCase().contains(keyword);
    }).toList();
  }
}
