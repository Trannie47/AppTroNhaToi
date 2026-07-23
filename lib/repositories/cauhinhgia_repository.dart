

import '../core/network/CauHinhGiaApiClien.dart';
import '../models/cau_hinh_gia.dart';

class CauHinhGiaRepository {
  final CauHinhGiaApiClient _apiClient = CauHinhGiaApiClient();

  Future<CauHinhGia> getGiaHienTai() async {
    return await _apiClient.getGiaHienTai();
  }

  Future<CauHinhGia> updateGia(double giaDien, double giaNuoc) async {
    return await _apiClient.updateGia(giaDien, giaNuoc);
  }
}