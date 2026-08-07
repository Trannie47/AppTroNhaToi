import 'package:flutter/foundation.dart';
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

  Future<CauHinhGia?> updateGia({
    required double giaDien,
    required double giaNuoc,
    double? giaXeMay,
    double? giaXeHoi,
    double? giaXeDap,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cauHinhGia = await _repository.updateGia(
        giaDien: giaDien,
        giaNuoc: giaNuoc,
        giaXeMay: giaXeMay,
        giaXeHoi: giaXeHoi,
        giaXeDap: giaXeDap,
      );
      return _cauHinhGia;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<double?> getGiaXeMacDinh(int loaiXe) async {
    try {
      return await _repository.getGiaXeMacDinh(loaiXe);
    } catch (e) {
      if (kDebugMode) print("Lỗi lấy giá mặc định theo loại xe: $e");
      return null;
    }
  }
}