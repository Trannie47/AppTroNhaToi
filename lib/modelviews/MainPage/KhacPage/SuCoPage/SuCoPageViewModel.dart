import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:flutter/material.dart';

class SuCoPageViewModel extends ChangeNotifier {
  final SuCoProvider _service;

  final TextEditingController txtSearch = TextEditingController();

  List<PhieuSuCo> _dsHienThi = [];

  List<PhieuSuCo> get dsHienThi => List.unmodifiable(_dsHienThi);

  bool get isLoading => _service.isLoading;

  SuCoPageViewModel(this._service) {
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
        return (e.tenSuCo ?? "").toLowerCase().contains(keyword) ||
            (e.phong?.tenPhong ?? "").toLowerCase().contains(keyword);
      }).toList();
    }

    _dsHienThi.sort((a, b) {
      return (b.ngayBatDau ?? DateTime(1900)).compareTo(
        a.ngayBatDau ?? DateTime(1900),
      );
    });

    notifyListeners();
  }

  List<PhieuSuCo> get dsSuCo => List.unmodifiable(_service.list);

  int get soDangXuLy =>
      _service.list.where((e) => e.trangThaiThongBao == 1).length;

  int get soHoanThanh =>
      _service.list.where((e) => e.trangThaiThongBao == 2).length;

  Future<void> refresh() => _service.fetchAll();

  Future<bool> xoa(int id) async {
    final ok = await _service.xoa(id);

    if (ok) {
      await _service.fetchAll();
    }

    return ok;
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);

    txtSearch.dispose();

    super.dispose();
  }
}