import 'package:AppTroNhaToi/core/network/SuaChuaApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';

class SuaChuaRepository {
  final SuaChuaApiClient suaChuaApiClient = SuaChuaApiClient();

  Future<List<SuaChua>> getAll() async {
    return await suaChuaApiClient.getAll();
  }

  Future<SuaChua?> getById(int id) async {
    return await suaChuaApiClient.getById(id);
  }

  Future<List<LichSuSuaChuaPageModel>> getTheoThietBi(int thietBiID) async {
    return await suaChuaApiClient.getTheoThietBi(thietBiID);
  }

  Future<List<LichSuSuaChuaPageModel>> getTheoThietBiVaLapRap(
    int thietBiID,
    int lapRapId,
  ) async {
    return await suaChuaApiClient.getTheoThietBiVaLapRap(thietBiID, lapRapId);
  }

  Future<SuaChuaDTO?> themSuaChua(SuaChuaDTO suaChua) async {
    return await suaChuaApiClient.themSuaChua(suaChua);
  }

  Future<SuaChuaDTO?> capNhatSuaChua(SuaChuaDTO suaChua) async {
    return await suaChuaApiClient.capNhatSuaChua(suaChua);
  }

  Future<bool> xoaSuaChua(int id) async {
    return await suaChuaApiClient.xoaSuaChua(id);
  }
}
