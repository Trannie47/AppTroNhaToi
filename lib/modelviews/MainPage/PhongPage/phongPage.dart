import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

class PhongPageModelView extends ChangeNotifier {
  bool isLoading = true;

  List<LoaiPhong> dsLoaiPhong = [];
  List<Phong> dsPhong = [];
  List<Phong> dsPhongFilter = [];

  PhongPageModelView() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    dsLoaiPhong = [
      LoaiPhong(
        maLoaiPhong: 1,
        tenLoaiPhong: "Tiêu chuẩn",
        dienTich: 18,
        giaTien: 3200000,
        soNguoiToiDa: 2,
        isMayLanh: true,
      ),
      LoaiPhong(
        maLoaiPhong: 2,
        tenLoaiPhong: "VIP",
        dienTich: 25,
        giaTien: 4500000,
        soNguoiToiDa: 2,
        isMayLanh: true,
      ),
    ];

    dsPhong = [
      Phong(phongID: 1, tenPhong: "P101", trangThai: "1", maLoaiPhong: 1),
      Phong(phongID: 2, tenPhong: "P102", trangThai: "2", maLoaiPhong: 2),
      Phong(phongID: 3, tenPhong: "P301", maLoaiPhong: 1, trangThai: "0"),
      Phong(phongID: 4, tenPhong: "P401", maLoaiPhong: 1, trangThai: "2"),
    ];

    dsPhongFilter = dsPhong;
    isLoading = false;
    notifyListeners();
  }

  LoaiPhong getLoaiPhong(num idLoaiPhong) {
    return dsLoaiPhong.firstWhere((e) => e.maLoaiPhong == idLoaiPhong);
  }

  void applyFilter(int filter) {
    if (filter == -1) {
      dsPhongFilter = dsPhong;
    } else {
      dsPhongFilter = dsPhong.where((e) => e.trangThai == filter).toList();
    }
    notifyListeners();
  }

  int countByStatus(int status) => dsPhong.where((e) => e.trangThai == status).length;
}