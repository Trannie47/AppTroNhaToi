
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../models/item_phong.dart';

class ChiTietHopDongViewModel extends ChangeNotifier {
  final PhongProvider _phongProvider;
  ChiTietHopDongViewModel(this._phongProvider);

  late HopDongDTO _hopDong;
  HopDongDTO get hopDong => _hopDong;

  bool _isLoadingPhong = false;
  bool get isLoadingPhong => _isLoadingPhong;


  void init(HopDongDTO hd) {
    _hopDong = hd;
    notifyListeners();
  }
  //lấy thông tin itemPhong để hieenr thij thông tin chi tiết phòng
  Future<ItemPhong?> getInforPhong(int phongId) async {
    //Tìm trong list đã có sẵn
    final phongTrongList = _phongProvider.listPhong
        .where((p) => p.phongId == phongId)
        .firstOrNull;

    if (phongTrongList != null) return phongTrongList;

    //Không có → gọi API
    _isLoadingPhong = true;
    notifyListeners();
    try {
      return await _phongProvider.getInforPhong(phongId);
    } catch (e) {
      if (kDebugMode) print("Lỗi getInforPhong: $e");
      return null;
    } finally {
      _isLoadingPhong = false;
      notifyListeners();
    }
  }
}
