import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';
import 'package:AppTroNhaToi/repositories/thongKe_reponsitory.dart';
import 'package:flutter/foundation.dart';

class ThongKeProvider extends ChangeNotifier {
  final ThongKeRepository _thongKeRepository = ThongKeRepository();

  ThongKeDTO? _thongKe;
  ThongKeDTO? get thongKe => _thongKe;

  Future<ThongKeDTO?> getThongKe({int? thang, int? nam}) async {
    try {
      _thongKe = await _thongKeRepository.getThongKe(thang: thang, nam: nam);
      notifyListeners();
      return _thongKe;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongKeProvider: $e");
      }
      rethrow;
    }
  }
}
