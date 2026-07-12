import 'package:AppTroNhaToi/core/network/SuaChuaApiClient.dart';
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

  Future<SuaChua?> themSuaChua(SuaChua suaChua) async {
    return await suaChuaApiClient.themSuaChua(suaChua);
  }

  Future<SuaChua?> capNhatSuaChua(SuaChua suaChua) async {
    return await suaChuaApiClient.capNhatSuaChua(suaChua);
  }

  Future<bool> xoaSuaChua(int id) async {
    return await suaChuaApiClient.xoaSuaChua(id);
  }
}
