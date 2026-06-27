import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/nguoi_thue_provider.dart';
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
      _chiTietNguoiThueState = ChiTietNguoithueError(e.toString());
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
