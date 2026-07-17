import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/models/dien_nuoc.dart';

import '../repositories/diennuoc_repository.dart';

class DienNuocProvider extends ChangeNotifier {
  final DienNuocRepository _repository= DienNuocRepository();


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _mode;
  String? get mode => _mode;

  bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;

  DienNuoc? _currentDienNuoc;
  DienNuoc? get currentDienNuoc => _currentDienNuoc;

  Future<void> getInitData(int phongId, String thangNam) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getInitData(phongId, thangNam);
      print("Lấy được là $result");
      _mode = result.mode;
      _isFirstTime = result.isFirstTime;
      _currentDienNuoc = result.dienNuoc;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
