import 'package:flutter/foundation.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';

class GhiDienNuocHomePageViewModel extends ChangeNotifier {
  final PhongProvider _phongProvider;

  bool get isLoading => _phongProvider.isLoading;
  List<ItemPhong> get listPhong => _phongProvider.listPhong;

  GhiDienNuocHomePageViewModel(this._phongProvider) {
    _phongProvider.addListener(_onProviderUpdate);
  }

  Future<void> refresh() async {
    await _phongProvider.getListPhong();
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _phongProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}