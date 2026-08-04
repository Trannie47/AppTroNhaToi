import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/NhomThietBiTrongPhongModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ThietBiPhongPageViewModel extends ChangeNotifier {
  final LapRapProvider _lapRapProvider;
  final int phongId;

  List<ThietBiPhongPageModel> _dsLapRap = [];
  List<ThietBiPhongPageModel> get dsLapRap => _dsLapRap;

  /// Danh sách đã gộp nhóm theo thietBiId — chỉ dùng để HIỂN THỊ
  /// dạng "1 dòng = 1 loại thiết bị + số lượng đang có trong phòng".
  /// Thao tác thêm/sửa/xóa vẫn luôn thực hiện trên từng thiết bị riêng lẻ.
  List<NhomThietBiTrongPhong> get dsNhomThietBi =>
      gomNhomTheoThietBi(_dsLapRap);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ThietBiPhongPageViewModel(this._lapRapProvider, this.phongId);

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

  /// THÊM MỚI: gắn đúng 1 thiết bị vào phòng.
  Future<bool> themThietBi({
    required int thietBiId,
    required DateTime ngayLap,
    String ghiChu = '',
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _lapRapProvider.taoLapRap(
        phongId: phongId,
        thietBiId: thietBiId,
        ghiChu: ghiChu,
        ngayLap: ngayLap,
      );
      if (result == null) {
        throw Exception("Thêm thiết bị thất bại");
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

  /// CẬP NHẬT: sửa ghi chú / ngày lắp cho đúng 1 bản ghi lắp ráp.
  Future<bool> capNhatThietBi({
    required ThietBiPhongPageModel item,
    required DateTime ngayLap,
    String ghiChu = '',
  }) async {
    final id = item.lapRap.id;
    if (id == null) {
      _errorMessage = "Không xác định được thiết bị cần cập nhật";
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final thanhCong = await _lapRapProvider.capNhatLapRap(
        id: id,
        ghiChu: ghiChu,
        // ngayLap: ngayLap,
      );
      if (thanhCong != true) {
        throw Exception("Cập nhật thiết bị thất bại");
      }

      await fetchThietBiByPhongId();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LapRapPageViewModel.capNhatThietBi: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// XÓA: gỡ đúng 1 thiết bị khỏi phòng (xóa mềm bản ghi lắp ráp).
  // Future<bool> xoaThietBi(int id) async {
  //   _isSubmitting = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     final thanhCong = await _lapRapProvider.xoaLapRap(id);
  //     if (thanhCong != true) {
  //       throw Exception("Xóa thiết bị thất bại");
  //     }

  //     await fetchThietBiByPhongId();
  //     return true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Lỗi LapRapPageViewModel.xoaThietBi: $e");
  //     }
  //     _errorMessage = e.toString().replaceFirst('Exception: ', '');
  //     rethrow;
  //   } finally {
  //     _isSubmitting = false;
  //     notifyListeners();
  //   }
  // }

  //dùng để gọi api load lại dữ liệu mới trong quá trình thêm/sửa/xóa thiết bị của phòng
  Future<void> reloadAll(BuildContext context) async {
    await fetchThietBiByPhongId();
    if (context.mounted) {
      context.read<ThietBiProvider>().fetchAll();
    }
  }
}
