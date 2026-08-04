import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:AppTroNhaToi/repositories/SuCoRepository.dart';
import 'package:flutter/foundation.dart';

class SuCoProvider extends ChangeNotifier {
  final SuCoRepository _repo = SuCoRepository();

  List<PhieuSuCo> _list = [];

  List<PhieuSuCo> get list => List.unmodifiable(_list);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getListSuCo();

      // ID lớn nhất lên đầu
      _list.sort(
            (a, b) => (b.suCoId ?? 0).compareTo(a.suCoId ?? 0),
      );
    } catch (e) {
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PhieuSuCo?> them(PhieuSuCo suCo) async {
    final result = await _repo.themSuCo(suCo);

    if (result != null) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> capNhat(PhieuSuCo suCo) async {
    final result = await _repo.capNhatSuCo(suCo);

    if (result != null) {
      await fetchAll();
      return true;
    }

    return false;
  }

  Future<bool> xoa(int suCoId) async {
    final ok = await _repo.xoaSuCo(suCoId);

    if (ok) {
      _list.removeWhere((e) => e.suCoId == suCoId);
      notifyListeners();
    }

    return ok;
  }
}