import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/nguoi_o_ghep.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/ItemHopDong.dart';
import 'package:flutter/material.dart';

class ChiTietPhieuLuanChuyenViewModel extends ChangeNotifier {
  final HopDongProvider hopDongProvider;
  final PhongProvider phongProvider;
  final PhieuLuanChuyen item;

  ChiTietPhieuLuanChuyenViewModel({
    required this.hopDongProvider,
    required this.phongProvider,
    required this.item,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _tenDaiDien;
  String? get tenDaiDien => _tenDaiDien;

  List<NguoiOGhep> _dsNguoiOGhep = [];
  List<NguoiOGhep> get dsNguoiOGhep => _dsNguoiOGhep;

  ItemPhong? _phongCu;
  ItemPhong? get phongCu => _phongCu;

  int get tongSoNguoi => (_tenDaiDien != null ? 1 : 0) + _dsNguoiOGhep.length;

  Future<void> load() async {
    final phongId = item.hopDong?.phongID;
    if (phongId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        hopDongProvider.getHopDongByPhong(phongId),
        phongProvider.getInforPhong(phongId),
      ]);

      final ds = results[0] as List<ItemHopDong>;
      _phongCu = results[1] as ItemPhong;

      final hopDong = ds
          .where((hd) => hd.hopDongId == item.hopDongId)
          .cast<ItemHopDong?>()
          .firstOrNull;

      _tenDaiDien = hopDong?.tenDaiDien;
      _dsNguoiOGhep = hopDong?.dsNguoiOGhep ?? [];
    } catch (_) {
      _tenDaiDien = null;
      _dsNguoiOGhep = [];
      _phongCu = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
