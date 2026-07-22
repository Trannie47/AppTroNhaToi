import 'package:AppTroNhaToi/core/network/NguoiLuuTruTamThoiApiClient.dart';

import '../../models/nguoi_luu_tru_tam_thoi.dart';

class NguoiLuuTruTamThoiRepository {
  final NguoiLuuTruTamThoiApiClient _apiClient= NguoiLuuTruTamThoiApiClient();


  Future<List<NguoiLuuTruTamThoi>> getDanhSachLuuTru({int? idnt}) async {
    return await _apiClient.getDanhSachLuuTru(idnt: idnt);
  }

  Future<NguoiLuuTruTamThoi?> createNguoiLuuTru(NguoiLuuTruTamThoi item) async {
    return await _apiClient.createNguoiLuuTru(item);
  }

  Future<NguoiLuuTruTamThoi?> updateLuuTru(NguoiLuuTruTamThoi item) async {
    return await _apiClient.updateLuuTru(item);
  }

  Future<bool> deleteLuuTru(int idtt) async {
    return await _apiClient.deleteLuuTru(idtt);
  }
}