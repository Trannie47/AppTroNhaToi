import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/repositories/PhieuThuHoaDonTapHoa_reponsitory.dart';
import 'package:flutter/foundation.dart';

class PhieuThuHdThProvider extends ChangeNotifier {
  final PhieuThuHdThRepository _repo = PhieuThuHdThRepository();

  List<PhieuThuHdTh> _list = [];
  List<PhieuThuHdTh> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchByMaHoaDon(String maHoaDon) async {
    if (_isLoading) return;

    _isLoading = true;
    _list = [];
    notifyListeners();

    try {
      _list = await _repo.getPhieuThuTheoMaHoaDon(maHoaDon);
    } catch (e) {
      _list = [];
      if (kDebugMode) {
        print("Lỗi PhieuThuHdThProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PhieuThuHdTh?> them(PhieuThuHdTh phieuThu) async {
    final result = await _repo.themPhieuThuHdTh(phieuThu);

    if (result != null) {
      await fetchByMaHoaDon(result.maHoaDon!);
    }

    return result;
  }

  Future<bool> capNhat(PhieuThuHdTh phieuThu) async {
    final result = await _repo.capNhatPhieuThuHdTh(phieuThu);

    if (result != null) {
      await fetchByMaHoaDon(result.maHoaDon!);
      return true;
    }

    return false;
  }

  Future<bool> xoa(int maPhieuThu, String maHoaDon) async {
    final ok = await _repo.xoaPhieuThuHdTh(maPhieuThu);

    if (ok) {
      await fetchByMaHoaDon(maHoaDon);
    }

    return ok;
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
