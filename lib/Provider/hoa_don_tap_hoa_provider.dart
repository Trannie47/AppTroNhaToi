import 'package:AppTroNhaToi/models/DTO/HoaDonTapHoaDTO.dart';
import 'package:AppTroNhaToi/repositories/hoaDonTapHoa_reponsitory.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/foundation.dart';

class HoaDonTapHoaProvider extends ChangeNotifier {
  final HoaDonTapHoaRepository _repo = HoaDonTapHoaRepository();

  List<HoaDonTapHoaModel> _list = [];
  List<HoaDonTapHoaModel> get list => List.unmodifiable(_list);

  double get tongCongNo {
    return _list.fold<double>(0, (sum, item) {
      final conThieu = (item.hoaDon.tongTien ?? 0) - item.daThu;
      return sum + (conThieu > 0 ? conThieu : 0);
    });
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _list = await _repo.getListHoaDonTapHoa();

      _list.sort(
        (a, b) => (b.hoaDon.maHoaDon ?? '').compareTo(a.hoaDon.maHoaDon ?? ''),
      );
      print(_list);
    } catch (e) {
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<HoaDonTapHoaDTO?> them(HoaDonTapHoaDTO dto) async {
    final result = await _repo.themHoaDonTapHoa(dto);

    if (result != null) {
      await fetchAll();
    }

    return result;
  }

  Future<bool> capNhat(HoaDonTapHoaDTO dto) async {
    final ok = await _repo.capNhatHoaDonTapHoa(dto);

    if (ok != null) {
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

  /// Công nợ của một người thuê cụ thể (theo idnt)
  double congNoTheoNguoiThue(int idnt) {
    return _list.where((item) => item.hoaDon.idnt == idnt).fold<double>(0, (
      sum,
      item,
    ) {
      final conThieu = (item.hoaDon.tongTien ?? 0) - item.daThu;
      return sum + (conThieu > 0 ? conThieu : 0);
    });
  }

  /// Danh sách công nợ nhóm theo từng người thuê (idnt -> tổng còn thiếu)
  Map<int, double> get congNoTheoTungNguoiThue {
    final Map<int, double> result = {};

    for (final item in _list) {
      final idnt = item.hoaDon.idnt;
      if (idnt == null) continue;

      final conThieu = (item.hoaDon.tongTien ?? 0) - item.daThu;
      if (conThieu <= 0) continue;

      result[idnt] = (result[idnt] ?? 0) + conThieu;
    }

    return result;
  }
}
