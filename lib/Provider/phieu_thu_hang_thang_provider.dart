import 'package:flutter/material.dart';
import '../models/phieu_thu_hang_thang.dart';
import '../repositories/phieuthuhangthang_repository.dart';

class PhieuThuHangThangProvider extends ChangeNotifier {
  final PhieuThuHangThangRepository _repository = PhieuThuHangThangRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PhieuThuHangThang> _listPhieuThu = [];
  List<PhieuThuHangThang> get listPhieuThu => _listPhieuThu;

  Future<void> fetchByMaHoaDon(String maHoaDon) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listPhieuThu = await _repository.getByMaHoaDon(maHoaDon: maHoaDon);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> createPhieuThu({
    required String maHoaDon,
    required double soTien,
    String? ghiChu,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.createPhieuThu(
        maHoaDon: maHoaDon,
        soTien: soTien,
        ghiChu: ghiChu,
      );

      final phieuThuMoi = result['phieuThu'] as PhieuThuHangThang;
      _listPhieuThu.insert(0, phieuThuMoi); // Thêm nhanh vào đầu danh sách local

      _isLoading = false;
      notifyListeners();
      return result; // Trả về cho ViewModel/UI bóc tách hoaDonUpdated
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deletePhieuThu(int maPhieuThu) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.deletePhieuThu(maPhieuThu: maPhieuThu);
      if (res['success'] == true) {
        _listPhieuThu.removeWhere((item) => item.maPhieuThu == maPhieuThu);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}