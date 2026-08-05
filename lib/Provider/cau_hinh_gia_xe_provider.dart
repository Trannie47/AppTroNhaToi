import 'package:flutter/foundation.dart';

import '../models/cau_hinh_gia_xe.dart';
import '../repositories/cauhinhgiaxe_repository.dart';

class CauHinhGiaXeProvider extends ChangeNotifier {
  final CauHinhGiaXeRepository _repository = CauHinhGiaXeRepository();

  List<CauHinhGiaXe> _list = [];
  List<CauHinhGiaXe> get list => List.unmodifiable(_list);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<List<CauHinhGiaXe>> getAll() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _list = await _repository.getAll();
      return _list;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<CauHinhGiaXe?> getByLoaiXe(int loaiXe) async {
    try {
      return await _repository.getByLoaiXe(loaiXe);
    } catch (e) {
      if (kDebugMode) print("Lỗi lấy giá mặc định theo loại xe: $e");
      return null;
    }
  }

  Future<CauHinhGiaXe?> update({
    required int loaiXe,
    required double giaMacDinh,
    String? tenLoaiXe,
  }) async {
    try {
      final result = await _repository.update(
        loaiXe: loaiXe,
        giaMacDinh: giaMacDinh,
        tenLoaiXe: tenLoaiXe,
      );

      final index = _list.indexWhere((e) => e.loaiXe == loaiXe);
      if (index != -1) {
        final newList = List<CauHinhGiaXe>.from(_list);
        newList[index] = result;
        _list = newList;
      } else {
        _list = [..._list, result];
      }
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}