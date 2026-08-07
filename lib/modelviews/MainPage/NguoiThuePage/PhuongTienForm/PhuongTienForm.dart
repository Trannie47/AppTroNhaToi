import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';
import 'package:AppTroNhaToi/Provider/phuong_tien_provider.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhuongTienFormViewModel extends ChangeNotifier {
  final PhuongTien? phuongTienSua;

  final txtHangXe = TextEditingController();
  final txtBienSo = TextEditingController();
  final txtMauSac = TextEditingController();
  final txtGiaGui = TextEditingController();

  int loaiXe = 0; // 0: Xe máy, 1: Ô tô, 2: Xe đạp
  int? selectedPhongId;
  String? selectedTenPhong;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isEditing => phuongTienSua != null;

  // Các biến quản lý lỗi đỏ cho từng trường
  String? errHangXe;
  String? errBienSo;
  String? errMauSac;
  String? errGiaGui;

  PhuongTienFormViewModel({this.phuongTienSua}) {
    if (phuongTienSua != null) {
      txtHangXe.text = phuongTienSua!.hangXe ?? "";
      txtBienSo.text = phuongTienSua!.bienSo ?? "";
      txtMauSac.text = phuongTienSua!.mauSac ?? "";
      final gia = phuongTienSua!.giaGui ?? 0;
      txtGiaGui.text = gia > 0
          ? NumberFormat('#,###', 'vi_VN').format(gia).replaceAll(',', '.')
          : "";
      loaiXe = phuongTienSua!.loaiXe;
      selectedPhongId = phuongTienSua!.phongId;
      selectedTenPhong = phuongTienSua!.tenPhong;
    }

    txtHangXe.addListener(() {
      if (errHangXe != null) {
        errHangXe = null;
        notifyListeners();
      }
    });
    txtBienSo.addListener(() {
      if (errBienSo != null) {
        errBienSo = null;
        notifyListeners();
      }
    });
    txtMauSac.addListener(() {
      if (errMauSac != null) {
        errMauSac = null;
        notifyListeners();
      }
    });
    txtGiaGui.addListener(() {
      if (errGiaGui != null) {
        errGiaGui = null;
        notifyListeners();
      }
    });
  }

  Future<void> changeLoaiXe(
    int value, {
    required CauHinhGiaProvider provider,
  }) async {
    loaiXe = value;
    if (loaiXe == 2 && errBienSo != null) {
      errBienSo = null;
    }
    notifyListeners();

    final giaMacDinh = await provider.getGiaXeMacDinh(value);
    if (giaMacDinh != null) {
      txtGiaGui.text = giaMacDinh > 0
          ? NumberFormat(
              '#,###',
              'vi_VN',
            ).format(giaMacDinh).replaceAll(',', '.')
          : "";
      errGiaGui = null;
      notifyListeners();
    }
  }

  void selectPhong(int? pId, String? tPhong) {
    selectedPhongId = pId;
    selectedTenPhong = tPhong;
    notifyListeners();
  }

  bool validateAll() {
    errHangXe = txtHangXe.text.trim().isEmpty ? "Vui lòng nhập hãng xe" : null;
    errMauSac = txtMauSac.text.trim().isEmpty
        ? "Vui lòng nhập màu sắc xe"
        : null;

    final bienSo = txtBienSo.text.trim();
    if (loaiXe != 2) {
      if (bienSo.isEmpty) {
        errBienSo = "Vui lòng nhập biển số xe";
      } else if (bienSo.length > 10) {
        errBienSo = "Biển số không được vượt quá 10 ký tự";
      } else {
        errBienSo = null;
      }
    } else {
      if (bienSo.isNotEmpty && bienSo.length > 10) {
        errBienSo = "Biển số không được vượt quá 15 ký tự";
      } else {
        errBienSo = null;
      }
    }

    final giaGuiStr = txtGiaGui.text.trim().replaceAll('.', '');
    if (giaGuiStr.isEmpty) {
      errGiaGui = "Vui lòng nhập giá gửi xe";
    } else {
      final val = double.tryParse(giaGuiStr);
      if (val == null || val < 0) {
        errGiaGui = "Giá gửi xe phải là số hợp lệ (≥ 0)";
      } else {
        errGiaGui = null;
      }
    }
    notifyListeners();

    return errHangXe == null &&
        errBienSo == null &&
        errMauSac == null &&
        errGiaGui == null;
  }

  Future<bool> savePhuongTien({
    required PhuongTienProvider provider,
    required int idnt,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final rawGiaGui = txtGiaGui.text.trim().replaceAll('.', '');
    final giaGuiVal = double.tryParse(rawGiaGui) ?? 0.0;

    final xeData = PhuongTien(
      ID: phuongTienSua?.ID ?? 0,
      bienSo: txtBienSo.text.trim(),
      hangXe: txtHangXe.text.trim(),
      mauSac: txtMauSac.text.trim(),
      giaGui: giaGuiVal,
      loaiXe: loaiXe,
      idnt: idnt,
      phongId: selectedPhongId,
      tenPhong: selectedTenPhong,
    );

    bool success = false;
    if (isEditing) {
      success = await provider.updatePhuongTien(phuongTienSua!.ID, xeData);
    } else {
      success = await provider.createPhuongTien(xeData);
    }

    if (!success) {
      _errorMessage =
          provider.errorMessage ?? "Đã có lỗi xảy ra, vui lòng thử lại!";
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  @override
  void dispose() {
    txtHangXe.dispose();
    txtBienSo.dispose();
    txtMauSac.dispose();
    txtGiaGui.dispose();
    super.dispose();
  }
}
