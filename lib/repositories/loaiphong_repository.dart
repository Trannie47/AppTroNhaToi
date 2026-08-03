import 'package:AppTroNhaToi/core/network/LoaiPhongApiClient.dart';
import 'package:AppTroNhaToi/models/loai_phong.dart';

class LoaiPhongRepository {
  final LoaiPhongApiClient loaiPhongApiClient = LoaiPhongApiClient();

  Future<List<LoaiPhong>> getListLoaiPhong() async {
    return await loaiPhongApiClient.getListLoaiPhong();
  }

  Future<LoaiPhong?> createLoaiPhong(LoaiPhong loaiPhong) async {
    return await loaiPhongApiClient.createLoaiPhong(loaiPhong);
  }

  Future<LoaiPhong?> updateLoaiPhong(LoaiPhong loaiPhong) async {
    return await loaiPhongApiClient.updateLoaiPhong(loaiPhong);
  }

  Future<bool> deleteLoaiPhong(int maLoaiPhong) async {
    return await loaiPhongApiClient.deleteLoaiPhong(maLoaiPhong);
  }
}
