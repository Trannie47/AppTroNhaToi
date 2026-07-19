import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/repositories/lichSuMuaThietBi_reponsitory.dart';
import 'package:flutter/foundation.dart';

class LichSuMuaThietBiProvider extends ChangeNotifier {
  final LichSuMuaThietBiRepository _repo = LichSuMuaThietBiRepository();

  List<LichSuMuaThietBi> _list = [];

  List<LichSuMuaThietBi> get list => List.unmodifiable(_list);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchByThietBi(int thietBiID) async {
    if (_isLoading) return;

    _isLoading = true;
    _list = [];
    notifyListeners();

    try {
      _list = await _repo.getTheoThietBi(thietBiID);
    } catch (e) {
      _list = [];

      if (kDebugMode) {
        print("Lỗi LichSuMuaThietBiProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<LichSuMuaThietBi?> them(LichSuMuaThietBi lichSu) async {
    final result = await _repo.them(lichSu);
    if (result != null) {
      await fetchByThietBi(result.thietBiID!);
    }

    return result;
  }

  Future<bool> capNhat(LichSuMuaThietBi lichSu) async {
    final result = await _repo.capNhat(lichSu);

    if (result != null) {
      await fetchByThietBi(result.thietBiID!);
      return true;
    }

    return false;
  }

  Future<bool> xoa(int id, int thietBiID) async {
    final ok = await _repo.xoa(id);

    if (ok) {
      await fetchByThietBi(thietBiID);
    }

    return ok;
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
