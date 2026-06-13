import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

class DanhSachNguoiThuePageViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  final List<NguoiThuePhong> danhSachNguoiThue = [
    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 1,
        hoTen: "Nguyễn Văn An",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),
      phong: [
        Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 2,
        hoTen: "Trần Văn Bảo",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),
      phong: [
        Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 3,
        hoTen: "Nguyễn Văn B",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),
      phong: [
        Phong(phongID: 2, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 4,
        hoTen: "Trần Văn C",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),
      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 2, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 5,
        hoTen: "Nguyễn Văn D",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),
      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 2),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 6,
        hoTen: "Trần Văn E",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),
      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 1),
      ],
    ),
  ];

  int get tong => danhSachNguoiThue.length;

  int get thueChinh => danhSachNguoiThue
      .where(
        (e) => e.nguoiThue.ghiChu == null || e.nguoiThue.ghiChu!.trim().isEmpty,
      )
      .length;

  int get oGhep => tong - thueChinh;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
