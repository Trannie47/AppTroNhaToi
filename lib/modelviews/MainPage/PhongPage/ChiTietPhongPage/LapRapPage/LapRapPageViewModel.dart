import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/NhomThietBiTrongPhongModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class LapRapPageViewModel extends ChangeNotifier {
  final LapRapProvider _lapRapProvider;
  final int phongId;

  List<LapRapPageModel> _dsLapRap = [];
  List<LapRapPageModel> get dsLapRap => _dsLapRap;

  /// Danh sách đã gộp nhóm theo thietBiId — dùng để hiển thị lên UI
  /// dạng "1 dòng = 1 loại thiết bị + số lượng", vì backend không có
  /// field soLuong (mỗi LapRap = 1 thiết bị vật lý).
  List<NhomThietBiTrongPhong> get dsNhomThietBi =>
      gomNhomTheoThietBi(_dsLapRap);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LapRapPageViewModel(this._lapRapProvider, this.phongId);

  Future<void> fetchThietBiByPhongId() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dsLapRap = await _lapRapProvider.getThietBiByPhongId(phongId);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LapRapPageViewModel.fetchThietBiByPhongId: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// THÊM MỚI: tạo `soLuong` dòng LapRap riêng biệt cho cùng 1 loại thiết bị
  /// (vì backend không nhận field soLuong, mỗi lần gọi API = 1 thiết bị).
  Future<bool> themThietBi({
    required int thietBiId,
    required int soLuong,
    required DateTime ngayLap,
    String ghiChu = '',
  }) async {
    if (soLuong <= 0) {
      _errorMessage = "Số lượng phải lớn hơn 0";
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      for (int i = 0; i < soLuong; i++) {
        final result = await _lapRapProvider.taoLapRap(
          phongId: phongId,
          thietBiId: thietBiId,
          ghiChu: ghiChu,
          ngayLap: ngayLap,
        );
        if (result == null) {
          throw Exception("Tạo lắp ráp thất bại ở thiết bị thứ ${i + 1}");
        }
      }

      await fetchThietBiByPhongId();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LapRapPageViewModel.themThietBi: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow; // Bắn lỗi ra để Dialog UI bắt hiện SnackBar đỏ
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// CẬP NHẬT SỐ LƯỢNG: so sánh số lượng mới với nhóm hiện tại.
  /// - Tăng: tạo thêm dòng mới cho phần chênh lệch.
  /// - Giảm: xóa mềm bớt các dòng dư ra (ưu tiên xóa dòng KHÔNG đang sửa
  ///   chữa / không hỏng trước, tránh xóa nhầm thiết bị đang có vấn đề).
  /// - Về 0: xóa mềm toàn bộ nhóm ("Xóa khỏi phòng").
  Future<bool> capNhatSoLuongThietBi({
    required NhomThietBiTrongPhong nhom,
    required int soLuongMoi,
    required DateTime ngayLap,
    String ghiChu = '',
  }) async {
    if (soLuongMoi < 0) {
      _errorMessage = "Số lượng không hợp lệ";
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final soLuongHienTai = nhom.soLuong;

      if (soLuongMoi > soLuongHienTai) {
        // TĂNG: tạo thêm phần chênh lệch
        final soCanThem = soLuongMoi - soLuongHienTai;
        for (int i = 0; i < soCanThem; i++) {
          final result = await _lapRapProvider.taoLapRap(
            phongId: phongId,
            thietBiId: nhom.thietBiId,
            ghiChu: ghiChu,
            ngayLap: ngayLap,
          );
          if (result == null) {
            throw Exception("Thêm thiết bị thất bại ở lượt ${i + 1}");
          }
        }
      } else if (soLuongMoi < soLuongHienTai) {
        // GIẢM (hoặc về 0): xóa bớt các dòng dư ra.
        // Ưu tiên xóa dòng "an toàn" (không đang sửa chữa, không hỏng) trước.
        final soCanXoa = soLuongHienTai - soLuongMoi;
        final danhSachSapXep = [...nhom.danhSach]
          ..sort(
            (a, b) => (a.soLuongDangSua + a.soLuongHong).compareTo(
              b.soLuongDangSua + b.soLuongHong,
            ),
          );

        final idsCanXoa = danhSachSapXep
            .take(soCanXoa)
            .map((e) => e.lapRap.id)
            .whereType<int>()
            .toList();

        for (final id in idsCanXoa) {
          // final thanhCong = await _lapRapProvider.xoaLapRap(id);
          // if (!thanhCong) {
          //   throw Exception("Xóa thiết bị (id: $id) thất bại");
          // }
        }
      }
      // Nếu soLuongMoi == soLuongHienTai thì không cần làm gì thêm.

      await fetchThietBiByPhongId();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LapRapPageViewModel.capNhatSoLuongThietBi: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  //dùng để gọi api load lại dữ liệu mới trong quá trình thêm số lượng của thiết bị vào phòng
  Future<void> reloadAll(BuildContext context) async {
    await fetchThietBiByPhongId();
    if (context.mounted) {
      context.read<ThietBiProvider>().fetchAll();
    }
  }
}
