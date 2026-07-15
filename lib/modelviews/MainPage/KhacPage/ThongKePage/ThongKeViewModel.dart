import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThongKeViewModel extends ChangeNotifier {
  /// FILTER

  int selectedFilter = 2;

  final List<String> filters = ['Hôm nay', 'Tuần', 'Tháng', 'Năm', 'Tùy chọn'];

  void changeFilter(int index) {
    selectedFilter = index;
    notifyListeners();
  }

  /// SCROLL

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

  /// KPI

  double tongDoanhThu = 150000000;

  double daThu = 120000000;

  double chuaThu = 30000000;

  double tongChiPhi = 25000000;

  /// ROOM

  int tongPhong = 40;

  int phongDangThue = 34;

  int phongTrong = 6;

  double tyLeLapDay = 0.85;

  /// TENANT

  int tongNguoiThue = 56;

  int nguoiDangO = 54;

  int daTraPhong = 2;

  int hopDongSapHet = 4;

  /// DEVICE

  int tongThietBi = 180;

  int thietBiHoatDong = 171;

  int thietBiDangSua = 6;

  int thietBiHong = 3;

  /// EXPENSE

  double chiPhiSuaChua = 12000000;

  double chiPhiMuaThietBi = 8000000;

  double chiPhiKhac = 5000000;

  /// PIE CHART

  final List<Map<String, dynamic>> pieData = [
    {
      "title": "Tiền phòng",
      "value": "60%",
      "percent": 60.0,
      "color": const Color(0xFF7C4DFF),
    },
    {
      "title": "Tiền điện",
      "value": "18%",
      "percent": 18.0,
      "color": Colors.green,
    },
    {
      "title": "Tiền nước",
      "value": "10%",
      "percent": 10.0,
      "color": Colors.orange,
    },
    {"title": "Tạp hóa", "value": "8%", "percent": 8.0, "color": Colors.blue},
    {"title": "Khác", "value": "4%", "percent": 4.0, "color": Colors.red},
  ];

  /// TOP DOANH THU

  final List<Map<String, dynamic>> topRevenue = [
    {
      "room": "P101",
      "money": "15.000.000đ",
      "icon": "🥇",
      "color": Colors.amber,
    },
    {
      "room": "P203",
      "money": "13.500.000đ",
      "icon": "🥈",
      "color": Colors.grey,
    },
    {
      "room": "P305",
      "money": "12.800.000đ",
      "icon": "🥉",
      "color": const Color(0xFFCD7F32),
    },
    {"room": "P102", "money": "12.000.000đ", "icon": "4", "color": Colors.blue},
    {
      "room": "P401",
      "money": "11.500.000đ",
      "icon": "5",
      "color": Colors.green,
    },
  ];

  /// TOP CÔNG NỢ

  final List<Map<String, dynamic>> topDebt = [
    {"room": "P104", "money": "6.500.000đ"},
    {"room": "P210", "money": "5.000.000đ"},
    {"room": "P305", "money": "4.000.000đ"},
    {"room": "P110", "money": "3.500.000đ"},
    {"room": "P402", "money": "2.800.000đ"},
  ];

  /// HOẠT ĐỘNG

  final List<Map<String, dynamic>> activities = [
    {
      "icon": Icons.payments_rounded,
      "title": "Thu tiền phòng P101",
      "time": "10 phút trước",
      "color": Colors.green,
    },
    {
      "icon": Icons.build_rounded,
      "title": "Thanh toán sửa chữa máy lạnh",
      "time": "40 phút trước",
      "color": Colors.orange,
    },
    {
      "icon": Icons.inventory_rounded,
      "title": "Nhập thiết bị mới",
      "time": "1 giờ trước",
      "color": Colors.blue,
    },
    {
      "icon": Icons.logout_rounded,
      "title": "Người thuê trả phòng",
      "time": "Hôm nay",
      "color": Colors.red,
    },
    {
      "icon": Icons.description_rounded,
      "title": "Lập hợp đồng mới",
      "time": "Hôm nay",
      "color": const Color(0xFF7C4DFF),
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }
}
