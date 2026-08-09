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
  // -2: Chưa thanh toán xong (gộp cả "chưa thu" + "1 phần", chỉ dùng khi
  // bấm banner cảnh báo nợ kỳ khác), -1: Tất cả, 0: Chưa thu, 1: 1 phần, 2: Đã thu
  int selectedFilter = -1;
  String searchQuery = "";

  // Số hóa đơn chưa thanh toán xong (trangThai != 2) thuộc các kỳ KHÁC kỳ
  int soHoaDonNoKyKhac = 0;

  Future<void> initData() async {
    final now = DateTime.now();
    selectedThangNam = "${now.month.toString().padLeft(2, '0')}/${now.year}";
    await loadData();
  }

  Future<void> loadData() async {
    await _hoaDonProvider.fetchTatCaHoaDonQuanLy(thangNam: selectedThangNam);
    notifyListeners();
    _capNhatCanhBaoNoKyKhac();
  }

  Future<void> _capNhatCanhBaoNoKyKhac() async {
    final tatCa = await _hoaDonProvider.getAllHoaDonKhongLuu();
    soHoaDonNoKyKhac = tatCa.where((inv) {
      final trangThai = inv['trangThai'] ?? 0;
      final thangNam = inv['thangNam']?.toString() ?? '';
      return trangThai != 2 &&
          thangNam.isNotEmpty &&
          thangNam != selectedThangNam;
    }).length;
    notifyListeners();
  }

  void xemNoTuKyKhac() {
    selectedThangNam = "Tất cả";
    selectedFilter = -2;
    loadData();
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
    // Tách tháng và năm hiện tại từ string đang chọn (VD: "07/2026"). Khi
    // đang ở chế độ "Tất cả" (bấm từ banner cảnh báo nợ) thì không parse
    // được -> mặc định về tháng/năm hiện tại.
    List<String> parts = selectedThangNam.split('/');
    int initialMonth = parts.length > 1
        ? int.tryParse(parts[0]) ?? DateTime.now().month
        : DateTime.now().month;
    int initialYear = parts.length > 1
        ? int.tryParse(parts[1]) ?? DateTime.now().year
        : DateTime.now().year;

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
        if (selectedFilter == -2) selectedFilter = -1;
        loadData();
      }
    }
  }

  List<Map<String, dynamic>> get filteredList {
    final list = _hoaDonProvider.danhSachTatCaHoaDon;
    return list.where((inv) {
      final int trangThai = inv['trangThai'] ?? 0;
      final bool matchStatus = selectedFilter == -1
          ? true
          : selectedFilter == -2
          ? trangThai != 2
          : trangThai == selectedFilter;

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
