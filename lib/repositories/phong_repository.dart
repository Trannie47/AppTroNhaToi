import 'package:AppTroNhaToi/core/network/PhongApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/item_phong_model.dart';

import '../models/phong.dart';

class PhongRepository {
  final PhongApiClient _phongApiClient = PhongApiClient();

  Future<List<ItemPhongModel>> getListPhong() async {
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

  Future<ItemPhongModel> getInforPhong(int maPhong) {
    return _phongApiClient.getInforPhong(maPhong);
  }

  Future<List<ItemPhongModel>> getListByThietBi(int thietBiId) async {
    return await _phongApiClient.getListByThietBi(thietBiId);
  }

  /// Danh sách phòng có thể luân chuyển tới cho 1 hợp đồng (đã lọc còn chỗ trống).
  Future<List<ItemPhongModel>> getCoTheLuanChuyenByHopDong(
    String hopDongId,
  ) async {
    return await _phongApiClient.getCoTheLuanChuyenByHopDong(hopDongId);
  }

  /// Danh sách phòng có thể chọn khi tạo hợp đồng "Ở GHÉP"
  Future<List<RoomAvailableDTO>> getPhongChoOGhep(int soNguoi) async {
    return await _phongApiClient.getPhongChoOGhep(soNguoi);
  }

  /// Danh sách phòng có thể chọn khi tạo hợp đồng "Ở MỘT MÌNH"
  Future<List<RoomAvailableDTO>> getPhongChoOMotMinh(int soNguoi) async {
    return await _phongApiClient.getPhongChoOMotMinh(soNguoi);
  }
}
