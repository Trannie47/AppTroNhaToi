import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThongKeViewModel extends ChangeNotifier {
  final ThongKeProvider _service;

  ThongKeViewModel(this._service) {
    _service.addListener(_onThongKeUpdate);

    Future.microtask(() => _service.getThongKe());
  }

  void _onThongKeUpdate() {
    notifyListeners();
  }

  ///================ FILTER ==================

  int selectedFilter = 2;

  final List<String> filters = ['Hôm nay', 'Tuần', 'Tháng', 'Năm', 'Tùy chọn'];

  void changeFilter(int index) {
    selectedFilter = index;
    notifyListeners();
  }

  ///================ SCROLL ==================

  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  void scrollTo(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  ///================ API ==================

  Future<void> loadThongKe({int? thang, int? nam}) async {
    await _service.getThongKe(thang: thang, nam: nam);
  }

  ///================ DATA ==================

  get data => _service.thongKe;

  ///================ KPI ==================

  double get tongDoanhThu => data?.doanhThu.tongDoanhThu ?? 0;

  double get daThu => data?.daThu.tongDaThu ?? 0;

  double get chuaThu => data?.congNo.tongCongNo ?? 0;

  double get tongChiPhi => data?.chiPhi.tongChiPhi ?? 0;

  ///================ ROOM ==================

  int get tongPhong => data?.phong.tongPhong ?? 0;

  int get phongDangThue => data?.phong.phongDangThue ?? 0;

  int get phongTrong => data?.phong.phongTrong ?? 0;

  double get tyLeLapDay => data?.phong.tiLeLapDay ?? 0;

  ///================ TENANT ==================

  int get tongNguoiThue => data?.nguoiThue.tongNguoiThue ?? 0;

  int get nguoiDangO => data?.nguoiThue.nguoiDangThue ?? 0;

  int get daTraPhong => data?.nguoiThue.nguoiDaDonDi ?? 0;

  int get hopDongSapHet => data?.nguoiThue.hopDongSapHet ?? 0;

  ///================ DEVICE ==================

  int get tongThietBi => data?.thietBi.tongThietBi ?? 0;

  int get thietBiHoatDong => data?.thietBi.thietBiHoatDong ?? 0;

  int get thietBiDangSua => data?.thietBi.thietBiDangSua ?? 0;

  int get thietBiHong => data?.thietBi.thietBiHong ?? 0;

  int get tongLapRap => data?.thietBi.tongLapRap ?? 0;

  int get tongSuaChua => data?.thietBi.tongSuaChua ?? 0;

  ///================ CHART ==================

  get chart => data?.chart ?? [];

  @override
  void dispose() {
    _service.removeListener(_onThongKeUpdate);
    super.dispose();
  }
}
