import 'package:flutter/material.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';

class LichSuThuePageViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;

  LichSuThuePageViewModel(this._hopDongProvider);

  List<HopDongDTO> _dsLichSu = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<HopDongDTO> get dsLichSu => _dsLichSu;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init(int phongId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dsLichSu = await _hopDongProvider.getLichSuThuePhong(phongId);
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi khi tải lịch sử thuê. Vui lòng thử lại!';
      print("Lỗi tại LichSuThuePageViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}