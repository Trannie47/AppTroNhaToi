// services/hang_hoa_service.dart
import 'package:AppTroNhaToi/repositories/hanghoa_reponsitory.dart';
import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';

class HangHoaService extends ChangeNotifier {
  final HangHoaRepository _repo = HangHoaRepository();

  List<HangHoa> _list = [];
  List<HangHoa> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _list = await _repo.getListHangHoa();
    } catch (e) {
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> them(HangHoa hh) async {
    final ok = await _repo.themHangHoa(hh);
    if (ok != null) await fetchAll();
    return false;
  }

  Future<bool> capNhat(HangHoa hh) async {
    final ok = await _repo.capNhatHangHoa(hh);
    if (ok != null) await fetchAll();
    return false;
  }

  Future<bool> xoa(int ma) async {
    final ok = await _repo.xoaHangHoa(ma);
    if (ok) {
      _list.removeWhere((e) => e.maHangHoa == ma);
      notifyListeners();
    }
    return ok;
  }
}
