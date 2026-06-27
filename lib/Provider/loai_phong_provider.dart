import 'package:flutter/foundation.dart';
import '../models/loaiphong.dart';
import '../repositories/loaiphong_repository.dart';

class LoaiPhongProvider extends ChangeNotifier {
  final LoaiPhongRepository _loaiPhongRepository = LoaiPhongRepository();

  List<LoaiPhong> _listLoaiPhong = [];
  List<LoaiPhong> get listLoaiPhong => _listLoaiPhong;

  Future<List<LoaiPhong>> getListLoaiPhong() async {
    try {
      _listLoaiPhong = await _loaiPhongRepository.getListLoaiPhong();
      notifyListeners();
      return _listLoaiPhong;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi LoaiPhongProvider: $e");
      }
      rethrow; // Bắn lỗi ra ngoài để ViewModel tự bắt và chuyển State
    }
  }
}