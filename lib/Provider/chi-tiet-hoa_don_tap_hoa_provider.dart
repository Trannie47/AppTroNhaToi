import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/repositories/ChiTietHoaDonTapHoa_reponsitory.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';
import 'package:flutter/foundation.dart';

class ChiTietTapHoaProvider extends ChangeNotifier {
  final ChiTietTapHoaRepository _repo = ChiTietTapHoaRepository();

  List<chiTietHoaDonTapHoaPageModel> _list = [];
  List<chiTietHoaDonTapHoaPageModel> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchByMaHoaDon(String maHoaDon) async {
    if (_isLoading) return;

    _isLoading = true;
    _list = [];
    notifyListeners();

    try {
      _list = await _repo.getChiTietTheoMaHoaDon(maHoaDon);
    } catch (e) {
      _list = [];
      if (kDebugMode) print("Lỗi ChiTietTapHoaProvider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ChiTietTapHoa?> them(ChiTietTapHoa chiTiet) async {
    final result = await _repo.themChiTietTapHoa(chiTiet);

    if (result != null) {
      await fetchByMaHoaDon(result.maHoaDon!);
    }

    return result;
  }

  Future<bool> capNhat(ChiTietTapHoa chiTiet) async {
    final result = await _repo.capNhatChiTietTapHoa(chiTiet);

    if (result != null) {
      await fetchByMaHoaDon(result.maHoaDon!);
      return true;
    }

    return false;
  }

  Future<bool> xoa(int maChiTietHoaDon, String maHoaDon) async {
    final ok = await _repo.xoaChiTietTapHoa(maChiTietHoaDon);

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
