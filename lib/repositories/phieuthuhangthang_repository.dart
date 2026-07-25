import '../core/network/PhieuThuHangThangApiClient.dart';
import '../models/phieu_thu_hang_thang.dart';

class PhieuThuHangThangRepository {
  final PhieuThuHangThangApiClient _apiClient = PhieuThuHangThangApiClient();

  Future<Map<String, dynamic>> createPhieuThu({
    required String maHoaDon,
    required double soTien,
    String? ghiChu,
  }) async {
    return await _apiClient.createPhieuThu(
      maHoaDon: maHoaDon,
      soTien: soTien,
      ghiChu: ghiChu,
    );
  }

  Future<List<PhieuThuHangThang>> getByMaHoaDon({required String maHoaDon}) async {
    return await _apiClient.getByMaHoaDon(maHoaDon: maHoaDon);
  }

  Future<Map<String, dynamic>> deletePhieuThu({required int maPhieuThu}) async {
    return await _apiClient.deletePhieuThu(maPhieuThu: maPhieuThu);
  }
}