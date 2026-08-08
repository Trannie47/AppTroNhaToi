import 'package:flutter/material.dart';
import '../../../../Provider/phieu_thu_hang_thang_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/phieu_thu_hang_thang.dart';

class CapNhatThanhToanViewModel extends ChangeNotifier {
  final PhieuThuHangThangProvider phieuThuProvider;

  final String maHoaDon;
  final double tongTienHD;
  final double tongDaThu;
  final int trangThaiHienTai;

  int luaChonThanhToan = LuaChonThanhToan.chuaThanhToan;

  bool isLoading = false;
  bool isLoadingHistory = false;
  String? errorMessage;

  final txtGhiChu = TextEditingController();
  final txtSoTien = TextEditingController();

  double get conThieu =>
      (tongTienHD - tongDaThu) > 0 ? (tongTienHD - tongDaThu) : 0;

  bool get daThanhToanDu => trangThaiHienTai == 2 || conThieu <= 0;

  List<PhieuThuHangThang> get lichSuThanhToan => phieuThuProvider.listPhieuThu;

  CapNhatThanhToanViewModel({
    required this.phieuThuProvider,
    required this.maHoaDon,
    required this.tongTienHD,
    required this.tongDaThu,
    required this.trangThaiHienTai,
  }) {
    luaChonThanhToan = trangThaiHienTai == LuaChonThanhToan.motPhan
        ? LuaChonThanhToan.motPhan
        : LuaChonThanhToan.chuaThanhToan;
    _taiLichSuThanhToan();
  }

  void chonHinhThucThanhToan(int luaChon) {
    if (luaChonThanhToan == luaChon) return;
    luaChonThanhToan = luaChon;
    errorMessage = null;
    if (luaChon == LuaChonThanhToan.du) {
      txtSoTien.text = formatSoTienNhap(conThieu);
    } else {
      txtSoTien.clear();
    }
    notifyListeners();
  }

  Future<void> _taiLichSuThanhToan() async {
    isLoadingHistory = true;
    notifyListeners();
    await phieuThuProvider.fetchByMaHoaDon(maHoaDon);
    isLoadingHistory = false;
    notifyListeners();
  }

  Future<bool> submitPhieuThu() async {
    errorMessage = null;

    if (conThieu <= 0) {
      errorMessage = "Hóa đơn này đã được thanh toán đủ trước đó!";
      notifyListeners();
      return false;
    }

    if (luaChonThanhToan == LuaChonThanhToan.chuaThanhToan) {
      errorMessage = "Vui lòng chọn hình thức thanh toán!";
      notifyListeners();
      return false;
    }

    final soTienNop =
        double.tryParse(txtSoTien.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;

    if (soTienNop <= 0) {
      errorMessage = "Vui lòng nhập số tiền thu hợp lệ!";
      notifyListeners();
      return false;
    }

    isLoading = true;
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
    txtSoTien.dispose();
    super.dispose();
  }
}

class LuaChonThanhToan {
  static const int chuaThanhToan = 0;
  static const int motPhan = 1;
  static const int du = 2;
}

