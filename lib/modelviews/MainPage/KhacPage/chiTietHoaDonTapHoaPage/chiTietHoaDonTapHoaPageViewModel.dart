import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';

import 'package:flutter/material.dart';

class ChiTietHoaDonTapHoaPageViewModel extends ChangeNotifier {
  final HoaDonTapHoa hoaDon;
  final PhieuThuHdTh? phieuThu;
  final String? tenNguoiMua;

  List<chiTietHoaDonTapHoaPageModel> dsChiTietHoaDonTapHoa = [];

  ChiTietHoaDonTapHoaPageViewModel({
    required this.hoaDon,
    this.phieuThu,
    this.tenNguoiMua = 'Khách vãng lai',
  }) {
    init();
  }

  void init() {
    _loadData();

    notifyListeners();
  }

  void _loadData() {
    // thêm dữ liệu giả ở đây
    dsChiTietHoaDonTapHoa = [
      chiTietHoaDonTapHoaPageModel(
        chiTietTapHoa: ChiTietTapHoa(
          maHoaDon: hoaDon.maHoaDon,
          maHangHoa: 1,
          soLuong: 2,
        ),
        hangHoa: HangHoa(
          maHangHoa: 1,
          tenHangHoa: 'Mì Hảo Hảo',
          giaNhap: 3000,
          giaBan: 5000,
          donViTinh: 'gói',
        ),
      ),
      chiTietHoaDonTapHoaPageModel(
        chiTietTapHoa: ChiTietTapHoa(
          maHoaDon: hoaDon.maHoaDon,
          maHangHoa: 2,
          soLuong: 3,
        ),
        hangHoa: HangHoa(
          maHangHoa: 2,
          tenHangHoa: 'Coca Cola',
          giaNhap: 8000,
          giaBan: 12000,
          donViTinh: 'chai',
        ),
      ),
      chiTietHoaDonTapHoaPageModel(
        chiTietTapHoa: ChiTietTapHoa(
          maHoaDon: hoaDon.maHoaDon,
          maHangHoa: 3,
          soLuong: 1,
        ),
        hangHoa: HangHoa(
          maHangHoa: 3,
          tenHangHoa: 'Nước suối',
          giaNhap: 4000,
          giaBan: 7000,
          donViTinh: 'chai',
        ),
      ),
    ];
  }
}
