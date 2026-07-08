import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../core/utils/map_dio_error_to_message.dart';
import '../../../../repositories/hopdong_repository.dart';
import '../../../../states/chi_tiet_nguoi_thue_state.dart';

class ChiTietNguoiThuePageViewModel extends ChangeNotifier {
  final NguoiThueProvider _service;
  final HopdongRepository _hopDongRepository = HopdongRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ChiTietNguoiThueState _chiTietNguoiThueState = ChiTietNguoiThueLoading();
  ChiTietNguoiThueState get chiTietNguoiThueState => _chiTietNguoiThueState;

  ChiTietNguoiThuePageViewModel(this._service);

  //Lấy ds phòng của ng thuê đó
  Future<void> fetchRoomByNguoiThue(int idnt) async {
    _chiTietNguoiThueState = ChiTietNguoiThueLoading();
    notifyListeners();
    try {
      final result = await _hopDongRepository.fetchRoomByNguoiThue(idnt);
      _chiTietNguoiThueState = ChiTietNguoiThueSuccess(result);
    } catch (e) {
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if(e is DioException){
        loi= mapDioErrorToMessage(e);
      }else{
        if (kDebugMode) {
          print("Lỗi logic hệ thôngs trong HopDongViewModel: $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _chiTietNguoiThueState = ChiTietNguoithueError(loi);
    } finally {
      notifyListeners();
    }
  }


  Future<bool> xoaNguoiThue(int idnt) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _service.xoa(idnt);
      return result;
    } catch (e) {
      print("Loi viemodel khi xoa $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
