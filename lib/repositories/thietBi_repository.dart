import 'package:AppTroNhaToi/core/network/ThietBiApiClient.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPageModel.dart';

import '../models/lap_rap.dart';

class ThietBiRepository {
  final ThietBiApiClient thietBiApiClient = ThietBiApiClient();

  Future<List<ThietBiPageModel>> getListThietBi() async {
    final result = await thietBiApiClient.getListThietBi();
    return result;
  }

  Future<ThietBi?> themThietBi(ThietBi thietBi) async {
    return await thietBiApiClient.themThietBi(thietBi);
  }

  Future<bool> xoaThietBi(int thietBiID) async {
    return await thietBiApiClient.xoaThietBi(thietBiID);
  }

  Future<ThietBi?> capNhatThietBi(ThietBi thietBi) async {
    return await thietBiApiClient.capNhatThietBi(thietBi);
  }

  Future<List<LapRap>> getThietBiByPhongId(int phongId) async {
    return await thietBiApiClient.getThietBiByPhongId(phongId);
  }
}
