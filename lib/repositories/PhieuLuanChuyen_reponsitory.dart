import 'package:AppTroNhaToi/core/network/PhieuLuanChuyenApiClient.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';

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
