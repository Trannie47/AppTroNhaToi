import 'package:AppTroNhaToi/core/network/LapRapApiClient.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';

class LapRapRepository {
  final LapRapApiClient _lapRapApiClient = LapRapApiClient();

  Future<List<LapRapPageModel>> getThietBiByPhongId(int phongId) async {
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

  Future<LapRap?> capNhatLapRap({
    required int id,
    required String ghiChu,
  }) async {
    return await _lapRapApiClient.capNhatLapRap(id: id, ghiChu: ghiChu);
  }
}
