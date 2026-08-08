import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/repositories/PhieuLuanChuyen_reponsitory.dart';
import 'package:flutter/foundation.dart';

class PhieuLuanChuyenProvider extends ChangeNotifier {
  final PhieuLuanChuyenRepository _repo = PhieuLuanChuyenRepository();

  List<PhieuLuanChuyen> _list = [];
  List<PhieuLuanChuyen> get list => List.unmodifiable(_list);

  List<PhieuLuanChuyen> _listByPhongHopDong = [];
  List<PhieuLuanChuyen> get listByPhongHopDong =>
      List.unmodifiable(_listByPhongHopDong);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    _list = [];
    notifyListeners();

    try {
      _list = await _repo.getAll();
    } catch (e) {
      _list = [];
      if (kDebugMode) {
        print("Lỗi ChiTietLuanChuyenProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách phiếu luân chuyển theo phòng cũ (phòng gắn trên hợp đồng).
  Future<void> find(int phongId) async {
    if (_isLoading) return;

    _isLoading = true;
    _listByPhongHopDong = [];
    notifyListeners();

    try {
      _listByPhongHopDong = await _repo.getLuanChuyenTheoPhong(phongId);
    } catch (e) {
      _listByPhongHopDong = [];
      if (kDebugMode) {
        print("Lỗi PhieuLuanChuyenProvider.find: $e");
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PhieuLuanChuyen?> them(PhieuLuanChuyen item) async {
    final result = await _repo.them(item);

    if (result != null) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> capNhat(PhieuLuanChuyen item) async {
    final ok = await _repo.capNhat(item);

    if (ok == true) {
      await fetchAll();
      return true;
    }

    return false;
  }

  Future<bool> xoa(int id) async {
    final ok = await _repo.xoa(id);

    if (ok) {
      await fetchAll();
    }

    return ok;
  }

  void clear() {
    _list.clear();
    _listByPhongHopDong.clear();
    notifyListeners();
  }
}
