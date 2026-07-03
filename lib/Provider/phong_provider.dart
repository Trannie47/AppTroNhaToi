import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/repositories/phong_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/item_phong.dart';

class PhongProvider extends ChangeNotifier{
  final PhongRepository phongRepository= PhongRepository();
  List<ItemPhong> _listPhong = [];
  List<ItemPhong> get listPhong => _listPhong;

  List<ItemPhong> get listPhongTrong => _listPhong.where((phong) => phong.trangThai == 0).toList();
  List<ItemPhong> get listPhongDangThue => _listPhong.where((phong) => phong.trangThai == 1).toList();
  List<ItemPhong> get listPhongDangSua => _listPhong.where((phong) => phong.trangThai == 2).toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPhong() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _listPhong = await phongRepository.fetchPhong();
    } catch (e) {
      _listPhong = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Phong?> saveRoom(Phong phong) async {
    try {
      final result = await phongRepository.saveRoom(phong);
      if (result != null) {
        return result;
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Lỗi saveRoom tại Provider: $e");
      rethrow;
    }
  }

  Future<Phong?> updateRoom(Phong phong) async {
    try {
      final result = await phongRepository.updateRoom(phong);
      if (result != null) {
        return result;
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Lỗi updateRoom tại Provider: $e");
      rethrow;
    }
  }
  Future<Phong?> removePhong(int idPhong)async{
    try{
      final result=await phongRepository.remove(idPhong);
      if(result!=null){
        return result;
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Lỗi removePhong tại Provider: $e");
      rethrow;
    }
  }

  //thêm local vào ds sau khi khi thực hiện thao tác thêm mà ko cần fetch lại api
  void addRoom(ItemPhong room) {
    _listPhong.insert(0, room);
    notifyListeners();
  }
  // Cập nhật lại item trong list
  void updateRoomInList(ItemPhong updateRoom) {
    final index = _listPhong.indexWhere((phong) => phong.phongId == updateRoom.phongId);
    if (index != -1) {
      _listPhong[index] = updateRoom;
      notifyListeners();
    }
  }
  //remove phongf khởi list mà ko phải fetch lại api
  void removeRoomFromList(int idPhong) {
    _listPhong.removeWhere((phong) => phong.phongId == idPhong);
    notifyListeners();
  }
}