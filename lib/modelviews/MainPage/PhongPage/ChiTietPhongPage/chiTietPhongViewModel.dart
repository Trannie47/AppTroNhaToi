import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_luan_chuyen_provider.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/states/phong_save_state.dart';
import 'package:flutter/foundation.dart';

import '../../../../Provider/phong_provider.dart';

class ChiTietPhongViewModel extends ChangeNotifier {
  final PhongProvider _phongService;
  final HopDongProvider _hopDongProvider;
  final PhieuLuanChuyenProvider phieuLuanChuyenProvider;
  final int _phongId;

  bool isLoadingHopDongHienTai = true;
  String? errorHopDongHienTai;
  // null nếu phòng hiện đang trống, không có hợp đồng nào hiệu lực
  HopDongDTO? hopDongHienTai;

  PhongSaveState _phongSaveState = PhongSaveInitial();
  PhongSaveState get phongSaveState => _phongSaveState;

  ChiTietPhongViewModel(
    this._phongService,
    this._hopDongProvider,
    this.phieuLuanChuyenProvider,
    this._phongId,
  ) {
    _phongService.addListener(_onProviderUpdate);
    phieuLuanChuyenProvider.addListener(_onProviderUpdate);
  }

  Future<void> getHopDongHienTaiCuaPhong(int idPhong) async {
    isLoadingHopDongHienTai = true;
    errorHopDongHienTai = null;
    notifyListeners();
    try {
      final tatCaHopDong = await _hopDongProvider.getListHD();
      final hopDongHieuLuc = tatCaHopDong.where(
        (hd) => hd.phongID == idPhong && hd.trangThai == 1,
      );
      hopDongHienTai = hopDongHieuLuc.isNotEmpty
          ? hopDongHieuLuc.first
          : null;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getHopDongHienTaiCuaPhong ChiTietPhongViewModel: $e");
      }
      errorHopDongHienTai = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingHopDongHienTai = false;
      notifyListeners();
    }
  }

  Future<void> getDsNguoiLuanChuyen(int idPhong) async {
    try {
      await phieuLuanChuyenProvider.getLuanChuyenPhongMoi(idPhong);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getDsNguoiLuanChuyen ChiTietPhongViewModel: $e");
      }
    }finally {
      notifyListeners();
    }

  }

  Future<void> removePhong(int idPhong) async {
    _phongSaveState = PhongSaveLoading();
    notifyListeners();
    try {
      final result = await _phongService.removePhong(idPhong);
      if (result != null) {
        _phongService.removeRoomFromList(idPhong);
        _phongSaveState = PhongSaveSuccess(result);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiThueViewModel $e");
      }
      _phongSaveState = PhongSaveError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _phongService.removeListener(_onProviderUpdate);
    phieuLuanChuyenProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
