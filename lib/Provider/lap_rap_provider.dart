import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/repositories/lapRap_repository.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';
import 'package:flutter/foundation.dart';

class LapRapProvider extends ChangeNotifier {
  final LapRapRepository _lapRapRepo = LapRapRepository();

  List<LapRap> _listLapRap = [];
  List<LapRap> get listLapRap => _listLapRap;

  List<LapRapPageModel> _listLapRapPage = [];
  List<LapRapPageModel> get listLapRapPage => _listLapRapPage;

  Future<List<ThietBiPhongPageModel>> getThietBiByPhongId(int phongId) async {
    try {
      return await _lapRapRepo.getThietBiByPhongId(phongId);
    } catch (e) {
      rethrow;
    }
  }

  Future<LapRap?> taoLapRap({
    required int phongId,
    required int thietBiId,
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    try {
      final result = await _lapRapRepo.taoLapRap(
        phongId: phongId,
        thietBiId: thietBiId,
        ghiChu: ghiChu,
        ngayLap: ngayLap,
      );

      if (result != null) {
        _listLapRap.insert(0, result);
        notifyListeners();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> capNhatLapRap({required int id, required String ghiChu}) async {
    try {
      final result = await _lapRapRepo.capNhatLapRap(id: id, ghiChu: ghiChu);

      if (result == true) {
        final index = _listLapRap.indexWhere((e) => e.id == id);

        if (index != -1) {
          _listLapRap[index] = _listLapRap[index].copyWith(ghiChu: ghiChu);

          notifyListeners();
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LapRapPageModel>> findByPhongVaThietBi({
    required int phongId,
    required int thietBiId,
  }) async {
    try {
      final result = await _lapRapRepo.findByPhongVaThietBi(
        phongId: phongId,
        thietBiId: thietBiId,
      );

      _listLapRapPage = result;
      notifyListeners();

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> xoaLapRap(int id) async {
    try {
      final result = await _lapRapRepo.xoaLapRap(id);

      if (result) {
        _listLapRap.removeWhere((e) => e.id == id);
        notifyListeners();
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi xoaLapRap Provider: $e");
      }
      return false;
    }
  }
}
