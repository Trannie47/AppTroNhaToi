import 'package:flutter/foundation.dart';
import '../../models/nguoi_luu_tru_tam_thoi.dart';
import '../../repositories/nguoiluutrutamthoi_repository.dart';

class NguoiLuuTruTamThoiProvider extends ChangeNotifier {
  final NguoiLuuTruTamThoiRepository _repository =
      NguoiLuuTruTamThoiRepository();

  List<NguoiLuuTruTamThoi> _list = [];
  List<NguoiLuuTruTamThoi> get list => _list;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getDanhSach({int? idnt}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _list = await _repository.getDanhSachLuuTru(idnt: idnt);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiLuuTruTamThoiProvider.fetchDanhSach: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<NguoiLuuTruTamThoi?> createNguoiLuuTru(
    NguoiLuuTruTamThoi newItem,
  ) async {
    try {
      final item = await _repository.createNguoiLuuTru(newItem);
      if (item != null) {
        _list.insert(0, item);
        notifyListeners();
      }
      return item;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiLuuTruTamThoiProvider.taoNguoiLuuTru: $e");
      }
      rethrow;
    }
  }

  Future<NguoiLuuTruTamThoi?> updateLuuTru(
    NguoiLuuTruTamThoi updatedData,
  ) async {
    try {
      final updatedItem = await _repository.updateLuuTru(updatedData);
      if (updatedItem != null) {
        final index = _list.indexWhere((e) => e.idtt == updatedItem.idtt);
        if (index != -1) {
          _list[index] = updatedItem;
        } else {
          _list.insert(0, updatedItem);
        }
        notifyListeners();
      }
      return updatedItem;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiLuuTruTamThoiProvider.capNhatLuuTru: $e");
      }
      rethrow;
    }
  }

  Future<bool> deleteLuuTru(int idtt) async {
    try {
      final success = await _repository.deleteLuuTru(idtt);
      if (success) {
        _list.removeWhere((e) => e.idtt == idtt);
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi NguoiLuuTruTamThoiProvider.xoaLuuTru: $e");
      }
      rethrow;
    }
  }
}
