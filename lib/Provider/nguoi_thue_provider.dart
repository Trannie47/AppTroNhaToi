import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/repositories/nguoithue_repository.dart';
import 'package:flutter/foundation.dart';

class NguoiThueProvider extends ChangeNotifier {
  final NguoithueRepository _repo = NguoithueRepository();

  List<NguoiThue> _list = [];
  List<NguoiThue> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getListNguoiThue();

      // Người thuê mới nhất lên đầu
      _list.sort((a, b) => (b.idnt ?? 0).compareTo(a.idnt ?? 0));
    } catch (e) {
      _list = [];
      if (kDebugMode) {
        print("Lỗi NguoiThueProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> them(NguoiThue nguoiThue) async {
    final result = await _repo.themNguoiThue(nguoiThue);

    if (result) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> xoa(int idnt) async {
    final result = await _repo.xoaNguoiThue(idnt);

    if (result) {
      _list.removeWhere((e) => e.idnt == idnt);
      notifyListeners();
    }

    return result;
  }

  Future<List<NguoiThue>> getListNguoiThueFromIdPhong(int idPhong) async {
    return await _repo.getListNguoiThueFromIdPhong(idPhong);
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
