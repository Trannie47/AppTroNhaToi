import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/Provider/phuong_tien_provider.dart';
import 'package:flutter/cupertino.dart';

class PhuongTienNguoiThuePageViewModel extends ChangeNotifier {
  final PhuongTienProvider _provider;
  final NguoiThue nguoiThue;

  PhuongTienNguoiThuePageViewModel({
    required this.nguoiThue,
    required PhuongTienProvider provider,
  }) : _provider = provider {
    _provider.addListener(_onProviderUpdate);
  }

  List<PhuongTien> get dsPhuongTien => _provider.list;
  bool get isLoading => _provider.isLoading;
  String? get errorMessage => _provider.errorMessage;

  List<PhuongTien> get xeMay => dsPhuongTien.where((e) => e.loaiXe == 0).toList();
  List<PhuongTien> get oTo => dsPhuongTien.where((e) => e.loaiXe == 1).toList();
  List<PhuongTien> get xeDap => dsPhuongTien.where((e) => e.loaiXe == 2).toList();

  Future<void> fetchDsPhuongTien() async {
    if (nguoiThue.idnt != null) {
      await _provider.fetchByNguoiThue(nguoiThue.idnt!);
    }
  }
  Future<bool> deletePhuongTien(PhuongTien xe) async {
    return await _provider.deletePhuongTien(xe);
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}