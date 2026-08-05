import 'package:AppTroNhaToi/core/network/LapRapApiClient.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';

class LapRapRepository {
  final LapRapApiClient _lapRapApiClient = LapRapApiClient();

  Future<List<ThietBiPhongPageModel>> getThietBiByPhongId(int phongId) async {
    return await _lapRapApiClient.getThietBiByPhongId(phongId);
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    return await _lapRapApiClient.taoLapRap(
      phongId: phongId,
      thietBiId: thietBiId,
      ghiChu: ghiChu,
      ngayLap: ngayLap,
    );
  }

  Future<bool?> capNhatLapRap({required int id, required String ghiChu}) async {
    return await _lapRapApiClient.capNhatLapRap(id: id, ghiChu: ghiChu);
  }

  Future<List<LapRapPageModel>> findByPhongVaThietBi({
    required int phongId,
    required int thietBiId,
  }) async {
    return await _lapRapApiClient.findByPhongVaThietBi(
      phongId: phongId,
      thietBiId: thietBiId,
    );
  }

  Future<bool> xoaLapRap(int id) async {
    return await _lapRapApiClient.xoaLapRap(id);
  }
}
