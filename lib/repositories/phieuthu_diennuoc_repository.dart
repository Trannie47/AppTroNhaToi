import '../core/network/PhieuThuDienNuocApiClient.dart';
import '../models/phieuthu_diennuoc.dart';

class PhieuThuDienNuocRepository {
  final PhieuThuDienNuocApiClient _apiClient = PhieuThuDienNuocApiClient();

  Future<PhieuThuDienNuoc> createPhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
    required double soTien,
    String? ghiChu,
  }) async {
    return await _apiClient.createPhieuThuDienNuoc(
      phongId: phongId,
      thangNam: thangNam,
      lanGhi: lanGhi,
      soTien: soTien,
      ghiChu: ghiChu,
    );
  }

  Future<bool> removePhieuThuDienNuoc({
    required int phongId,
    required String thangNam,
    required int lanGhi,
  }) async {
    return await _apiClient.removePhieuThuDienNuoc(
      phongId: phongId,
      thangNam: thangNam,
      lanGhi: lanGhi,
    );
  }
}