import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:flutter/material.dart';

class DanhSachPhongThuePageViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final List<LoaiPhong> dsLoaiPhong = [
    LoaiPhong(
      maLoaiPhong: 1,
      tenLoaiPhong: "Tiêu chuẩn",
      dienTich: 18,
      soNguoiToiDa: 2,
      giaTien: 3200000,
      isMayLanh: true,
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
