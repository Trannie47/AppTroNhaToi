import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

class HoaDonGuiXePageViewModel extends ChangeNotifier {
  final List<PhuongTien> dsPhuongTien;

  HoaDonGuiXePageViewModel({
    required this.dsPhuongTien,
  });

  String namDangChon = "2025";

  final List<String> dsNam = [
    "2026",
    "2025",
    "2024",
  ];

  final List<HoaDonGuiXe> dsHoaDon = [
    HoaDonGuiXe(
      maHoaDon: 1,
      thangNam: "T5/2025",
      trangThai: 0,
      idPhuongTien: 1,
    ),
    HoaDonGuiXe(
      maHoaDon: 2,
      thangNam: "T4/2025",
      trangThai: 1,
      idPhuongTien: 2,
    ),
    HoaDonGuiXe(
      maHoaDon: 3,
      thangNam: "T3/2025",
      trangThai: 1,
      idPhuongTien: 3,
    ),
    HoaDonGuiXe(
      maHoaDon: 4,
      thangNam: "T2/2025",
      trangThai: 1,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 5,
      thangNam: "T1/2025",
      trangThai: 1,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 6,
      thangNam: "T2/2026",
      trangThai: 0,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 7,
      thangNam: "T1/2026",
      trangThai: 1,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 8,
      thangNam: "T2/2024",
      trangThai: 0,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 9,
      thangNam: "T1/2024",
      trangThai: 1,
      idPhuongTien: 4,
    ),
  ];

  void changeYear(String value) {
    namDangChon = value;
    notifyListeners();
  }

  List<HoaDonGuiXe> get dsHoaDonTheoNam {
    return dsHoaDon.where((e) {
      if (e.thangNam == null) return false;

      return e.thangNam!.contains(namDangChon);
    }).toList();
  }

  int get tongSoXe => dsPhuongTien.length;

  double get tongTienThang {
    double tong = 0;

    for (final xe in dsPhuongTien) {
      tong += xe.giaGui ?? 0;
    }

    return tong;
  }

  List<HoaDonGuiXe> get dsHoaDonNo {
    return dsHoaDon.where((e) => e.trangThai == 0).toList();
  }

  PhuongTien? getXeTheoHoaDon(HoaDonGuiXe hoaDon) {
    final dsXeTimDuoc = dsPhuongTien.where(
      (e) => e.ID == hoaDon.idPhuongTien,
    ).toList();

    if (dsXeTimDuoc.isEmpty) {
      return null;
    }

    return dsXeTimDuoc.first;
  }

  double get tongTienNo {
    double tong = 0;

    for (final hoaDon in dsHoaDonNo) {
      final xe = getXeTheoHoaDon(hoaDon);

      if (xe != null) {
        tong += xe.giaGui ?? 0;
      }
    }

    return tong;
  }

  String get textNo {
    if (dsHoaDonNo.isEmpty) {
      return "Không có";
    }

    final hoaDonMoiNhat = dsHoaDonNo.first;

    return "${tongTienNo.toStringAsFixed(0)}đ • ${hoaDonMoiNhat.thangNam}";
  }
}