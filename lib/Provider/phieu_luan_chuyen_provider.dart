import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
import 'package:AppTroNhaToi/repositories/PhieuLuanChuyen_reponsitory.dart';
import 'package:flutter/foundation.dart';

class PhieuLuanChuyenProvider extends ChangeNotifier {
  final PhieuLuanChuyenRepository _repo = PhieuLuanChuyenRepository();

  List<PhieuLuanChuyen> _list = [];
  List<PhieuLuanChuyen> get list => List.unmodifiable(_list);

  List<HopDongLuanChuyenVM> _listBySuCo = [];
  List<HopDongLuanChuyenVM> get listBySuCo => List.unmodifiable(_listBySuCo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    if (_isLoading) return;

    _isLoading = true;
    _list = [];
    notifyListeners();

    try {
      _list = await _repo.getAll();
    } catch (e) {
      _list = [];
      if (kDebugMode) {
        print("Lỗi ChiTietLuanChuyenProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBySuCo(int suCoId) async {
    if (_isLoading) return;

    _isLoading = true;
    _listBySuCo = [];
    notifyListeners();

    try {
      _listBySuCo = await _repo.getBySuCo(suCoId);
    } catch (e) {
      _listBySuCo = [];
      if (kDebugMode) {
        print("Lỗi ChiTietLuanChuyenProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PhieuLuanChuyen?> them(PhieuLuanChuyen chiTiet) async {
    // final result = await _repo.themChiTietLuanChuyen(chiTiet);

    // if (result != null) {
    //   await fetchAll();
    //   await fetchBySuCo(result.suCoId!);
    // }

    // return result;
  }

  Future<bool> capNhat(PhieuLuanChuyen chiTiet) async {
    // final result = await _repo.capNhatChiTietLuanChuyen(chiTiet);

    // if (result != null) {
    //   await fetchAll();
    //   await fetchBySuCo(result.suCoId!);
    //   return true;
    // }

    return false;
  }

  Future<bool> xoa(int id, int suCoId) async {
    final ok = await _repo.xoaChiTietLuanChuyen(id);

    if (ok) {
      await fetchAll();
      await fetchBySuCo(suCoId);
    }

    return ok;
  }

  void clear() {
    _list.clear();
    _listBySuCo.clear();
    notifyListeners();
  }
}
