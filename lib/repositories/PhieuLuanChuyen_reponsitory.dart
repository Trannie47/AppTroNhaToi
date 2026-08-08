import 'package:AppTroNhaToi/core/network/PhieuLuanChuyenApiClient.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ItemNguoiLuanChuyenModel.dart';

class PhieuLuanChuyenRepository {
  final PhieuLuanChuyenApiClient chiTietLuanChuyenApiClient =
      PhieuLuanChuyenApiClient();

  Future<List<PhieuLuanChuyen>> getAll() async {
    return await chiTietLuanChuyenApiClient.getAll();
  }

  /// Lấy danh sách phiếu luân chuyển theo phòng cũ (phòng gắn trên hợp đồng).
  Future<List<PhieuLuanChuyen>> getLuanChuyenTheoPhong(int phongId) async {
    return await chiTietLuanChuyenApiClient.getLuanChuyenTheoPhong(phongId);
  }

  /// Lấy danh sách người đã luân chuyển tới phòng mới.
  Future<List<ItemNguoiLuanChuyenModel>> getLuanChuyenPhongMoi(
    int phongId,
  ) async {
    return await chiTietLuanChuyenApiClient.getLuanChuyenPhongMoi(phongId);
  }

  Future<PhieuLuanChuyen?> them(PhieuLuanChuyen chiTiet) async {
    return await chiTietLuanChuyenApiClient.themChiTietLuanChuyen(chiTiet);
  }

  Future<bool> xoa(int id) async {
    return await chiTietLuanChuyenApiClient.xoaChiTietLuanChuyen(id);
  }

  Future<bool?> capNhat(PhieuLuanChuyen chiTiet) async {
    return await chiTietLuanChuyenApiClient.capNhatChiTietLuanChuyen(chiTiet);
  }
}
