import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

import '../../../Provider/nguoi_thue_provider.dart';

class NguoiThuePageViewModel extends ChangeNotifier {
  final NguoiThueProvider _service;
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = "";
  bool get isLoading => _service.isLoading;

  List<NguoiThue> get listNguoiThue {
    final allList = _service.list;
    if (_searchQuery.isEmpty) {
      return allList;
    }
    final query = _searchQuery.toLowerCase().trim();
    return allList.where((nt) {
      final ten = (nt.hoTen ?? "").toLowerCase();
      final sdt = (nt.sdt ?? "").toLowerCase();
      final cccd = (nt.cccd ?? "").toLowerCase();

      return ten.contains(query) || sdt.contains(query) || cccd.contains(query);
    }).toList();
  }
  NguoiThuePageViewModel(this._service){
    _service.addListener(_onProviderUpdate);
    searchController.addListener(_onSearchChanged);
  }
  void _onSearchChanged() {
    _searchQuery = searchController.text;
    notifyListeners();
  }

  Future<void> refresh() => _service.fetchAll();

  @override
  void dispose() {
    _service.removeListener(_onProviderUpdate);
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
  void _onProviderUpdate() {
    notifyListeners();
  }
}
