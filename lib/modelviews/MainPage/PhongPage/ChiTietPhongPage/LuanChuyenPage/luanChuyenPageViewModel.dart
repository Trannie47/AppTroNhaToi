import 'package:AppTroNhaToi/Provider/phieu_luan_chuyen_provider.dart';
import 'package:AppTroNhaToi/models/item_phong_model.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:flutter/foundation.dart';

class PhieuLuanChuyenPageViewModel extends ChangeNotifier {
  final PhieuLuanChuyenProvider _provider;
  late final ItemPhongModel phong;

  List<PhieuLuanChuyen> get dsPhieu => _provider.listByPhongHopDong;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PhieuLuanChuyenPageViewModel(this._provider, this.phong) {
    _provider.addListener(_onProviderUpdate);
  }

  void _onProviderUpdate() {
    notifyListeners();
  }

  Future<void> refesh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _provider.find(phong.phongId);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi DanhSachPhieuLuanChuyenPageViewModel.fetchDsPhieu: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> anPhieu(int chiTietLuanChuyenID) async {
    try {
      final thanhCong = await _provider.xoa(chiTietLuanChuyenID);
      if (thanhCong) {
        await refesh();
      }
      return thanhCong;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi DanhSachPhieuLuanChuyenPageViewModel.anPhieu: $e");
      }
      rethrow;
    }
  }

  // Hoàn thành sớm: người thuê đã dọn về phòng gốc trước ngày denNgay dự kiến ban đầu.
  Future<bool> hoanThanhSom(
    PhieuLuanChuyen item, {
    double? chiPhiMoi,
    String? ghiChuMoi,
  }) async {
    try {
      final homNay = DateTime.now();
      final ngayHomQua = DateTime(homNay.year, homNay.month, homNay.day - 1);
      final tuNgay = item.tuNgay;
      final denNgayMoi =
          (tuNgay != null &&
              !ngayHomQua.isAfter(
                DateTime(tuNgay.year, tuNgay.month, tuNgay.day),
              ))
          ? DateTime(tuNgay.year, tuNgay.month, tuNgay.day)
          : ngayHomQua;
      final capNhat = item.copyWith(
        denNgay: denNgayMoi,
        chiPhi: chiPhiMoi,
        ghiChu: ghiChuMoi,
      );
      final thanhCong = await _provider.capNhat(capNhat);
      if (thanhCong) {
        await refesh();
      }
      return thanhCong;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi DanhSachPhieuLuanChuyenPageViewModel.hoanThanhSom: $e");
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
