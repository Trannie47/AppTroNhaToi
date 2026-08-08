import 'package:AppTroNhaToi/core/network/PhongApiClient.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';

import '../models/phong.dart';

class PhongRepository {
  final PhongApiClient _phongApiClient = PhongApiClient();

  Future<List<ItemPhong>> getListPhong() async {
    return await _phongApiClient.getListPhong();
  }

  Future<Phong?> saveRoom(Phong room) async {
    return await _phongApiClient.SaveRoom(room);
  }

  Future<Phong?> updateRoom(Phong room) async {
    return await _phongApiClient.updateRoom(room);
  }

  Future<Phong?> remove(int idPhong) async {
    return await _phongApiClient.removePhong(idPhong);
  }

  Future<ItemPhong> getInforPhong(int maPhong) {
    return _phongApiClient.getInforPhong(maPhong);
  }

  Future<List<ItemPhong>> getListByThietBi(int thietBiId) async {
    return await _phongApiClient.getListByThietBi(thietBiId);
  }

  /// Danh sách phòng có thể luân chuyển tới cho 1 hợp đồng (đã lọc còn chỗ trống).
  Future<List<ItemPhong>> getCoTheLuanChuyenByHopDong(String hopDongId) async {
    return await _phongApiClient.getCoTheLuanChuyenByHopDong(hopDongId);
  }
}
