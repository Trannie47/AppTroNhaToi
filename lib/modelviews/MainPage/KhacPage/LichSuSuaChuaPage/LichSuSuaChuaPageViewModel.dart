import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class LichSuSuaChuaPageViewModel extends ChangeNotifier {
  final ThietBi thietBi;
  final SuaChuaProvider _suaChuaProvider;

  final txtSearch = TextEditingController();

  List<LichSuSuaChuaPageModel> dsGoc = [];
  List<LichSuSuaChuaPageModel> lichSuSuaChua = [];

  bool get isLoading => _suaChuaProvider.isLoading;

  LichSuSuaChuaPageViewModel({
    required this.thietBi,
    required SuaChuaProvider suaChuaProvider,
  }) : _suaChuaProvider = suaChuaProvider {
    _suaChuaProvider.addListener(_onProviderUpdate);

    txtSearch.addListener(timKiem);

    Future.microtask(() async {
      await _suaChuaProvider.fetchByThietBi(thietBi.thietBiID!);

      dsGoc = List.from(_suaChuaProvider.list);
      lichSuSuaChua = List.from(dsGoc);

      notifyListeners();
    });
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

  @override
  void dispose() {
    txtSearch.removeListener(timKiem);
    txtSearch.dispose();
    _suaChuaProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
