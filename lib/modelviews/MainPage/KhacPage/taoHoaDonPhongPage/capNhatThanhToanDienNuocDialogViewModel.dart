import 'package:flutter/material.dart';
import '../../../../Provider/phieu_thu_dien_nuoc_provider.dart';

class CapNhatThanhToanDienNuocDialogViewModel extends ChangeNotifier {
  final PhieuThuDienNuocProvider provider;

  final int phongId;
  final String thangNam;
  final int lanGhi;
  final double tongTienDN;
  final int trangThaiHienTai;

  bool isLoading = false;
  String? errorMessage;

  final txtGhiChu = TextEditingController();

  CapNhatThanhToanDienNuocDialogViewModel({
    required this.provider,
    required this.phongId,
    required this.thangNam,
    required this.lanGhi,
    required this.tongTienDN,
    required this.trangThaiHienTai,
  });

  bool get isPaid => trangThaiHienTai == 2;

  Future<bool> submitPhieuThuDienNuoc() async {
    if (isPaid) return true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final success = await provider.createPhieuThuDienNuoc(
      phongId: phongId,
      thangNam: thangNam,
      lanGhi: lanGhi,
      soTien: tongTienDN,
      ghiChu: txtGhiChu.text.trim().isEmpty ? null : txtGhiChu.text.trim(),
    );

    if (!success) {
      errorMessage = provider.errorMessage ?? "Lập phiếu thu điện nước thất bại!";
    }

    isLoading = false;
    notifyListeners();
    return success;
  }

  @override
  void dispose() {
    txtGhiChu.dispose();
    super.dispose();
  }
}