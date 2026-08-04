import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/map_dio_error_to_message.dart';
import '../../../../models/DTO/HopDongDTO.dart';

class HopDongPageViewModel extends ChangeNotifier {
  final HopDongProvider hopDongProvider;
  HopDongPageViewModel({required this.hopDongProvider});

  HopDongState _hopDongState = HopDongInitial();
  HopDongState get hopDongState => _hopDongState;

  List<HopDongDTO> _listHopDong = [];

  List<HopDongDTO> get listHD => _listHopDong;
  List<HopDongDTO> get listHDHieuLuc =>
      _listHopDong.where((hd) => hd.trangThai == 1).toList();
  List<HopDongDTO> get listHDKhoiTao =>
      _listHopDong.where((hd) => hd.trangThai == 0).toList();
  List<HopDongDTO> get listHDKetThuc =>
      _listHopDong.where((hd) => hd.trangThai == 2).toList();

  int _currentFilter = -1;
  int get currentFilter => _currentFilter;

  Future<void> loadListHD() async {
    _hopDongState = HopDongLoading();
    notifyListeners();
    try {
      final result = await hopDongProvider.getListHD();
      result.sort((a, b) {
        return b.hopDongID.compareTo(a.hopDongID);
      });
      _listHopDong = result;
      _hopDongState = HopDongSuccess(_listHopDong);
    } catch (e) {
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if (e is DioException) {
        loi = mapDioErrorToMessage(e);
      } else {
        if (kDebugMode) {
          print("Lỗi logic hệ thôngs trong HopDongViewModel: $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _hopDongState = HopDongError(loi);
    } finally {
      notifyListeners();
    }
  }

  // Hàm Kiểm tra cache trước khi gọi API
  Future<void> loadList() async {
    if (hopDongProvider.listHD.isNotEmpty) {
      _listHopDong = hopDongProvider.listHD;
      _hopDongState = HopDongSuccess(_listHopDong);
      notifyListeners();
      return;
    }
    await loadListHD(); // Nếu chưa có dữ liệu thì gọi API để lấy mới
  }

  List<HopDongDTO> get listHDHienThi {
    switch (_currentFilter) {
      case 0:
        return listHDKhoiTao;
      case 1:
        return listHDHieuLuc;
      case 2:
        return listHDKetThuc;
      default:
        return listHD;
    }
  }

  void setFilter(int filterValue) {
    if (_currentFilter == filterValue) return;
    _currentFilter = filterValue;
    notifyListeners();
  }
}
