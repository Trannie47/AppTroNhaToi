import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/repositories/PhieuLuanChuyen_reponsitory.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ItemNguoiLuanChuyenModel.dart';
import 'package:flutter/foundation.dart';

class PhieuLuanChuyenProvider extends ChangeNotifier {
  final PhieuLuanChuyenRepository _repo = PhieuLuanChuyenRepository();

  List<PhieuLuanChuyen> _list = [];
  List<PhieuLuanChuyen> get list => List.unmodifiable(_list);

  List<PhieuLuanChuyen> _listByPhongHopDong = [];
  List<PhieuLuanChuyen> get listByPhongHopDong =>
      List.unmodifiable(_listByPhongHopDong);

  List<ItemNguoiLuanChuyenModel> _listNguoiLuanChuyenPhongMoi = [];
  List<ItemNguoiLuanChuyenModel> get listNguoiLuanChuyenPhongMoi =>
      List.unmodifiable(_listNguoiLuanChuyenPhongMoi);

  // Ghi nhớ phòng đang được xem, để refresh đúng list sau khi thêm/sửa/xóa.
  int? _phongIdDangXemHopDong;
  int? _phongIdDangXemPhongMoi;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingPhongMoi = false;
  bool get isLoadingPhongMoi => _isLoadingPhongMoi;

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

  /// Lấy danh sách phiếu luân chuyển theo phòng cũ (phòng gắn trên hợp đồng).
  Future<void> find(int phongId) async {
    if (_isLoading) return;

    _phongIdDangXemHopDong = phongId;
    _isLoading = true;
    _listByPhongHopDong = [];
    notifyListeners();

    try {
      _listByPhongHopDong = await _repo.getLuanChuyenTheoPhong(phongId);
    } catch (e) {
      _listByPhongHopDong = [];
      if (kDebugMode) {
        print("Lỗi PhieuLuanChuyenProvider.find: $e");
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lấy danh sách người đã luân chuyển tới phòng mới.
  Future<void> getLuanChuyenPhongMoi(int phongId) async {
    if (_isLoadingPhongMoi) return;

    _phongIdDangXemPhongMoi = phongId;
    _isLoadingPhongMoi = true;
    _listNguoiLuanChuyenPhongMoi = [];
    notifyListeners();

    try {
      _listNguoiLuanChuyenPhongMoi = await _repo.getLuanChuyenPhongMoi(phongId);
    } catch (e) {
      _listNguoiLuanChuyenPhongMoi = [];
      if (kDebugMode) {
        print("Lỗi PhieuLuanChuyenProvider.getLuanChuyenPhongMoi: $e");
      }
      rethrow;
    } finally {
      _isLoadingPhongMoi = false;
      notifyListeners();
    }
  }

  /// Refresh lại đúng các danh sách đang được xem (nếu có), sau khi thêm/sửa/xóa.
  Future<void> _refreshCacDanhSachDangXem() async {
    await fetchAll();

    if (_phongIdDangXemHopDong != null) {
      try {
        _listByPhongHopDong = await _repo.getLuanChuyenTheoPhong(
          _phongIdDangXemHopDong!,
        );
      } catch (e) {
        if (kDebugMode) {
          print("Lỗi refresh listByPhongHopDong: $e");
        }
      }
    }

    if (_phongIdDangXemPhongMoi != null) {
      try {
        _listNguoiLuanChuyenPhongMoi = await _repo.getLuanChuyenPhongMoi(
          _phongIdDangXemPhongMoi!,
        );
      } catch (e) {
        if (kDebugMode) {
          print("Lỗi refresh listNguoiLuanChuyenPhongMoi: $e");
        }
      }
    }

    notifyListeners();
  }

  Future<PhieuLuanChuyen?> them(PhieuLuanChuyen item) async {
    final result = await _repo.them(item);

    if (result != null) {
      await _refreshCacDanhSachDangXem();
    }

    return result;
  }

  Future<bool> capNhat(PhieuLuanChuyen item) async {
    final ok = await _repo.capNhat(item);

    if (ok == true) {
      await _refreshCacDanhSachDangXem();
      return true;
    }

    return false;
  }

  Future<bool> xoa(int id) async {
    final ok = await _repo.xoa(id);

    if (ok) {
      await _refreshCacDanhSachDangXem();
    }

    return ok;
  }

  void clear() {
    _list.clear();
    _listByPhongHopDong.clear();
    _listNguoiLuanChuyenPhongMoi.clear();
    _phongIdDangXemHopDong = null;
    _phongIdDangXemPhongMoi = null;
    notifyListeners();
  }
}
