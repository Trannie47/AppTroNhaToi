import '../core/network/LapRapThietBiApiCline.dart';
import '../core/network/ThietBiApiClient.dart'; // Hoặc ApiClient chứa hàm getThietBiByPhongId
import '../models/lap_rap.dart';

class LapRapThietBiRepository {
  final LapRapThietBiApiClient _lapRapApiClient = LapRapThietBiApiClient();
  final ThietBiApiClient _thietBiApiClient = ThietBiApiClient();

  Future<List<LapRap>> getThietBiByPhongId(int phongId) async {
    return await _thietBiApiClient.getThietBiByPhongId(phongId);
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required int soLuong,
    required DateTime ngayLap,
  }) async {
    return await _lapRapApiClient.taoLapRap(
      phongId: phongId,
      thietBiId: thietBiId,
      soLuong: soLuong,
      ngayLap: ngayLap,
    );
  }
  Future<LapRap?> capNhatLapRap({
    required int id,
    required int soLuong,
  }) async {
    return await _lapRapApiClient.capNhatLapRap(id: id, soLuong: soLuong);
  }
}