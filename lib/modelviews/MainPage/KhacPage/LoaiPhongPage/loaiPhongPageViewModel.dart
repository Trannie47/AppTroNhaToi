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
      _loaiphongState = LoaiPhongError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<String?> deleteLoaiPhongProcess(int maLoaiPhong) async {
    try {
      await _loaiPhongProvider.deleteLoaiPhong(maLoaiPhong);

      // Nếu thành công, cập nhật ngay danh sách local trong State của ViewModel để UI biến mất dòng đó
      if (_loaiphongState is LoaiPhongSuccess) {
        final hienTai = (_loaiphongState as LoaiPhongSuccess).listLoaiPhong;
        hienTai.removeWhere((element) => element.maLoaiPhong == maLoaiPhong);
        _loaiphongState = LoaiPhongSuccess(hienTai);
        notifyListeners();
      }
      return null; // Trả về null nghĩa là ẩn thành công không có lỗi
    } catch (e) {
      // Nếu Backend chặn (do có phòng liên kết), trả về nội dung lỗi hiển thị lên SnackBar
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
