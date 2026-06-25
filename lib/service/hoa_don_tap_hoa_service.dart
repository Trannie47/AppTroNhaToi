import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/repositories/hoaDonTapHoa_reponsitory.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/foundation.dart';

class HoaDonTapHoaService extends ChangeNotifier {
  final HoaDonTapHoaRepository _repo = HoaDonTapHoaRepository();

  List<HoaDonTapHoaModel> _list = [];
  List<HoaDonTapHoaModel> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getListHoaDonTapHoa();

      // Mã hóa đơn mới nhất lên đầu
      _list.sort(
        (a, b) => (b.hoaDon.maHoaDon ?? '').compareTo(b.hoaDon.maHoaDon ?? ''),
      );
    } catch (e) {
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<HoaDonTapHoa?> them(HoaDonTapHoa hoaDon) async {
    final result = await _repo.themHoaDonTapHoa(hoaDon);

    if (result != null) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> capNhat(HoaDonTapHoa hoaDon) async {
    final result = await _repo.capNhatHoaDonTapHoa(hoaDon);

    if (result != null) {
      await fetchAll();
      return true;
    }

    return false;
  }

  Future<bool> xoa(String maHoaDon) async {
    final ok = await _repo.xoaHoaDonTapHoa(maHoaDon);

    if (ok) {
      _list.removeWhere((e) => e.hoaDon.maHoaDon == maHoaDon);
      notifyListeners();
    }

    return ok;
  }
}
