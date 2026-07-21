import 'package:flutter/foundation.dart';
import '../models/lap_rap.dart';
import '../repositories/lapRapThietBi_repository.dart';

class LapRapThietbiProvider extends ChangeNotifier {
  final LapRapThietBiRepository _lapRapRepo = LapRapThietBiRepository();

  Future<List<LapRap>> getThietBiByPhongId(int phongId) async {
    return await _lapRapRepo.getThietBiByPhongId(phongId);
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required int soLuong,
    required DateTime ngayLap,
  }) async {
    return await _lapRapRepo.taoLapRap(
      phongId: phongId,
      thietBiId: thietBiId,
      soLuong: soLuong,
      ngayLap: ngayLap,
    );
  }
}