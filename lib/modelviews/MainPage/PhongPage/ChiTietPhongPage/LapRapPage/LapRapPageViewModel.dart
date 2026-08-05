import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:flutter/material.dart';

class LapRapPageViewModel extends ChangeNotifier {
  final int phongId;
  final int thietBiId;

  final LapRapProvider _provider;

  List<LapRapPageModel> get dsLapRap => _provider.listLapRapPage;

  bool get isLoading => false;

  LapRapPageViewModel({
    required this.phongId,
    required this.thietBiId,
    required LapRapProvider provider,
  }) : _provider = provider {
    _provider.addListener(_onProviderUpdate);

    Future.microtask(() async {
      await _provider.findByPhongVaThietBi(
        phongId: phongId,
        thietBiId: thietBiId,
      );
    });
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  Future<bool> themThietBi({
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    final result = await _provider.taoLapRap(
      phongId: phongId,
      thietBiId: thietBiId,
      ghiChu: ghiChu,
      ngayLap: ngayLap,
    );

    return result != null;
  }

  // sửa sau
  Future<bool> capNhatThietBi({
    required LapRap item,
    required String ghiChu,
    required DateTime ngayLap,
  }) async {
    final result = await _provider.capNhatLapRap(id: item.id!, ghiChu: ghiChu);

    return result ?? false;
  }

  Future<bool> xoaThietBi(LapRap item) async {
    if (item.id == null) return false;

    return await _provider.xoaLapRap(item.id!);
  }

  Future<void> refresh() async {
    try {
      await _provider.findByPhongVaThietBi(
        phongId: phongId,
        thietBiId: thietBiId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
