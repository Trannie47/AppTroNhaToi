import 'package:flutter/material.dart';
import 'package:AppTroNhaToi/Provider/loai_phong_provider.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';

class LoaiPhongPageViewModel extends ChangeNotifier {
  final LoaiPhongProvider _loaiPhongProvider;

  // Quản lý trạng thái load danh sách loại phòng chuẩn State của dự án
  LoaiphongState _loaiphongState = LoaiPhongLoading();
  LoaiphongState get loaiphongState => _loaiphongState;

  LoaiPhongPageViewModel(this._loaiPhongProvider);

  // Hàm khởi tạo gọi dữ liệu từ Provider
  Future<void> loadDataInitial() async {
    _loaiphongState = LoaiPhongLoading();
    notifyListeners();
    try {
      final danhSachLoai = await _loaiPhongProvider.getListLoaiPhong();
      _loaiphongState = LoaiPhongSuccess(danhSachLoai);
    } catch (e) {
      _loaiphongState = LoaiPhongError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      notifyListeners();
    }
  }
}