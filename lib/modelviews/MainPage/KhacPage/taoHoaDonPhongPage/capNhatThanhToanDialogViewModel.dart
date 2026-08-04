import 'package:flutter/material.dart';
import '../../../../Provider/phieu_thu_hang_thang_provider.dart';

class CapNhatThanhToanViewModel extends ChangeNotifier {
  final PhieuThuHangThangProvider phieuThuProvider;

  final String maHoaDon;
  final double tongTienHD;
  final double tongDaThu;
  final int trangThaiBanDau;

  bool isLoading = false;
  String? errorMessage;

  final txtGhiChu = TextEditingController();

  double get conThieu =>
      (tongTienHD - tongDaThu) > 0 ? (tongTienHD - tongDaThu) : 0;

  CapNhatThanhToanViewModel({
    required this.phieuThuProvider,
    required this.maHoaDon,
    required this.tongTienHD,
    required this.tongDaThu,
    required this.trangThaiBanDau,
  });

  Future<bool> submitPhieuThu() async {
    double soTienNop = conThieu;

    if (soTienNop <= 0) {
      errorMessage = "Hóa đơn này đã được thanh toán đủ trước đó!";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await phieuThuProvider.createPhieuThu(
      maHoaDon: maHoaDon,
      soTien: soTienNop,
      ghiChu: txtGhiChu.text.trim().isEmpty ? null : txtGhiChu.text.trim(),
    );

    if (result == null) {
      errorMessage = phieuThuProvider.errorMessage ?? "Lập phiếu thu thất bại!";
      isLoading = false;
      notifyListeners();
      return false;
    }

    isLoading = false;
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    txtGhiChu.dispose();
    super.dispose();
  }
}
