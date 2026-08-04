import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../models/hoa_don_phong.dart';
import '../repositories/hoadonphong_repository.dart';

class HoadonPhongProvider extends ChangeNotifier {
  final HoaDonPhongRepository _repository = HoaDonPhongRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _initData;
  Map<String, dynamic>? get initData => _initData;

  List<Map<String, dynamic>> _danhSachHoaDonByPhong = [];
  List<Map<String, dynamic>> get danhSachHoaDonByPhong =>
      _danhSachHoaDonByPhong;

  List<HoaDonPhong> _createdHoaDonList = [];
  List<HoaDonPhong> get createdHoaDonList => _createdHoaDonList;
  // ds hóa đơn ở chức năng hóa đơn ngoài tổng quan
  List<Map<String, dynamic>> _danhSachTatCaHoaDon = [];
  List<Map<String, dynamic>> get danhSachTatCaHoaDon => _danhSachTatCaHoaDon;

  Future<void> fetchInitData({
    required int phongId,
    required String thangNam,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _initData = await _repository.getHoaDonInitData(
        phongId: phongId,
        thangNam: thangNam,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createHoaDonBatch({
    required int phongId,
    required String thangNam,
    String? ngayLap,
    bool isChotDienNuoc = false,
    int? chiSoDienCu,
    int? chiSoDienMoi,
    int? chiSoNuocCu,
    int? chiSoNuocMoi,
    double tienDichVuKhac = 0,
    String? ghiChu,
    String? danhSachHopDongJson,
    File? anhDienMoi,
    File? anhNuocMoi,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _createdHoaDonList = await _repository.createHoaDonPhongBatch(
        phongId: phongId,
        thangNam: thangNam,
        ngayLap: ngayLap,
        isChotDienNuoc: isChotDienNuoc,
        chiSoDienCu: chiSoDienCu,
        chiSoDienMoi: chiSoDienMoi,
        chiSoNuocCu: chiSoNuocCu,
        chiSoNuocMoi: chiSoNuocMoi,
        tienDichVuKhac: tienDichVuKhac,
        ghiChu: ghiChu,
        danhSachHopDongJson: danhSachHopDongJson,
        anhDienMoi: anhDienMoi,
        anhNuocMoi: anhNuocMoi,
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

  Future<void> fetchDanhSachByPhong({
    required int phongId,
    String? thangNam,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _danhSachHoaDonByPhong = await _repository.getDanhSachByPhong(
        phongId: phongId,
        thangNam: thangNam,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTatCaHoaDonQuanLy({String? thangNam}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _danhSachTatCaHoaDon = await _repository.getTatCaHoaDonQuanLy(
        thangNam: thangNam,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteHoaDon({required String maHoaDon}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.deleteHoaDonPhong(maHoaDon: maHoaDon);
      if (success) {
        _danhSachHoaDonByPhong.removeWhere(
          (item) => item['maHoaDon'] == maHoaDon,
        );
      }
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

  Future<Map<String, dynamic>> getChiTietHoaDon({
    required String maHoaDon,
  }) async {
    try {
      return await _repository.getChiTietHoaDon(maHoaDon: maHoaDon);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
