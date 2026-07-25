import 'dart:io';

import '../core/network/HoaDonPhongApiClient.dart';
import '../models/hoa_don_phong.dart';

class HoaDonPhongRepository {
  final HoaDonPhongApiClient _apiClient = HoaDonPhongApiClient();

  Future<Map<String, dynamic>> getHoaDonInitData({
    required int phongId,
    required String thangNam,
  }) async {
    return await _apiClient.getHoaDonInitData(
      phongId: phongId,
      thangNam: thangNam,
    );
  }

  Future<List<HoaDonPhong>> createHoaDonPhongBatch({
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
    return await _apiClient.createHoaDonPhongBatch(
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
  }

  Future<List<Map<String, dynamic>>> getDanhSachByPhong({
    required int phongId,
    String? thangNam,
  }) async {
    return await _apiClient.getDanhSachByPhong(
      phongId: phongId,
      thangNam: thangNam,
    );
  }

  Future<bool> deleteHoaDonPhong({required String maHoaDon}) async {
    return await _apiClient.deleteHoaDonPhong(maHoaDon: maHoaDon);
  }

  Future<Map<String, dynamic>> getChiTietHoaDon({required String maHoaDon}) async {
    return await _apiClient.getChiTietHoaDon(maHoaDon: maHoaDon);
  }
}