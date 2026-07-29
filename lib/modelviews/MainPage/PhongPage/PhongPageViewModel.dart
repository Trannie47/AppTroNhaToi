import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

import '../../../Provider/phong_provider.dart';
import '../../../models/item_phong.dart';

class PhongPageViewModel extends ChangeNotifier {
  final PhongProvider _service;

  int _currentFilter = -1;
  int get currentFilter => _currentFilter;
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = "";

  bool get isLoading => _service.isLoading;
  List<ItemPhong> get listPhong => _service.listPhong;
  List<ItemPhong> get listPhongTrong => _service.listPhongTrong;
  List<ItemPhong> get listPhongDangThue => _service.listPhongDangThue;
  List<ItemPhong> get listPhongDangSua => _service.listPhongDangSua;

  PhongPageViewModel(this._service) {
    _service.addListener(_onProviderUpdate);
    searchController.addListener(_onSearchChanged);
  }
  void _onSearchChanged() {
    _searchQuery = searchController.text.toLowerCase().trim();
    notifyListeners();
  }
  List<ItemPhong> get listPhongHienThi {
    List<ItemPhong> baseList;
    switch (_currentFilter) {
      case 0:
        baseList = listPhongTrong;
        break;
      case 1:
        baseList = listPhongDangThue;
        break;
      case 2:
        baseList = listPhongDangSua;
        break;
      default:
        baseList = listPhong;
    }
    //Nếu ô tìm kiếm rỗng thì trả về luôn danh sách theo tab đó
    if (_searchQuery.isEmpty) {
      return baseList;
    }

    //Lọc danh sách theo từ khóa (Tìm tên phòng hoặc loại phòng)
    return baseList.where((phong) {
      final ten = (phong.tenPhong).toLowerCase();
      final loai = (phong.loaiPhong.tenLoaiPhong).toLowerCase();
      return ten.contains(_searchQuery) || loai.contains(_searchQuery);
    }).toList();
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
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
