import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class ChiTietThietBiPageViewModel extends ChangeNotifier {
  ThietBi thietBi;

  final SuaChuaProvider _suaChuaProvider;
  final LichSuMuaThietBiProvider _lichSuMuaThietBiProvider;
  final ThietBiProvider _thietBiProvider;
  final int soLuongLapDat;

  bool hienMenu = false;

  late List<ThietBi> dsThietBi;

  List<LichSuMuaThietBi> get lichSuMuaThietBi =>
      _lichSuMuaThietBiProvider.list.take(3).toList();

  List<LichSuSuaChuaPageModel> get lichSuSuaChua =>
      _suaChuaProvider.list.take(3).toList();

  int get soLuongMua {
    return _lichSuMuaThietBiProvider.list.fold<int>(
      0,
      (tong, item) => tong + (item.soLuong ?? 0),
    );
  }

  int get soLuongConLai => soLuongMua - soLuongLapDat;

  bool get isLoading => _suaChuaProvider.isLoading;

  ChiTietThietBiPageViewModel({
    required this.thietBi,
    required ThietBiProvider thietBiProvider,
    required SuaChuaProvider suaChuaProvider,
    required LichSuMuaThietBiProvider lichSuMuaThietBiProvider,
    required this.soLuongLapDat,
  }) : _thietBiProvider = thietBiProvider,
       _suaChuaProvider = suaChuaProvider,
       _lichSuMuaThietBiProvider = lichSuMuaThietBiProvider {
    _suaChuaProvider.addListener(_onProviderUpdate);
    _lichSuMuaThietBiProvider.addListener(_onProviderUpdate);

    Future.microtask(() async {
      if (thietBi.thietBiID != null) {
        await Future.wait([
          _suaChuaProvider.fetchByThietBi(thietBi.thietBiID!),
          _lichSuMuaThietBiProvider.fetchByThietBi(thietBi.thietBiID!),
        ]);
      }
    });
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  Future<void> reloadLichSuSuaChua() async {
    if (thietBi.thietBiID != null) {
      await _suaChuaProvider.fetchByThietBi(thietBi.thietBiID!);
    }
  }

  Future<void> reloadLichSuMuaThietBi() async {
    if (thietBi.thietBiID != null) {
      await _lichSuMuaThietBiProvider.fetchByThietBi(thietBi.thietBiID!);

      notifyListeners();
    }
  }

  bool get dangSua => thietBi.trangThaiText.toLowerCase() == "đang sửa";

  String get tenThietBi => thietBi.tenThietBi ?? "";

  String get loai => thietBi.loai ?? "";

  String get trangThai => thietBi.trangThaiText;

  Future<bool> capNhatTrangThai(String trangThaiMoi) async {
    final thietBiMoi = thietBi.copyWith(
      trangThai: trangThaiMoi == "Tốt" ? 0 : 1,
    );

    final ok = await _thietBiProvider.capNhat(thietBiMoi);

    if (ok) {
      thietBi = thietBiMoi;
      notifyListeners();
    }

    return ok;
  }

  Future<SuaChuaDTO?> themLichSuSuaChua(SuaChuaDTO suaChua) async {
    return await _suaChuaProvider.them(suaChua);
  }

  Future<bool> xoaThietBi() async {
    if (thietBi.thietBiID == null) return false;

    return await _thietBiProvider.xoa(thietBi.thietBiID!);
  }

  @override
  void dispose() {
    _suaChuaProvider.removeListener(_onProviderUpdate);
    _lichSuMuaThietBiProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
