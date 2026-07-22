// services/thiet_bi_service.dart
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/repositories/thietbi_repository.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPageModel.dart';
import 'package:flutter/foundation.dart';

class ThietBiProvider extends ChangeNotifier {
  final ThietBiRepository _repo = ThietBiRepository();

  List<ThietBiPageModel> _list = [];
  List<ThietBiPageModel> get list => List.unmodifiable(_list);

  int get soLuongDangSua {
    return _list.where((e) => e.thietBi.dangSua).length;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getListThietBi();

      // ID lớn nhất lên đầu
      _list.sort(
        (a, b) =>
            (b.thietBi.thietBiID ?? 0).compareTo(a.thietBi.thietBiID ?? 0),
      );
    } catch (e) {
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ThietBi?> them(ThietBi thietBi) async {
    final result = await _repo.themThietBi(thietBi);

    if (result != null) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> capNhat(ThietBi thietBi) async {
    final result = await _repo.capNhatThietBi(thietBi);

    if (result != null) {
      await fetchAll();
      return true;
    }

    return false;
  }

  Future<bool> xoa(int thietBiID) async {
    final ok = await _repo.xoaThietBi(thietBiID);

    if (ok) {
      _list.removeWhere((e) => e.thietBi.thietBiID == thietBiID);
      notifyListeners();
    }

    return ok;
  }

}
