import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

import '../../../Provider/phong_provider.dart';
import '../../../models/item_phong_model.dart';

class PhongPageViewModel extends ChangeNotifier {
  final PhongProvider _service;

  int _currentFilter = -1;
  int get currentFilter => _currentFilter;
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = "";

  bool get isLoading => _service.isLoading;
  List<ItemPhongModel> get listPhong => _service.listPhong;
  List<ItemPhongModel> get listPhongTrong => _service.listPhongTrong;
  List<ItemPhongModel> get listPhongDangThue => _service.listPhongDangThue;
  List<ItemPhongModel> get listPhongDangSua => _service.listPhongDangSua;

  PhongPageViewModel(this._service) {
    _service.addListener(_onProviderUpdate);
    searchController.addListener(_onSearchChanged);
  }
  void _onSearchChanged() {
    _searchQuery = searchController.text.toLowerCase().trim();
    notifyListeners();
  }

  List<ItemPhongModel> get listPhongHienThi {
    List<ItemPhongModel> baseList;
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

  bool get dangTimKiem => _searchQuery.isNotEmpty;

  // Số lượng phòng theo từng loại phòng, tính trên đúng danh sách đang hiển thị
  Map<String, int> get soLuongTheoLoaiPhong {
    final Map<String, int> ketQua = {};
    for (final phong in listPhongHienThi) {
      final ten = phong.loaiPhong.tenLoaiPhong;
      ketQua[ten] = (ketQua[ten] ?? 0) + 1;
    }
    return ketQua;
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
