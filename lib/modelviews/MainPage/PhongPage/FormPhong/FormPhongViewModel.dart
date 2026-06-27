import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/loai_phong_provider.dart';
import '../../../../Provider/phong_provider.dart';
import '../../../../models/item_phong.dart';
import '../../../../states/loaiphong_state.dart';
import '../../../../states/phong_save_state.dart';

class FormPhongViewModel extends ChangeNotifier {
  final PhongProvider _phongProvider;
  final LoaiPhongProvider _loaiPhongProvider;
  final ItemPhong? room;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // Quản lý trạng thái Save/Update phòng
  PhongSaveState _phongSaveState = PhongSaveInitial();
  PhongSaveState get phongSaveState => _phongSaveState;

  //Quản lý trạng thái load phòng.
  LoaiphongState _loaiphongState = LoaiPhongLoading();
  LoaiphongState get loaiphongState => _loaiphongState;

  int _idLoaiPhong = 0;
  int get idLoaiPhong => _idLoaiPhong;

  int _trangThai = 0;
  int get trangThai => _trangThai;

  String? _errTenPhong;
  String? get errTenPhong => _errTenPhong;

  FormPhongViewModel(this._phongProvider, this._loaiPhongProvider, this.room);

  Future<void> loadDataInitial() async {
    _loaiphongState = LoaiPhongLoading();
    notifyListeners();
    try {
      final danhSachLoai = await _loaiPhongProvider.getListLoaiPhong();
      _loaiphongState = LoaiPhongSuccess(danhSachLoai);

      if (room != null) {
        // Nếu là edit thì đổ dữ liệu lên
        nameController.text = room!.tenPhong;
        descController.text = room!.moTa;
        _trangThai = room!.trangThai;
        _idLoaiPhong = room!.maLoaiPhong;
      } else {
        // Nếu là thêm mới thì lấy id đầu tiên của loại phòng làm mặc định
        if (danhSachLoai.isNotEmpty) {
          _idLoaiPhong = danhSachLoai[0].maLoaiPhong;
        }
      }
    } catch (e) {
      _loaiphongState = LoaiPhongError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      notifyListeners();
    }
  }
  void setIdLoaiPhong(int idLoaiPhong) {
    if (_idLoaiPhong == idLoaiPhong) return;
    _idLoaiPhong = idLoaiPhong;
    notifyListeners();
  }

  void setTrangThai(int trangThai) {
    if (_trangThai == trangThai) return;
    _trangThai = trangThai;
    notifyListeners();
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

  Future<void> saveRoom() async {
    Phong p = Phong(
      phongID: 0,
      tenPhong: nameController.text.trim(),
      trangThai: _trangThai,
      maLoaiPhong: _idLoaiPhong,
      moTa: descController.text.trim(),
    );
    try {
      _phongSaveState = PhongSaveLoading();
      notifyListeners();
      final result = await _phongProvider.saveRoom(p);
      if (result != null) {
        _phongSaveState = PhongSaveSuccess(result);
      } else {
        _phongSaveState = PhongSaveError("Không nhận được phản hồi từ hệ thống!");
      }
    } catch (e) {
      _phongSaveState = PhongSaveError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      notifyListeners();
    }
  }
  Future<void> updateRoom(Phong roomUpdate) async {
    try {
      _phongSaveState = PhongSaveLoading();
      notifyListeners();
      final result = await _phongProvider.updateRoom(roomUpdate);
      if (result != null) {
        _phongSaveState = PhongSaveSuccess(result);
      } else {
        _phongSaveState = PhongSaveError("Không nhận được phản hồi từ hệ thống!");
      }
    } catch (e) {
      _phongSaveState = PhongSaveError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      notifyListeners();
    }
  }

  Future<bool> saveRoomProcess() async {
    Phong p = Phong(
      phongID: 0,
      tenPhong: nameController.text.trim(),
      trangThai: _trangThai,
      maLoaiPhong: _idLoaiPhong,
      moTa: descController.text.trim(),
    );
    try {
      _phongSaveState = PhongSaveLoading();
      notifyListeners();

      final result = await _phongProvider.phongRepository.saveRoom(p);
      if (result != null) {
        _phongSaveState = PhongSaveSuccess(result);
        return true;
      }
      _phongSaveState = PhongSaveError("Không nhận được phản hồi từ hệ thống!");
      return false;
    } catch (e) {
      _phongSaveState = PhongSaveError(e.toString().replaceFirst('Exception: ', ''));
      return false;
    } finally {
      notifyListeners();
    }
  }
  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

}
