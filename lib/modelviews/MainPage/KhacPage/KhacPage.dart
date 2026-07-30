import 'package:flutter/material.dart';

import '../../../Provider/cau_hinh_gia_provider.dart';
import '../../../Provider/hop_dong_provider.dart';

class KhacPageModelView extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final CauHinhGiaProvider _cauHinhGiaProvider;
  bool isLoading = false;

  KhacPageModelView(this._hopDongProvider,this._cauHinhGiaProvider) {
    _hopDongProvider.addListener(_onHopDongChanged);
    loadData();
  }

  void _onHopDongChanged() {
    notifyListeners();
  }
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();
    try {
      await _hopDongProvider.getListHD();
      await _cauHinhGiaProvider.getGiaHienTai();
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu ở KhacPage: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  int get soLuongSapHetHan {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _hopDongProvider.listHD.where((hd) {
      // Chỉ tính hợp đồng đang hoạt động (trangThai == 1)
      if (hd.trangThai != 1) return false;

      final ngayHetHan = DateTime(
        hd.ngayHetHan.year,
        hd.ngayHetHan.month,
        hd.ngayHetHan.day,
      );

      final soNgayConLai = ngayHetHan.difference(today).inDays;

      // Sắp hết hạn khi số ngày còn lại nằm trong khoảng từ 0 đến 30 ngày
      return soNgayConLai >= 0 && soNgayConLai <= 30;
    }).length;
  }
  @override
  void dispose() {
    _hopDongProvider.removeListener(_onHopDongChanged);
    super.dispose();
  }
}