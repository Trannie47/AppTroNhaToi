import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class LichSuMuaThietBiPageViewModel extends ChangeNotifier {
  final ThietBi thietBi;
  final LichSuMuaThietBiProvider _lichSuMuaThietBiProvider;

  List<LichSuMuaThietBi> dsGoc = [];
  List<LichSuMuaThietBi> lichSuMuaThietBi = [];

  bool get isLoading => _lichSuMuaThietBiProvider.isLoading;

  int thangChon = DateTime.now().month;
  int namChon = DateTime.now().year;

  String get thangNamText => "${thangChon.toString().padLeft(2, '0')}/$namChon";

  LichSuMuaThietBiPageViewModel({
    required this.thietBi,
    required LichSuMuaThietBiProvider lichSuMuaThietBiProvider,
  }) : _lichSuMuaThietBiProvider = lichSuMuaThietBiProvider {
    _lichSuMuaThietBiProvider.addListener(_onProviderUpdate);

    Future.microtask(refresh);
  }

  void _onProviderUpdate() {
    dsGoc = List.from(_lichSuMuaThietBiProvider.list);
    locTheoThangNam();
  }

  void chonThangNam(int thang, int nam) {
    thangChon = thang;
    namChon = nam;
    locTheoThangNam();
  }

  void locTheoThangNam() {
    lichSuMuaThietBi = dsGoc.where((e) {
      final ngay = e.ngayMua;

      if (ngay == null) return false;

      return ngay.month == thangChon && ngay.year == namChon;
    }).toList();

    notifyListeners();
  }

  Future<void> refresh() async {
    await _lichSuMuaThietBiProvider.fetchByThietBi(thietBi.thietBiID!);

    dsGoc = List.from(_lichSuMuaThietBiProvider.list);
    locTheoThangNam();
  }

  @override
  void dispose() {
    _lichSuMuaThietBiProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
