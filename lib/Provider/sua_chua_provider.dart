import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/repositories/suaChua_reponsitory.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/foundation.dart';

class SuaChuaProvider extends ChangeNotifier {
  final SuaChuaRepository _repo = SuaChuaRepository();

  List<LichSuSuaChuaPageModel> _list = [];
  List<LichSuSuaChuaPageModel> get list => List.unmodifiable(_list);

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
      if (kDebugMode) print("Lỗi SuaChuaProvider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SuaChuaDTO?> them(SuaChuaDTO suaChua) async {
    final result = await _repo.themSuaChua(suaChua);

    if (result != null) {
      await fetchByThietBi(result.thietBiId!);
    }

    return result;
  }

  Future<SuaChuaDTO?> capNhat(SuaChuaDTO suaChua) async {
    final result = await _repo.capNhatSuaChua(suaChua);

    if (result != null) {
      await fetchByThietBi(result.thietBiId!);
    }

    return result;
  }

  Future<bool> xoa(int id, int thietBiID) async {
    final ok = await _repo.xoaSuaChua(id);

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
