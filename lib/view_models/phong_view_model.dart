import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/repositories/phong_repository.dart';
import 'package:AppTroNhaToi/states/phong_save_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/phong.dart';

class PhongViewModel extends ChangeNotifier {
  final PhongRepository phongRepository = PhongRepository();
  List<ItemPhong> _listPhong = [];
  List<ItemPhong> get listPhong => _listPhong;

  List<ItemPhong> get listPhongTrong =>
      _listPhong.where((phong) => phong.trangThai == 0).toList();
  List<ItemPhong> get listPhongDangThue =>
      _listPhong.where((phong) => phong.trangThai == 1).toList();
  List<ItemPhong> get listPhongDangSua =>
      _listPhong.where((phong) => phong.trangThai == 2).toList();

  PhongSaveState _phongSaveState = PhongSaveInitial();
  PhongSaveState get phongSaveState => _phongSaveState;

  int _currentFilter = -1;
  int get currentFilter => _currentFilter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  int _idLoaiPhong = 0;
  int get idLoaiPhong => _idLoaiPhong;

  int _trangThai = 0;
  int get trangThai => _trangThai;

  String? _errTenPhong;
  String? get errTenPhong => _errTenPhong;

  Future<void> fetchPhong() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _listPhong = await phongRepository.getListPhong();
      if (kDebugMode) {
        print("List Phong lay được là: $_listPhong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi PhongViewModel $e");
      }
      _listPhong = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRoom(Phong room) async {
    try {
      _phongSaveState = PhongSaveLoading(); // Dùng lại State của SavePhong
      notifyListeners();
      final result = await phongRepository.updateRoom(room);
      if (result != null) {
        _phongSaveState = PhongSaveSuccess(result);
      } else {
        _phongSaveState = PhongSaveError(
          "Không nhận được phản hồi từ hệ thống!",
        );
      }
    } catch (e) {
      _phongSaveState = PhongSaveError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      notifyListeners();
    }
  }

  List<ItemPhong> get listPhongHienThi {
    switch (_currentFilter) {
      case 0:
        return listPhongTrong;
      case 1:
        return listPhongDangThue;
      case 2:
        return listPhongDangSua;
      default:
        return _listPhong;
    }
  }

  void setFilter(int filterValue) {
    if (_currentFilter == filterValue) return;
    _currentFilter = filterValue;
    notifyListeners();
  }

  void setIdLoaiPhong(int idLoaiPhong) {
    _idLoaiPhong = idLoaiPhong;
    notifyListeners();
  }

  void setTrangThai(int trangThai) {
    _trangThai = trangThai;
    notifyListeners();
  }

  Future<void> saveRoom() async {
    Phong p = Phong(
      phongID: 0,
      tenPhong: nameController.text.toString(),
      trangThai: _trangThai,
      maLoaiPhong: _idLoaiPhong,
      moTa: descController.text.toString(),
    );
    print("phong lay duoc la $p");
    try {
      _phongSaveState = PhongSaveLoading();
      notifyListeners();
      final result = await phongRepository.saveRoom(p);
      if (result != null) {
        print("Phòng Lưu được là $result");
        _phongSaveState = PhongSaveSuccess(result);
      } else {
        _phongSaveState = PhongSaveError(
          "Không nhận được phản hồi từ hệ thống!",
        );
      }
    } catch (e) {
      _phongSaveState = PhongSaveError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      notifyListeners();
    }
  }

  bool kiemTraDuLieu() {
    bool hopLe = true;
    if (nameController.text.trim().isEmpty) {
      _errTenPhong = "Vui lòng nhập tên phòng trọ!";
      hopLe = false;
    } else {
      _errTenPhong = null;
    }
    notifyListeners();
    return hopLe;
  }

  void addRoom(ItemPhong room) {
    _listPhong.insert(0, room);
    notifyListeners();
  }

  void updateRoomInList(ItemPhong updateRoom) {
    final index = _listPhong.indexWhere(
      (phong) => phong.phongId == updateRoom.phongId,
    );
    if (index != -1) {
      _listPhong[index] = updateRoom;
      notifyListeners();
    }
  }
}
