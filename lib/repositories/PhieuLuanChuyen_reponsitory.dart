import 'package:AppTroNhaToi/core/network/PhieuLuanChuyenApiClient.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';

class PhieuLuanChuyenRepository {
  final PhieuLuanChuyenApiClient chiTietLuanChuyenApiClient =
      PhieuLuanChuyenApiClient();

  Future<List<PhieuLuanChuyen>> getAll() async {
    return await chiTietLuanChuyenApiClient.getAll();
  }

  Future<List<HopDongLuanChuyenVM>> getBySuCo(int suCoId) async {
    return await chiTietLuanChuyenApiClient.getBySuCo(suCoId);
  }

  Future<PhieuLuanChuyen?> themChiTietLuanChuyen(
    PhieuLuanChuyen chiTiet,
  ) async {
    return await chiTietLuanChuyenApiClient.themChiTietLuanChuyen(chiTiet);
  }

  Future<bool> xoaChiTietLuanChuyen(int id) async {
    return await chiTietLuanChuyenApiClient.xoaChiTietLuanChuyen(id);
  }

  Future<PhieuLuanChuyen?> capNhatChiTietLuanChuyen(
    PhieuLuanChuyen chiTiet,
  ) async {
    return await chiTietLuanChuyenApiClient.capNhatChiTietLuanChuyen(chiTiet);
  }
}
