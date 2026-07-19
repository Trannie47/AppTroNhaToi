import 'package:AppTroNhaToi/core/network/LichSuThemThietBiApiClient.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';

class LichSuMuaThietBiRepository {
  final LichSuMuaThietBiApiClient apiClient = LichSuMuaThietBiApiClient();

  Future<List<LichSuMuaThietBi>> getAll() async {
    return await apiClient.getAll();
  }

  Future<LichSuMuaThietBi?> getById(int id) async {
    return await apiClient.getById(id);
  }

  Future<List<LichSuMuaThietBi>> getTheoThietBi(int thietBiID) async {
    return await apiClient.getTheoThietBi(thietBiID);
  }

  Future<LichSuMuaThietBi?> them(LichSuMuaThietBi lichSu) async {
    return await apiClient.them(lichSu);
  }

  Future<LichSuMuaThietBi?> capNhat(LichSuMuaThietBi lichSu) async {
    return await apiClient.capNhat(lichSu);
  }

  Future<bool> xoa(int id) async {
    return await apiClient.xoa(id);
  }
}
