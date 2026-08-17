import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/models/item_phong_model.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class LichSuSuaChuaPageViewModel extends ChangeNotifier {
  final ThietBi thietBi;
  final LapRap? lapRap;
  final SuaChuaProvider _suaChuaProvider;
  final PhongProvider _phongProvider;

  final txtSearch = TextEditingController();

  List<LichSuSuaChuaPageModel> dsGoc = [];
  List<LichSuSuaChuaPageModel> lichSuSuaChua = [];

  bool get isLoading => _suaChuaProvider.isLoading;

  /// Thông tin phòng thật (lấy từ provider), dùng để hiển thị tên phòng
  /// khi mở trang từ 1 LapRap cụ thể.
  ItemPhongModel? phongCuaLapRap;
  bool isLoadingPhong = false;

  LichSuSuaChuaPageViewModel({
    required this.thietBi,
    this.lapRap,
    required SuaChuaProvider suaChuaProvider,
    required PhongProvider phongProvider,
  }) : _suaChuaProvider = suaChuaProvider,
       _phongProvider = phongProvider {
    _suaChuaProvider.addListener(_onProviderUpdate);

    txtSearch.addListener(timKiem);

    Future.microtask(() => _loadAll());
  }

  /// Tải toàn bộ dữ liệu cần cho trang: lịch sử sửa chữa + thông tin phòng.
  /// Dùng chung cho lần khởi tạo đầu tiên và mỗi lần reload() để 2 luồng
  /// luôn nhất quán, tránh reload() bị thiếu bước cập nhật phòng.
  Future<void> _loadAll() async {
    await _fetch();
    await _fetchPhong();

    dsGoc = List.from(_suaChuaProvider.list);
    lichSuSuaChua = List.from(dsGoc);

    notifyListeners();
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

  Future<void> _fetchPhong() async {
    if (lapRap?.phongID == null) return;

    isLoadingPhong = true;
    notifyListeners();

    try {
      phongCuaLapRap = await _phongProvider.getInforPhong(lapRap!.phongID!);
    } catch (_) {
      phongCuaLapRap = null;
    } finally {
      isLoadingPhong = false;
      notifyListeners();
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
        return (e.suaChua?.nguyenNhan ?? '').toLowerCase().contains(keyword);
      }).toList();
    }

    notifyListeners();
  }

  Future<void> reload() async {
    await _loadAll();
  }

  @override
  void dispose() {
    txtSearch.removeListener(timKiem);
    txtSearch.dispose();
    _suaChuaProvider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
