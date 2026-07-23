import 'package:flutter/material.dart';
import '../models/cau_hinh_gia.dart';
import '../repositories/cauhinhgia_repository.dart';


class CauHinhGiaProvider extends ChangeNotifier {
  final CauHinhGiaRepository _repository = CauHinhGiaRepository();

  CauHinhGia? _cauHinhGia;
  bool _isLoading = false;
  String? _errorMessage;

  CauHinhGia? get cauHinhGia => _cauHinhGia;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<CauHinhGia?> getGiaHienTai() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cauHinhGia = await _repository.getGiaHienTai();
      return _cauHinhGia;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CauHinhGia?> updateGia(double giaDien, double giaNuoc) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cauHinhGia = await _repository.updateGia(giaDien, giaNuoc);
      return _cauHinhGia;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}