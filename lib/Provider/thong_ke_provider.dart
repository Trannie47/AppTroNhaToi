import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';
import 'package:AppTroNhaToi/repositories/thongKe_reponsitory.dart';
import 'package:flutter/foundation.dart';

class ThongKeProvider extends ChangeNotifier {
  final ThongKeRepository _thongKeRepository = ThongKeRepository();

  ThongKeDTO? _thongKe;
  ThongKeDTO? get thongKe => _thongKe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get tongDoanhThuThang =>
      _thongKe?.doanhThu.tongDoanhThu.toDouble() ?? 0;

  String get thangHienTai {
    final now = DateTime.now();
    return "${now.month}/${now.year}";
  }

  Future<ThongKeDTO?> getThongKe({int? thang, int? nam}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _thongKe = await _thongKeRepository.getThongKe(thang: thang, nam: nam);

      return _thongKe;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ThongKeProvider: $e");
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
