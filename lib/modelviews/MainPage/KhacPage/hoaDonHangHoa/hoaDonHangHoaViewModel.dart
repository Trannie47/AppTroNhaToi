import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:flutter/material.dart';

class HoaDonHangHoaViewModel extends ChangeNotifier {

  bool nguoiThueTro = true;

  bool coPhieuThu = true;

  final txtNgayMua = TextEditingController();

  final txtNguoiDongTien = TextEditingController();

  final txtNguoiMua = TextEditingController();

  List<HangHoa> dsHangHoaChon = [];

  Map<int, int> soLuong = {};

  int sttHoaDon = 1;

  String maHoaDon = "";

  HoaDonHangHoaViewModel() {

    DateTime now = DateTime.now();

    txtNgayMua.text =
    "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
  }

  /// thêm hàng hóa
  void themHangHoa(HangHoa hangHoa) {

    int index = dsHangHoaChon.indexWhere(
          (e) => e.maHangHoa == hangHoa.maHangHoa,
    );

    if (index == -1) {

      dsHangHoaChon.add(hangHoa);

      soLuong[hangHoa.maHangHoa!] = 1;
    }
    else {

      tangSoLuong(hangHoa);

      return;
    }

    notifyListeners();
  }

  /// tăng số lượng
  void tangSoLuong(HangHoa hangHoa) {

    soLuong[hangHoa.maHangHoa!] =
        (soLuong[hangHoa.maHangHoa] ?? 0) + 1;

    notifyListeners();
  }

  /// giảm số lượng
  void giamSoLuong(HangHoa hangHoa) {

    int sl = soLuong[hangHoa.maHangHoa] ?? 1;

    if (sl > 1) {

      soLuong[hangHoa.maHangHoa!] = sl - 1;
    }
    else {

      dsHangHoaChon.removeWhere(
              (e) => e.maHangHoa == hangHoa.maHangHoa);

      soLuong.remove(hangHoa.maHangHoa);
    }

    notifyListeners();
  }

  /// lấy số lượng
  int laySoLuong(HangHoa hangHoa) {

    return soLuong[hangHoa.maHangHoa] ?? 1;
  }

  /// tổng tiền
  double get tongTien {

    double tong = 0;

    for (var hh in dsHangHoaChon) {

      tong +=
          (hh.giaBan ?? 0) *
              laySoLuong(hh);
    }

    return tong;
  }

  /// format tiền
  String formatTien(double tien) {

    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }

  /// sinh mã hóa đơn
  void taoMaHoaDon() {

    DateTime now = DateTime.now();

    String nam =
    now.year.toString();

    String thang =
    now.month.toString().padLeft(2, '0');

    String ngay =
    now.day.toString().padLeft(2, '0');

    String stt =
    sttHoaDon.toString().padLeft(3, '0');

    maHoaDon =
    "TH$nam$thang$ngay$stt";

    sttHoaDon++;

    notifyListeners();
  }

  @override
  void dispose() {

    txtNgayMua.dispose();

    txtNguoiDongTien.dispose();

    txtNguoiMua.dispose();

    super.dispose();
  }
}