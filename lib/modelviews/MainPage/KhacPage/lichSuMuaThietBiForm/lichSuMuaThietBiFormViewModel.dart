import 'package:AppTroNhaToi/Provider/lich_su_Them_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class LichSuMuaThietBiFormViewModel extends ChangeNotifier {
  final LichSuMuaThietBiProvider _service;
  final ThietBi thietBi;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  LichSuMuaThietBi? _dangSua;

  bool get isEditMode => _dangSua != null;

  final TextEditingController txtSoLuong = TextEditingController();
  final TextEditingController txtDonGia = TextEditingController();
  final TextEditingController txtNgayMua = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();

  DateTime? ngayMuaChon;

  String? errSoLuong;
  String? errDonGia;
  String? errNgayMua;

  LichSuMuaThietBiFormViewModel(
    this._service, {
    required this.thietBi,
    LichSuMuaThietBi? lichSuInput,
  }) {
    if (lichSuInput != null) {
      loadDeSua(lichSuInput);
    }
  }

  void loadDeSua(LichSuMuaThietBi lichSu) {
    _dangSua = lichSu;

    txtSoLuong.text = lichSu.soLuong?.toString() ?? "";
    txtDonGia.text = lichSu.donGia?.toStringAsFixed(0) ?? "";
    txtGhiChu.text = lichSu.ghiChu ?? "";

    ngayMuaChon = lichSu.ngayMua;

    if (ngayMuaChon != null) {
      txtNgayMua.text = formatDate(ngayMuaChon!);
    }

    notifyListeners();
  }

  bool kiemTraDuLieu() {
    errSoLuong = null;
    errDonGia = null;
    errNgayMua = null;

    bool hopLe = true;

    // Số lượng
    if (txtSoLuong.text.trim().isEmpty) {
      errSoLuong = "Vui lòng nhập số lượng";
      hopLe = false;
    } else {
      final soLuong = int.tryParse(txtSoLuong.text.trim());

      if (soLuong == null || soLuong <= 0) {
        errSoLuong = "Số lượng phải lớn hơn 0";
        hopLe = false;
      }
    }

    // Đơn giá
    if (txtDonGia.text.trim().isEmpty) {
      errDonGia = "Vui lòng nhập đơn giá";
      hopLe = false;
    } else {
      final donGia = double.tryParse(txtDonGia.text.trim());

      if (donGia == null || donGia < 0) {
        errDonGia = "Đơn giá không được âm";
        hopLe = false;
      }
    }

    if (ngayMuaChon == null) {
      errNgayMua = "Vui lòng chọn ngày mua";
      hopLe = false;
    } else if (ngayMuaChon!.isAfter(DateTime.now())) {
      errNgayMua = "Ngày mua không được lớn hơn ngày hiện tại";
      hopLe = false;
    }
    notifyListeners();
    return hopLe;
  }

  Future<LichSuMuaThietBi?> luu() async {
    if (!kiemTraDuLieu()) return null;
    if (_isLoading) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final lichSu = LichSuMuaThietBi(
        id: _dangSua?.id,
        thietBiID: thietBi.thietBiID,
        soLuong: int.tryParse(txtSoLuong.text.trim()),
        donGia: double.tryParse(txtDonGia.text.trim()),
        ngayMua: ngayMuaChon,
        ghiChu: txtGhiChu.text.trim().isEmpty ? null : txtGhiChu.text.trim(),
      );

      if (isEditMode) {
        final ok = await _service.capNhat(lichSu);

        return ok ? lichSu : null;
      } else {
        final result = await _service.them(lichSu);

        return result;
      }
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> xoa() async {
    if (_dangSua == null) return false;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      return await _service.xoa(_dangSua!.id!, thietBi.thietBiID!);
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _dangSua = null;

    txtSoLuong.clear();
    txtDonGia.clear();
    txtNgayMua.clear();
    txtGhiChu.clear();

    ngayMuaChon = null;

    errSoLuong = null;
    errDonGia = null;
    errNgayMua = null;

    notifyListeners();
  }

  Future<void> chonNgayMua(BuildContext context) async {
    final now = DateTime.now();

    final firstDay = DateTime(now.year, now.month, 1);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: ngayMuaChon ?? now,
      firstDate: firstDay,// Không được chọn các tháng trước vì dữ liệu đã chốt thống kê
      lastDate: now, // Chỉ được chọn đến ngày hiện tại
    );

    if (pickedDate != null) {
      ngayMuaChon = pickedDate;
      txtNgayMua.text = formatDate(pickedDate);

      notifyListeners();
    }
  }


  @override
  void dispose() {
    txtSoLuong.dispose();
    txtDonGia.dispose();
    txtNgayMua.dispose();
    txtGhiChu.dispose();

    super.dispose();
  }
}
