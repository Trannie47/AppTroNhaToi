import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

class NguoiThuePageViewModel extends ChangeNotifier {
  final TextEditingController searchController =
      TextEditingController();

  final List<NguoiThuePhong> danhSachNguoiThue = [
    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 1,
        hoTen: "Nguyễn Văn An",
        cccd: "079203001234",
        sdt: "0909123456",
        queQuan: "TP.HCM",
        ghiChu: "",
        ngaySinh: DateTime(2003, 5, 12),
      ),
      phong: [
        Phong(
          phongID: 1,
          tenPhong: "P101",
          trangThai: 1,
          maLoaiPhong: 1,
        ),
        Phong(
          phongID: 2,
          tenPhong: "P102",
          trangThai: 2,
          maLoaiPhong: 2,
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}