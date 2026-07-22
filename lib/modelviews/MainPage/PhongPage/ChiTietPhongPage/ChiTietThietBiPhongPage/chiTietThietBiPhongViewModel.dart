import 'package:AppTroNhaToi/Provider/lap_rap_thietbi_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/thiet_bi_provider.dart';

class ChiTietThietBiPhongViewModel extends ChangeNotifier {
  final LapRapThietbiProvider _lapRapProvider;
  final int phongId;

  List<LapRap> _dsLapRap = [];
  List<LapRap> get dsLapRap => _dsLapRap;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ChiTietThietBiPhongViewModel(this._lapRapProvider, this.phongId);

  Future<void> fetchThietBiByPhongId() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dsLapRap = await _lapRapProvider.getThietBiByPhongId(phongId);
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietThietBiPhongViewModel.fetchThietBiByPhongId: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> taoLapRap({
    required int thietBiId,
    required int soLuong,
    required DateTime ngayLap,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _lapRapProvider.taoLapRap(
        phongId: phongId,
        thietBiId: thietBiId,
        soLuong: soLuong,
        ngayLap: ngayLap,
      );

      if (result != null) {
        // Tải lại danh sách thiết bị mới nhất sau khi thêm thành công
        await fetchThietBiByPhongId();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietThietBiPhongViewModel.taoLapRap: $e");
      }
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      rethrow; // Bắn lỗi ra để Dialog UI bắt hiện SnackBar đỏ
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> capNhatLapRap({
    required int id,
    required int soLuong,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _lapRapProvider.capNhatLapRap(
        id: id,
        soLuong: soLuong,
      );

      if (result != null) {
        await fetchThietBiByPhongId();
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ChiTietThietBiPhongViewModel.capNhatLapRap: $e");
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