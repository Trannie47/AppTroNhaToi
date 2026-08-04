import 'package:flutter/material.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_phong_provider.dart';

class HoaDonHomePageViewModel extends ChangeNotifier {
  final HoadonPhongProvider _hoaDonProvider;

  HoaDonHomePageViewModel({required HoadonPhongProvider hoaDonProvider})
    : _hoaDonProvider = hoaDonProvider;

  bool get isLoading => _hoaDonProvider.isLoading;
  String? get errorMessage => _hoaDonProvider.errorMessage;

  // Mặc định kỳ hóa đơn là tháng hiện tại
  late String selectedThangNam;
  int selectedFilter = -1; // -1: Tất cả, 0: Chưa thu, 2: Đã thu
  String searchQuery = "";

  Future<void> initData() async {
    final now = DateTime.now();
    selectedThangNam = "${now.month.toString().padLeft(2, '0')}/${now.year}";
    await loadData();
  }

  Future<void> loadData() async {
    await _hoaDonProvider.fetchTatCaHoaDonQuanLy(thangNam: selectedThangNam);
    notifyListeners();
  }

  void setThangNam(String thang) {
    selectedThangNam = thang;
    loadData();
  }

  void setFilter(int filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  Future<void> chonKyHoaDon(BuildContext context) async {
    // Tách tháng và năm hiện tại từ string đang chọn (VD: "07/2026")
    List<String> parts = selectedThangNam.split('/');
    int initialMonth = int.tryParse(parts[0]) ?? DateTime.now().month;
    int initialYear = int.tryParse(parts[1]) ?? DateTime.now().year;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initialYear, initialMonth, 1),
      firstDate: DateTime(2020), // Cho phép xem dữ liệu từ năm 2020 trở về sau
      lastDate: DateTime(2100),
      helpText: "CHỌN KỲ HÓA ĐƠN (THÁNG/NĂM)",
      fieldLabelText: "Chọn tháng/năm",
    );

    if (picked != null) {
      String formattedThangNam =
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      if (formattedThangNam != selectedThangNam) {
        selectedThangNam = formattedThangNam;
        loadData();
      }
    }
  }

  List<Map<String, dynamic>> get filteredList {
    final list = _hoaDonProvider.danhSachTatCaHoaDon;
    return list.where((inv) {
      final int trangThai = inv['trangThai'] ?? 0;
      final bool matchStatus =
          selectedFilter == -1 || trangThai == selectedFilter;

      final String tenPhong = (inv['tenPhong'] ?? '').toString().toLowerCase();
      final String hoTen = (inv['hoTenKhach'] ?? '').toString().toLowerCase();
      final String maHD = (inv['maHoaDon'] ?? '').toString().toLowerCase();

      final bool matchSearch =
          tenPhong.contains(searchQuery.toLowerCase()) ||
          hoTen.contains(searchQuery.toLowerCase()) ||
          maHD.contains(searchQuery.toLowerCase());

      return matchStatus && matchSearch;
    }).toList();
  }
}
