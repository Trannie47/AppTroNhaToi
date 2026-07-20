import 'package:AppTroNhaToi/Provider/lich_su_Them_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class LichSuMuaThietBiPageViewModel extends ChangeNotifier {
  final ThietBi thietBi;
  final LichSuMuaThietBiProvider _lichSuMuaThietBiProvider;

  final txtSearch = TextEditingController();

  List<LichSuMuaThietBi> dsGoc = [];
  List<LichSuMuaThietBi> lichSuMuaThietBi = [];

  bool get isLoading => _lichSuMuaThietBiProvider.isLoading;

  LichSuMuaThietBiPageViewModel({
    required this.thietBi,
    required LichSuMuaThietBiProvider lichSuMuaThietBiProvider,
  }) : _lichSuMuaThietBiProvider = lichSuMuaThietBiProvider {
    _lichSuMuaThietBiProvider.addListener(_onProviderUpdate);

    txtSearch.addListener(timKiem);

    Future.microtask(refresh);
  }

  void _onProviderUpdate() {
    dsGoc = List.from(_lichSuMuaThietBiProvider.list);
    timKiem();
  }

  void timKiem() {
    final keyword = txtSearch.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      lichSuMuaThietBi = List.from(dsGoc);
    } else {
      lichSuMuaThietBi = dsGoc.where((e) {
        return (e.ghiChu ?? '').toLowerCase().contains(keyword);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    await _lichSuMuaThietBiProvider.fetchByThietBi(
      thietBi.thietBiID!,
    );

    dsGoc = List.from(_lichSuMuaThietBiProvider.list);
    lichSuMuaThietBi = List.from(dsGoc);

    notifyListeners();
  }

  @override
  void dispose() {
    txtSearch.removeListener(timKiem);
    txtSearch.dispose();
    _lichSuMuaThietBiProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
