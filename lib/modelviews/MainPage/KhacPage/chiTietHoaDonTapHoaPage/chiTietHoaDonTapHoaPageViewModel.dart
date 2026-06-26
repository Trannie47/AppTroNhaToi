import 'package:AppTroNhaToi/Provider/chi-tiet-hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';
import 'package:flutter/material.dart';

class ChiTietHoaDonTapHoaPageViewModel extends ChangeNotifier {
  final HoaDonTapHoa hoaDon;
  final PhieuThuHdTh? phieuThu;
  final String? tenNguoiMua;
  final ChiTietTapHoaProvider _provider;

  List<chiTietHoaDonTapHoaPageModel> get dsChiTietHoaDonTapHoa =>
      _provider.list;
  bool get isLoading => _provider.isLoading;

  ChiTietHoaDonTapHoaPageViewModel({
    required this.hoaDon,
    required ChiTietTapHoaProvider provider,
    this.phieuThu,
    this.tenNguoiMua = 'Khách vãng lai',
  }) : _provider = provider {
    _provider.addListener(_onProviderUpdate);
    Future.microtask(() => _provider.fetchByMaHoaDon(hoaDon.maHoaDon!));
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
