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

  /// Lấy 1 bản ghi lắp ráp theo id (dùng để khôi phục phòng/lắp đặt
  /// khi sửa 1 sự cố sửa chữa mà không mở kèm LapRap cố định).
  Future<LapRap?> getById(int id) async {
    try {
      return await _lapRapRepo.getById(id);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getById LapRapProvider: $e");
      }
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

  Future<bool?> capNhatLapRap({
    required int id,
    required String ghiChu,
    required DateTime ngayLap, // ← thêm tham số này
  }) async {
    try {
      final response = await _lapRapRepo.capNhatLapRap(
        id: id,
        ghiChu: ghiChu,
        ngayLap: ngayLap, // ← truyền tiếp xuống service/API call
      );
      // ... phần xử lý response, cập nhật list, notifyListeners()...
      return true;
    } catch (e) {
      return false;
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
        // Xóa khỏi TẤT CẢ list cache đang có trong Provider, không chỉ 1 list
        _listLapRap.removeWhere((e) => e.id == id);
        _listLapRapPage.removeWhere(
          (e) => e.lapRap.id == id,
        ); // nếu field này tồn tại
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
