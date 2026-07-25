import 'package:flutter/material.dart';
import '../../../../Provider/phieu_thu_hang_thang_provider.dart';

class CapNhatThanhToanViewModel extends ChangeNotifier {
  final PhieuThuHangThangProvider phieuThuProvider;

  final String maHoaDon;
  final double tongTienHD;
  final double tongDaThu;
  final int trangThaiBanDau;

  // 0: Chưa thu, 1: Thu 1 phần, 2: Thanh toán đủ 100%
  int mode = 0;

  bool isLoading = false;
  String? errorMessage;

  final txtSoTienNop = TextEditingController();
  final txtGhiChu = TextEditingController();

  double get conThieu => (tongTienHD - tongDaThu) > 0 ? (tongTienHD - tongDaThu) : 0;

  CapNhatThanhToanViewModel({
    required this.phieuThuProvider,
    required this.maHoaDon,
    required this.tongTienHD,
    required this.tongDaThu,
    required this.trangThaiBanDau,
  }) {
    mode = trangThaiBanDau;
    if (mode == 2) {
      txtSoTienNop.text = _formatNumber(conThieu);
    } else if (mode == 1) {
      txtSoTienNop.text = _formatNumber(conThieu);
    } else {
      txtSoTienNop.text = "0";
    }
  }

  static String _formatNumber(double amount) {
    final integerPart = amount.round().toString();
    return integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  void setMode(int newMode) {
    mode = newMode;
    if (mode == 2) {
      // Chọn Thu đủ -> Điền đủ số tiền còn thiếu
      txtSoTienNop.text = _formatNumber(conThieu);
    } else if (mode == 0) {
      txtSoTienNop.text = "0";
    } else {
      txtSoTienNop.text = _formatNumber(conThieu);
    }
    notifyListeners();
  }

  Future<bool> submitPhieuThu() async {
    if (mode == 0) {
      errorMessage = "Hóa đơn đang ở trạng thái 'Chưa thanh toán'!";
      notifyListeners();
      return false;
    }

    String cleanText = txtSoTienNop.text.replaceAll('.', '').replaceAll(',', '').trim();
    double soTienNop = double.tryParse(cleanText) ?? 0;

    if (mode == 2) {
      soTienNop = conThieu;
    }

    if (soTienNop <= 0) {
      errorMessage = "Số tiền thu đợt này phải lớn hơn 0đ!";
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
    txtSoTienNop.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}