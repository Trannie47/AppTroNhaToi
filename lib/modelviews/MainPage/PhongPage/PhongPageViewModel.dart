import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

import '../../../Provider/phong_provider.dart';
import '../../../models/item_phong.dart';

class PhongPageViewModel extends ChangeNotifier {
  final PhongProvider _service;

  int _currentFilter = -1;
  int get currentFilter => _currentFilter;

  bool get isLoading => _service.isLoading;
  List<ItemPhong> get listPhong => _service.listPhong;
  List<ItemPhong> get listPhongTrong => _service.listPhongTrong;
  List<ItemPhong> get listPhongDangThue => _service.listPhongDangThue;
  List<ItemPhong> get listPhongDangSua => _service.listPhongDangSua;

  PhongPageViewModel(this._service) {
    _service.addListener(_onProviderUpdate);
  }
  List<ItemPhong> get listPhongHienThi {
    switch (_currentFilter) {
      case 0:
        return listPhongTrong;
      case 1:
        return listPhongDangThue;
      case 2:
        return listPhongDangSua;
      default:
        return listPhong;
    }
  }
  void setFilter(int filterValue) {
    if (_currentFilter == filterValue) return;
    _currentFilter = filterValue;
    notifyListeners();
  }
  Future<void> refresh() => _service.getListPhong();

  void _onProviderUpdate() {
    notifyListeners();
  }
  @override
  void dispose() {
    _service.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
