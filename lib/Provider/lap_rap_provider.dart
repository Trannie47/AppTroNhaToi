import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';
import 'package:flutter/foundation.dart';
import '../models/lap_rap.dart';
import '../repositories/lapRap_repository.dart';

class LapRapProvider extends ChangeNotifier {
  final LapRapRepository _lapRapRepo = LapRapRepository();

  Future<List<ThietBiPhongPageModel>> getThietBiByPhongId(int phongId) async {
    return await _lapRapRepo.getThietBiByPhongId(phongId);
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    return await _lapRapRepo.taoLapRap(
      phongId: phongId,
      thietBiId: thietBiId,
      ghiChu: ghiChu,
      ngayLap: ngayLap,
    );
  }

  Future<bool?> capNhatLapRap({required int id, required String ghiChu}) async {
    return await _lapRapRepo.capNhatLapRap(id: id, ghiChu: ghiChu);
  }

  // Future<bool> xoaLapRap(int id) async {
  //   return await _lapRapRepo.xoaLapRap(id);
  // }
}
