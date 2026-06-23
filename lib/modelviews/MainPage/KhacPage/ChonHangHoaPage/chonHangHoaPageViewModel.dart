import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/service/hang_hoa_service.dart';
import 'package:flutter/material.dart';

class ChonHangHoaPageModelView extends ChangeNotifier {
  final HangHoaService _service;
  final TextEditingController txtSearch = TextEditingController();

  List<HangHoa> _dsHienThi = [];
  List<HangHoa> get dsHangHoaHienThi => List.unmodifiable(_dsHienThi);
  bool get isLoading => _service.isLoading;

  ChonHangHoaPageModelView(this._service) {
    _service.addListener(_onServiceUpdate);
    txtSearch.addListener(_onSearchChanged);
    Future.microtask(() => _service.fetchAll());
  }

  void _onServiceUpdate() {
    _applyFilter();
  }

  void _onSearchChanged() {
    _applyFilter();
  }

  void _applyFilter() {
    final keyword = txtSearch.text.trim().toLowerCase();
    if (keyword.isEmpty) {
      _dsHienThi = List.from(_service.list);
    } else {
      _dsHienThi = _service.list.where((e) {
        return (e.tenHangHoa ?? '').toLowerCase().contains(keyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> refresh() => _service.fetchAll();

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    txtSearch.dispose();
    super.dispose();
  }
}
