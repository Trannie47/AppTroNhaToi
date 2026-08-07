import '../core/network/CauHinhGiaApiClien.dart';
import '../models/cau_hinh_gia.dart';

class CauHinhGiaRepository {
  final CauHinhGiaApiClient _apiClient = CauHinhGiaApiClient();

  Future<CauHinhGia> getGiaHienTai() async {
    return await _apiClient.getGiaHienTai();
  }

  Future<CauHinhGia> updateGia({
    required double giaDien,
    required double giaNuoc,
    double? giaXeMay,
    double? giaXeHoi,
    double? giaXeDap,
  }) async {
    return await _apiClient.updateGia(
      giaDien: giaDien,
      giaNuoc: giaNuoc,
      giaXeMay: giaXeMay,
      giaXeHoi: giaXeHoi,
      giaXeDap: giaXeDap,
    );
  }

  Future<double> getGiaXeMacDinh(int loaiXe) async {
    return await _apiClient.getGiaXeMacDinh(loaiXe);
  }
}