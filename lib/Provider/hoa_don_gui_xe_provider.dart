import 'package:flutter/foundation.dart';
import '../repositories/hoaDonGuiXe_repository.dart';
import '../models/hoa_don_gui_xe.dart';

class HoaDonGuiXeProvider extends ChangeNotifier {
  final _repository = HoaDonGuiXeRepository();

  List<HoaDonGuiXe> danhSachHoaDon = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadDanhSachHoaDon() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      danhSachHoaDon = await _repository.fetchDanhSachHoaDonGuiXe();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
