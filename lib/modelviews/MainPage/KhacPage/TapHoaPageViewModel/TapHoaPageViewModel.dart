import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:flutter/material.dart';

class TapHoaPageViewModel extends ChangeNotifier {
  int currentTab = 0;
  int sttHoaDon = 1;

  List<HangHoa> dsHangHoa = [];
  List<HoaDonTapHoa> dsHoaDon = [];

  TapHoaPageViewModel() {
    loadData();
  }

  void loadData() {
    dsHangHoa = [
      HangHoa(
        maHangHoa: 1,
        tenHangHoa: "Mì Hảo Hảo",
        giaNhap: 3000,
        giaBan: 5000,
        donViTinh: "gói",
      ),
      HangHoa(
        maHangHoa: 2,
        tenHangHoa: "Coca Cola",
        giaNhap: 8000,
        giaBan: 12000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 3,
        tenHangHoa: "Nước suối",
        giaNhap: 4000,
        giaBan: 7000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 4,
        tenHangHoa: "Sữa Vinamilk",
        giaNhap: 28000,
        giaBan: 35000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 5,
        tenHangHoa: "Bánh Oreo",
        giaNhap: 12000,
        giaBan: 18000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 6,
        tenHangHoa: "Trứng gà",
        giaNhap: 25000,
        giaBan: 30000,
        donViTinh: "vỉ",
      ),
    ];

    dsHoaDon = [
      HoaDonTapHoa(
        maHoaDon: taoMaHoaDon(),
        tongTien: 50000,
      ),

      HoaDonTapHoa(
        maHoaDon: taoMaHoaDon(),
        tongTien: 120000,
      ),

      HoaDonTapHoa(
        maHoaDon: taoMaHoaDon(),
        tongTien: 80000,
      ),
    ];

    notifyListeners();
  }

  /// mặc định mã tự động
  int taoMaHoaDon() {

    DateTime now = DateTime.now();

    String nam = now.year.toString();

    String thang =
    now.month.toString().padLeft(2, '0');

    String ngay =
    now.day.toString().padLeft(2, '0');

    String stt =
    sttHoaDon.toString().padLeft(3, '0');

    sttHoaDon++;

    return int.parse(
      "$nam$thang$ngay$stt",
    );
  }

  /// tab
  void changeTab(int index) {
    currentTab = index;

    print("currentTab = $currentTab");

    notifyListeners();
  }

  /// thêm hàng hóa
  void themHoaDon(
      double tongTien,
      ) {

    dsHoaDon.insert(
      0,
      HoaDonTapHoa(
        maHoaDon: taoMaHoaDon(),
        ngayBan: DateTime.now(),
        tongTien: tongTien,
      ),
    );

    notifyListeners();
  }

  /// sửa hàng hóa
  void suaHangHoa(HangHoa hangHoa) {
    int index = dsHangHoa.indexWhere(
          (e) => e.maHangHoa == hangHoa.maHangHoa,
    );

    if (index != -1) {
      dsHangHoa[index] = hangHoa;
      notifyListeners();
    }
  }

  /// xóa hàng hóa
  void xoaHangHoa(int maHangHoa) {
    dsHangHoa.removeWhere(
          (e) => e.maHangHoa == maHangHoa,
    );

    notifyListeners();
  }

  /// tổng mặt hàng
  int get tongMatHang {
    return dsHangHoa.length;
  }

  /// tổng công nợ (demo)
  double get tongCongNo {
    return 470000;
  }

  /// số công nợ (demo)
  int get soCongNo {
    return 2;
  }

  int get tongHoaDon {
    return dsHoaDon.length;
  }


  /// tồn kho demo
  String getTonKho(HangHoa hangHoa) {
    switch (hangHoa.maHangHoa) {
      case 1:
        return "48 gói";

      case 2:
        return "24 chai";

      case 3:
        return "30 quả";

      default:
        return "0";
    }
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
}