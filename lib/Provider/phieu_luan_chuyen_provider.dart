// import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
// import 'package:AppTroNhaToi/repositories/PhieuLuanChuyen_reponsitory.dart';
// import 'package:flutter/foundation.dart';
//
// class PhieuLuanChuyenProvider extends ChangeNotifier {
//   final PhieuLuanChuyenRepository _repo = PhieuLuanChuyenRepository();
//
//   List<PhieuLuanChuyen> _list = [];
//   List<PhieuLuanChuyen> get list => List.unmodifiable(_list);
//
//   List<PhieuLuanChuyen> _listByHopDong = [];
//   List<PhieuLuanChuyen> get listByHopDong =>
//       List.unmodifiable(_listByHopDong);
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchAll() async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     _list = [];
//     notifyListeners();
//
//     try {
//       _list = await _repo.getAll();
//     } catch (e) {
//       _list = [];
//       if (kDebugMode) {
//         print("Lỗi ChiTietLuanChuyenProvider: $e");
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> fetchByHopDong(String hopDongId) async {
//     if (_isLoading) return;
//
//     _isLoading = true;
//     _listByHopDong = [];
//     notifyListeners();
//
//     try {
//       _listByHopDong = await _repo.getByHopDong(hopDongId);
//     } catch (e) {
//       _listByHopDong = [];
//       if (kDebugMode) {
//         print("Lỗi PhieuLuanChuyenProvider: $e");
//       }
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<PhieuLuanChuyen?> them(PhieuLuanChuyen item) async {
//     final result = await _repo.them(item);
//
//     if (result != null) {
//       await fetchAll();
//     }
//
//     return result;
//   }
//
//   Future<bool> capNhat(PhieuLuanChuyen item) async {
//     final ok = await _repo.capNhat(item);
//
//     if (ok) {
//       await fetchAll();
//     }
//
//     return ok;
//   }
//
//   Future<bool> xoa(int id) async {
//     final ok = await _repo.xoa(id);
//
//     if (ok) {
//       await fetchAll();
//     }
//
//     return ok;
//   }
//
//   void clear() {
//     _list.clear();
//     _listByHopDong.clear();
//     notifyListeners();
//   }
// }
