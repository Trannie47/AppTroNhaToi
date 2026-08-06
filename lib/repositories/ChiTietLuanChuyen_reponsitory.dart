import 'package:AppTroNhaToi/core/network/ChiTietLuanChuyenApiClient.dart';
import 'package:AppTroNhaToi/models/chi_tiet_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';

class ChiTietLuanChuyenRepository {
  final ChiTietLuanChuyenApiClient chiTietLuanChuyenApiClient =
      ChiTietLuanChuyenApiClient();

  Future<List<ChiTietLuanChuyen>> getAll() async {
    return await chiTietLuanChuyenApiClient.getAll();
  }

  Future<List<HopDongLuanChuyenVM>> getBySuCo(int suCoId) async {
    return await chiTietLuanChuyenApiClient.getBySuCo(suCoId);
  }

  Future<ChiTietLuanChuyen?> themChiTietLuanChuyen(
    ChiTietLuanChuyen chiTiet,
  ) async {
    return await chiTietLuanChuyenApiClient.themChiTietLuanChuyen(chiTiet);
  }

  Future<bool> xoaChiTietLuanChuyen(int id) async {
    return await chiTietLuanChuyenApiClient.xoaChiTietLuanChuyen(id);
  }

  Future<ChiTietLuanChuyen?> capNhatChiTietLuanChuyen(
    ChiTietLuanChuyen chiTiet,
  ) async {
    return await chiTietLuanChuyenApiClient.capNhatChiTietLuanChuyen(chiTiet);
  }
}
