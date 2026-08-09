import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:AppTroNhaToi/models/DTO/ThongKeDTO.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThongKePage/PieChartItem.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThongKePageViewModel extends ChangeNotifier {
  final ThongKeProvider _service;

  ThongKePageViewModel(this._service) {
    _service.addListener(_onThongKeUpdate);

    Future.microtask(() => _service.getThongKe());
  }

  void _onThongKeUpdate() {
    notifyListeners();
  }

  ///================ FILTER ==================

  int thangChon = DateTime.now().month;

  int namChon = DateTime.now().year;

  String get thangNamText => "${thangChon.toString().padLeft(2, '0')}/$namChon";

  void chonThangNam(int thang, int nam) {
    thangChon = thang;
    namChon = nam;

    notifyListeners();

    loadThongKe(thang: thangChon, nam: namChon);
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

  ThongKeDTO? get data => _service.thongKe;

  ///================ KPI ==================

  double get tongDoanhThu => data?.doanhThu.tongDoanhThu ?? 0;

  double get daThu => data?.daThu.tongDaThu ?? 0;

  double get chuaThu => data?.congNo.tongCongNo ?? 0;

  double get tongChiPhi => data?.chiPhi.tongChiPhi ?? 0;

  double get chiPhiSuaChua => data?.chiPhi.tongTienSuaChua ?? 0;

  double get chiPhiMuaThietBi => data?.chiPhi.tongTienMuaThietBi ?? 0;

  double get chiPhiLuanChuyen => data?.chiPhi.tongTienLuanChuyen ?? 0;

  double get phanTramSuaChua => data?.chiPhi.tyLeSuaChua ?? 0;

  double get phanTramMuaThietBi => data?.chiPhi.tyLeMuaThietBi ?? 0;

  double get phanTramLuanChuyen => data?.chiPhi.tyLeLuanChuyen ?? 0;

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

  List<PieChartItem> get pieChartData {
    if (data == null) return [];

    return [
      PieChartItem(
        title: "Tiền phòng",
        value: data!.doanhThu.doanhThuPhong,
        color: const Color(0xFF7C4DFF),
      ),
      PieChartItem(
        title: "Gửi xe",
        value: data!.doanhThu.doanhThuGuiXe,
        color: Colors.blue,
      ),
      PieChartItem(
        title: "Tạp hóa",
        value: data!.doanhThu.doanhThuTapHoa,
        color: Colors.orange,
      ),
    ];
  }

  List<PieChartSectionData> get pieSections {
    final tong = data?.doanhThu.tongDoanhThu ?? 0;

    if (tong == 0) return [];

    return pieChartData.map((e) {
      final percent = (e.value / tong) * 100;

      return PieChartSectionData(
        value: e.value,
        color: e.color,
        radius: 28,
        title: "${percent.toStringAsFixed(1)}%",
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _service.removeListener(_onThongKeUpdate);
    super.dispose();
  }
}
