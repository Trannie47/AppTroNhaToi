import 'package:AppTroNhaToi/Provider/chi_tiet_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu-thu-hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';
import 'package:flutter/material.dart';

class ChiTietHoaDonTapHoaPageViewModel extends ChangeNotifier {
  final HoaDonTapHoa hoaDon;
  final String? tenNguoiMua;

  final ChiTietTapHoaProvider _chiTietProvider;
  final PhieuThuHdThProvider _phieuThuProvider;

  List<chiTietHoaDonTapHoaPageModel> get dsChiTietHoaDonTapHoa =>
      _chiTietProvider.list;

  List<PhieuThuHdTh> get dsPhieuThu => _phieuThuProvider.list;

  bool get isLoading =>
      _chiTietProvider.isLoading || _phieuThuProvider.isLoading;

  ChiTietHoaDonTapHoaPageViewModel({
    required this.hoaDon,
    required ChiTietTapHoaProvider chiTietProvider,
    required PhieuThuHdThProvider phieuThuProvider,
    this.tenNguoiMua = 'Khách vãng lai',
  }) : _chiTietProvider = chiTietProvider,
       _phieuThuProvider = phieuThuProvider {
    _chiTietProvider.addListener(_onProviderUpdate);
    _phieuThuProvider.addListener(_onProviderUpdate);

    Future.microtask(() async {
      await _chiTietProvider.fetchByMaHoaDon(hoaDon.maHoaDon!);
      await _phieuThuProvider.fetchByMaHoaDon(hoaDon.maHoaDon!);
    });
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _chiTietProvider.removeListener(_onProviderUpdate);
    _phieuThuProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
