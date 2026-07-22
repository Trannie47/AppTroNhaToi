import 'package:flutter/material.dart';
import '../../../../Provider/nguoi_luu_tru_tam_thoi_provider.dart';
import '../../../../models/hop_dong.dart';
import '../../../../models/nguoi_luu_tru_tam_thoi.dart';

class NguoiLuuTruTamThoiFormViewModel extends ChangeNotifier {
  final NguoiLuuTruTamThoiProvider _provider;

  final hoTenController = TextEditingController();
  final moiQuanHeController = TextEditingController();
  final cccdController = TextEditingController();
  final sdtController = TextEditingController();

  int? selectedPhongId;
  DateTime? ngayDen;
  DateTime? ngayVe;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NguoiLuuTruTamThoiFormViewModel(this._provider);

  // Khởi tạo dữ liệu ban đầu cho form
  void initData(NguoiLuuTruTamThoi? itemEdit, List<HopDong> dsHopDong) {
    hoTenController.text = itemEdit?.hoTen ?? '';
    moiQuanHeController.text = itemEdit?.moiQuanHe ?? '';
    cccdController.text = itemEdit?.cccd ?? '';
    sdtController.text = itemEdit?.sdt ?? '';

    ngayDen = itemEdit?.ngayDen ?? DateTime.now();
    ngayVe = itemEdit?.ngayVe ?? DateTime.now().add(const Duration(days: 3));

    if (itemEdit != null) {
      selectedPhongId = itemEdit.phongId;
    } else {
      if (dsHopDong.length == 1) {
        selectedPhongId = dsHopDong.first.phongID;
      }
    }
  }

  void setPhongId(int? id) {
    selectedPhongId = id;
    notifyListeners();
  }

  void setNgayDen(DateTime date) {
    ngayDen = date;
    if (ngayVe != null && !ngayVe!.isAfter(ngayDen!)) {
      ngayVe = ngayDen!.add(const Duration(days: 1));
    }
    notifyListeners();
  }

  void setNgayVe(DateTime date) {
    ngayVe = date;
    notifyListeners();
  }

  String? validateHoTen(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Vui lòng nhập họ và tên";
    }
    return null;
  }

  String? validateMoiQuanHe(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Vui lòng nhập mối quan hệ";
    }
    return null;
  }

  String? validateCccd(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Vui lòng nhập số CCCD";
    }
    final cccdRegex = RegExp(r'^\d{12}$');
    if (!cccdRegex.hasMatch(val.trim())) {
      return "Số CCCD phải gồm đúng 12 chữ số";
    }
    return null;
  }

  String? validateSdt(String? val) {
    if (val == null || val.trim().isEmpty) {
      return "Vui lòng nhập số điện thoại";
    }
    final phoneRegex = RegExp(r'^0\d{9}$');
    if (!phoneRegex.hasMatch(val.trim())) {
      return "SĐT phải gồm 10 chữ số và bắt đầu bằng số 0";
    }
    return null;
  }

  String? validatePhong(int? val) {
    if (val == null) {
      return "Vui lòng chọn phòng lưu trú";
    }
    return null;
  }

  String? validateDates() {
    if (ngayDen == null) return "Vui lòng chọn ngày đến";
    if (ngayVe == null) return "Vui lòng chọn ngày về";

    final dateDen = DateTime(ngayDen!.year, ngayDen!.month, ngayDen!.day);
    final dateVe = DateTime(ngayVe!.year, ngayVe!.month, ngayVe!.day);

    if (!dateVe.isAfter(dateDen)) {
      return "Ngày về phải sau (lớn hơn) ngày đến";
    }
    return null;
  }

  Future<bool> saveForm({
    required int idnt,
    NguoiLuuTruTamThoi? itemEdit,
  }) async {
    final dateError = validateDates();
    if (dateError != null) {
      throw Exception(dateError);
    }

    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    try {
      if (itemEdit != null) {
        final updateData = itemEdit.copyWith(
          phongId: selectedPhongId,
          hoTen: hoTenController.text.trim(),
          moiQuanHe: moiQuanHeController.text.trim(),
          cccd: cccdController.text.trim(),
          sdt: sdtController.text.trim(),
          ngayDen: ngayDen,
          ngayVe: ngayVe,
        );
        await _provider.updateLuuTru(updateData);
      } else {
        final newItem = NguoiLuuTruTamThoi(
          idnt: idnt,
          phongId: selectedPhongId,
          hoTen: hoTenController.text.trim(),
          moiQuanHe: moiQuanHeController.text.trim(),
          cccd: cccdController.text.trim(),
          sdt: sdtController.text.trim(),
          ngayDen: ngayDen,
          ngayVe: ngayVe,
        );
        await _provider.createNguoiLuuTru(newItem);
      }
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    hoTenController.dispose();
    moiQuanHeController.dispose();
    cccdController.dispose();
    sdtController.dispose();
    super.dispose();
  }
}