import '../core/network/CauHinhGiaXeApiClient.dart';
import '../models/cau_hinh_gia_xe.dart';

class CauHinhGiaXeRepository {
  final CauHinhGiaXeApiClient _apiClient = CauHinhGiaXeApiClient();

  Future<List<CauHinhGiaXe>> getAll() async {
    return await _apiClient.getAll();
  }

  Future<CauHinhGiaXe> getByLoaiXe(int loaiXe) async {
    return await _apiClient.getByLoaiXe(loaiXe);
  }

  Future<CauHinhGiaXe> update({
    required int loaiXe,
    required double giaMacDinh,
    String? tenLoaiXe,
  }) async {
    return await _apiClient.update(
      loaiXe: loaiXe,
      giaMacDinh: giaMacDinh,
      tenLoaiXe: tenLoaiXe,
    );
  }
}