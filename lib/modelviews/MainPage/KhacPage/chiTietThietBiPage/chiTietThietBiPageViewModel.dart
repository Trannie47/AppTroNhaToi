import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class ChiTietThietBiPageViewModel extends ChangeNotifier {
  ThietBi thietBi;

  final SuaChuaProvider _suaChuaProvider;

  bool hienMenu = false;

  late List<ThietBi> dsThietBi;

  List<LichSuSuaChuaPageModel> get lichSuSuaChua =>
      _suaChuaProvider.list.take(3).toList();

  bool get isLoading => _suaChuaProvider.isLoading;

  ChiTietThietBiPageViewModel({
    required this.thietBi,
    required SuaChuaProvider suaChuaProvider,
  }) : _suaChuaProvider = suaChuaProvider {
    _suaChuaProvider.addListener(_onProviderUpdate);

    Future.microtask(() async {
      if (thietBi.thietBiID != null) {
        await _suaChuaProvider.fetchByThietBi(thietBi.thietBiID!);
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

  bool get dangSua => thietBi.trangThaiText.toLowerCase() == "đang sửa";

  String get tenThietBi => thietBi.tenThietBi ?? "";

  String get loai => thietBi.loai ?? "";

  double get giaTri => thietBi.giaTri ?? 0;

  DateTime? get ngayMua => thietBi.ngayMua;

  String get trangThai => thietBi.trangThaiText;

  void capNhatTrangThai(String trangThaiMoi) {
    thietBi = thietBi.copyWith(trangThai: trangThaiMoi == "Tốt" ? 0 : 1);

    notifyListeners();
  }

  Future<SuaChuaDTO?> themLichSuSuaChua(SuaChuaDTO suaChua) async {
    return await _suaChuaProvider.them(suaChua);
  }

  Future<bool> xoaLichSu(int id) async {
    return await _suaChuaProvider.xoa(id, thietBi.thietBiID!);
  }

  @override
  void dispose() {
    _suaChuaProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
