import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/repositories/loaiphong_repository.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LoaiPhongViewModel extends ChangeNotifier {
  final LoaiPhongRepository loaiPhongRepository = LoaiPhongRepository();

  LoaiphongState _loaiphongState = LoaiPhongLoading();
  LoaiphongState get loaiphongState => _loaiphongState;
  List<LoaiPhong> listLoaiPhong = [];
  Future<void> getListLoaiPhong() async {
    try {
      _loaiphongState = LoaiPhongLoading();
      notifyListeners();
      listLoaiPhong = await loaiPhongRepository.getListLoaiPhong();
      _loaiphongState = LoaiPhongSuccess(listLoaiPhong);
      if (kDebugMode) {
        print("DS loại phòng lấy được là $listLoaiPhong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LoaiPhongViewModel $e");
      }
      _loaiphongState = LoaiPhongError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      notifyListeners();
    }
  }
}
