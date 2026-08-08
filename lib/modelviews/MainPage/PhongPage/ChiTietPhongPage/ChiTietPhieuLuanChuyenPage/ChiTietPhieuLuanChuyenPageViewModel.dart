import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/models/nguoi_o_ghep.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/ItemHopDong.dart';
import 'package:flutter/material.dart';

class ChiTietPhieuLuanChuyenViewModel extends ChangeNotifier {
  final HopDongProvider hopDongProvider;
  final PhieuLuanChuyen item;

  ChiTietPhieuLuanChuyenViewModel({
    required this.hopDongProvider,
    required this.item,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _tenDaiDien;
  String? get tenDaiDien => _tenDaiDien;

  List<NguoiOGhep> _dsNguoiOGhep = [];
  List<NguoiOGhep> get dsNguoiOGhep => _dsNguoiOGhep;

  int get tongSoNguoi => (_tenDaiDien != null ? 1 : 0) + _dsNguoiOGhep.length;

  Future<void> load() async {
    final phongId = item.hopDong?.phongID;
    if (phongId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final ds = await hopDongProvider.getHopDongByPhong(phongId);
      final hopDong = ds
          .where((hd) => hd.hopDongId == item.hopDongId)
          .cast<ItemHopDong?>()
          .firstOrNull;

      _tenDaiDien = hopDong?.tenDaiDien;
      _dsNguoiOGhep = hopDong?.dsNguoiOGhep ?? [];
    } catch (_) {
      _tenDaiDien = null;
      _dsNguoiOGhep = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
