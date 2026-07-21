import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/repositories/phuongtien_repository.dart';
import 'package:flutter/foundation.dart';

class PhuongTienProvider extends ChangeNotifier {
  final PhuongTienRepository _repo = PhuongTienRepository();

  List<PhuongTien> _list = [];
  List<PhuongTien> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchByNguoiThue(int idnt) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _list = await _repo.getDsPhuongTienByNguoiThue(idnt);
    } catch (e) {
      _list = [];
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) {
        print("Lỗi PhuongTienProvider: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> createPhuongTien(PhuongTien xe) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final xeMoi = await _repo.createPhuongTien(xe);
      // Chèn xe mới vừa tạo lên đầu danh sách local
      _list = [xeMoi, ..._list];
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) print("Lỗi createPhuongTien Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> updatePhuongTien(num id, PhuongTien xe) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final xeDaSua = await _repo.updatePhuongTien(id, xe);

      // Tìm vị trí xe cũ trong mảng local và đè xe mới sửa lên
      final index = _list.indexWhere((e) => e.ID == id);
      if (index != -1) {
        final newList = List<PhuongTien>.from(_list);
        newList[index] = xeDaSua;
        _list = newList;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) print("Lỗi updatePhuongTien Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePhuongTien(PhuongTien xe) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final deletedXe = await _repo.deletePhuongTien(xe.ID);

      // Loại bỏ khỏi danh sách local dựa trên ID của xe trả về từ Server
      _list = _list.where((e) => e.ID != deletedXe.ID).toList();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (kDebugMode) print("Lỗi deletePhuongTien Provider: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void clear() {
    _list = [];
    _errorMessage = null;
    notifyListeners();
  }
}