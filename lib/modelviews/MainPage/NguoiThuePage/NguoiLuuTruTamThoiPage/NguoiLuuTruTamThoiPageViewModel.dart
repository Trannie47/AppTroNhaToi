import 'package:flutter/foundation.dart';
import '../../../../../Provider/nguoi_luu_tru_tam_thoi_provider.dart';
import '../../../../../models/nguoi_luu_tru_tam_thoi.dart';

class LuuTruTamThoiViewModel extends ChangeNotifier {
  final NguoiLuuTruTamThoiProvider _provider;
  final int idnt;

  List<NguoiLuuTruTamThoi> get dsLuuTru => _provider.list;
  bool get isLoading => _provider.isLoading;
  String? get errorMessage => _provider.errorMessage;

  LuuTruTamThoiViewModel(this._provider, this.idnt);

  Future<void> getDanhSach() async {
    await _provider.getDanhSach(idnt: idnt);
    notifyListeners();
  }

  Future<bool> deleteLuuTru(int idtt) async {
    final success = await _provider.deleteLuuTru(idtt);
    notifyListeners();
    return success;
  }
}
