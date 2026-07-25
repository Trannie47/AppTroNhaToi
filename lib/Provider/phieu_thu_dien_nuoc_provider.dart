import 'package:flutter/material.dart';
import '../models/phieuthu_diennuoc.dart';
import '../repositories/phieuthu_diennuoc_repository.dart';

class PhieuThuDienNuocProvider extends ChangeNotifier {
  final PhieuThuDienNuocRepository _repository = PhieuThuDienNuocRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PhieuThuDienNuoc? _phieuThuMoi;
  PhieuThuDienNuoc? get phieuThuMoi => _phieuThuMoi;

  Future<bool> createPhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
    required double soTien,
    String? ghiChu,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _phieuThuMoi = await _repository.createPhieuThuDienNuoc(
        phongId: phongId,
        thangNam: thangNam,
        lanGhi: lanGhi,
        soTien: soTien,
        ghiChu: ghiChu,
      );

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

  Future<bool> removePhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.removePhieuThuDienNuoc(
        phongId: phongId,
        thangNam: thangNam,
        lanGhi: lanGhi,
      );

      _isLoading = false;
      notifyListeners();
      return success;
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