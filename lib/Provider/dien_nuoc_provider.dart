import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/models/dien_nuoc.dart';

import '../repositories/diennuoc_repository.dart';

class DienNuocProvider extends ChangeNotifier {
  final DienNuocRepository _repository = DienNuocRepository();

  String? _mode;
  String? get mode => _mode;

  bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;

  DienNuoc? _currentDienNuoc;
  DienNuoc? get currentDienNuoc => _currentDienNuoc;

  Future<void> getInitData(int phongId, String thangNam) async {
    final result = await _repository.getInitData(phongId, thangNam);
    _mode = result.mode;
    _isFirstTime = result.isFirstTime;
    _currentDienNuoc = result.dienNuoc;
    notifyListeners();
  }

  Future<void> createDienNuoc(
    DienNuoc dienNuoc, {
    String? anhDienCuPath,
    String? anhDienMoiPath,
    String? anhNuocCuPath,
    String? anhNuocMoiPath,
  }) async {
    final result = await _repository.createDienNuoc(
      dienNuoc,
      anhDienCuPath: anhDienCuPath,
      anhDienMoiPath: anhDienMoiPath,
      anhNuocCuPath: anhNuocCuPath,
      anhNuocMoiPath: anhNuocMoiPath,
    );
    _currentDienNuoc = result;
    notifyListeners();
  }

  Future<void> updateDienNuoc(
    DienNuoc dienNuoc, {
    String? anhDienCuPath,
    String? anhDienMoiPath,
    String? anhNuocCuPath,
    String? anhNuocMoiPath,
  }) async {
    final result = await _repository.updateDienNuoc(
      dienNuoc,
      anhDienCuPath: anhDienCuPath,
      anhDienMoiPath: anhDienMoiPath,
      anhNuocCuPath: anhNuocCuPath,
      anhNuocMoiPath: anhNuocMoiPath,
    );
    _currentDienNuoc = result;
    notifyListeners();
  }
}
