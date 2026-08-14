import 'package:AppTroNhaToi/models/loai_phong.dart';
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
  final ItemPhongModel? room;

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

  FormPhongViewModel(this._phongProvider, this._loaiPhongProvider, this.room) {
    nameController.addListener(_onNameChanged);
  }

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
      _loaiphongState = LoaiPhongError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      notifyListeners();
    }
  }

  void reloadLoaiPhongAfterAddition(int newId) {
    _loaiphongState = LoaiPhongSuccess(_loaiPhongProvider.listLoaiPhong);
    _idLoaiPhong = newId;
    notifyListeners();
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

  String _chuanHoaTenPhong(String input) {
    String text = input.trim().toLowerCase();
    //Lọc bỏ các biến thể chữ "phòng" hoặc "phong" ở đầu chuỗi
    text = text.replaceFirst(RegExp(r'^(phòng|phong)\s*'), '');

    return text.trim();
  }

  bool kiemTraDuLieu() {
    bool hopLe = true;
    String rawInput = nameController.text;

    if (rawInput.trim().isEmpty) {
      _errTenPhong = "Vui lòng nhập tên phòng trọ!";
      hopLe = false;
    } else {
      final tenPhong = _chuanHoaTenPhong(rawInput);

      if (tenPhong.isEmpty) {
        _errTenPhong = "Tên phòng không hợp lệ!";
        hopLe = false;
        notifyListeners();
        return hopLe;
      }

      final danhSachPhongHienTai = _phongProvider.listPhong;

      bool isTrungTen = false;
      if (room != null) {
        isTrungTen = danhSachPhongHienTai.any(
          (p) =>
              _chuanHoaTenPhong(p.tenPhong).toLowerCase() ==
                  tenPhong.toLowerCase() &&
              p.phongId != room!.phongId,
        );
      } else {
        isTrungTen = danhSachPhongHienTai.any(
          (p) =>
              _chuanHoaTenPhong(p.tenPhong).toLowerCase() ==
              tenPhong.toLowerCase(),
        );
      }

      if (isTrungTen) {
        _errTenPhong = "Tên phòng này đã tồn tại, vui lòng chọn tên khác!";
        hopLe = false;
      } else {
        _errTenPhong = null;
      }
    }

    notifyListeners();
    return hopLe;
  }

  Future<void> saveRoom() async {
    final tenChuanHoa = _chuanHoaTenPhong(nameController.text);
    Phong p = Phong(
      phongID: 0,
      tenPhong: tenChuanHoa,
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

  Future<void> updateRoom(Phong roomUpdate) async {
    try {
      _phongSaveState = PhongSaveLoading();
      notifyListeners();
      final result = await _phongProvider.updateRoom(roomUpdate);
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
      _phongSaveState = PhongSaveError(
        e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      notifyListeners();
    }
  }

  void _onNameChanged() {
    if (_errTenPhong != null) {
      _errTenPhong = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
}
