import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class LichSuSuaChuaPageViewModel extends ChangeNotifier {
  final ThietBi thietBi;
  final LapRap? lapRap;
  final SuaChuaProvider _suaChuaProvider;

  final txtSearch = TextEditingController();

  List<LichSuSuaChuaPageModel> dsGoc = [];
  List<LichSuSuaChuaPageModel> lichSuSuaChua = [];

  bool get isLoading => _suaChuaProvider.isLoading;

  LichSuSuaChuaPageViewModel({
    required this.thietBi,
    this.lapRap,
    required SuaChuaProvider suaChuaProvider,
  }) : _suaChuaProvider = suaChuaProvider {
    _suaChuaProvider.addListener(_onProviderUpdate);

    txtSearch.addListener(timKiem);

    Future.microtask(() async {
      await _fetch();

      dsGoc = List.from(_suaChuaProvider.list);
      lichSuSuaChua = List.from(dsGoc);

      notifyListeners();
    });
  }

  Future<void> _fetch() async {
    if (lapRap?.id != null) {
      await _suaChuaProvider.fetchByThietBiVaLapRap(
        thietBi.thietBiID!,
        lapRap!.id!,
      );
    } else {
      await _suaChuaProvider.fetchByThietBi(thietBi.thietBiID!);
    }
  }

  void _onProviderUpdate() {
    dsGoc = List.from(_suaChuaProvider.list);
    timKiem();
  }

  void timKiem() {
    final keyword = txtSearch.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      lichSuSuaChua = List.from(dsGoc);
    } else {
      lichSuSuaChua = dsGoc.where((e) {
        return (e.suaChua.nguyenNhan ?? '').toLowerCase().contains(keyword);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> reload() async {
    await _fetch();

    dsGoc = List.from(_suaChuaProvider.list);
    lichSuSuaChua = List.from(dsGoc);

    notifyListeners();
  }

  @override
  void dispose() {
    txtSearch.removeListener(timKiem);
    txtSearch.dispose();
    _suaChuaProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
