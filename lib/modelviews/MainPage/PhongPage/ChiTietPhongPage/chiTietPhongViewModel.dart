import 'package:AppTroNhaToi/states/phong_save_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/phong_provider.dart';
import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../states/NguoiThueState.dart';

class ChiTietPhongViewModel extends ChangeNotifier {
  final PhongProvider _phongService;
  final NguoiThueProvider _nguoiThueService;
  final int _phongId;
  NguoiThueState _nguoiThueState = NguoiThueLoading();
  NguoiThueState get nguoiThueState => _nguoiThueState;

  PhongSaveState _phongSaveState = PhongSaveInitial();
  PhongSaveState get phongSaveState => _phongSaveState;

  ChiTietPhongViewModel(
    this._phongService,
    this._nguoiThueService,
    this._phongId,
  ) {
    _phongService.addListener(_onProviderUpdate);
  }

  Future<void> getListNguoiThueFromIdPhong(int idPhong) async {
    _nguoiThueState = NguoiThueLoading();
    notifyListeners();
    try {
      final result = await _nguoiThueService.getListNguoiThueFromIdPhong(
        idPhong,
      );
      _nguoiThueState = NguoiThueSuccess(result);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiThueViewModel $e");
      }
      _nguoiThueState = NguoiThueError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
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
    super.dispose();
  }
}
