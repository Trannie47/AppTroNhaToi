import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/Provider/hang_hoa_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HangHoaFormViewModel extends ChangeNotifier {
  final HangHoaProvider _service;

  final txtTenHangHoa = TextEditingController();
  final txtGiaBan = TextEditingController();
  final txtGiaNhap = TextEditingController();
  final txtDonVi = TextEditingController();

  String? errTenHangHoa;
  String? errGiaBan;
  String? errGiaNhap;
  String? errDonVi;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // null = thêm mới, có giá trị = đang sửa
  HangHoa? _hangHoaDangSua;
  bool get isEditMode => _hangHoaDangSua != null;

  // format tiền khi sửa
  final NumberFormat formatter = NumberFormat('#,###', 'vi_VN');

  String formatGia(num? value) {
    if (value == null) return '';
    return formatter.format(value).replaceAll(',', '.');
  }

  HangHoaFormViewModel(this._service);

  // Gọi khi mở form ở chế độ sửa
  void loadDeSua(HangHoa hh) {
    _hangHoaDangSua = hh;
    txtTenHangHoa.text = hh.tenHangHoa ?? '';

    txtGiaBan.text = formatGia(hh.giaBan);
    txtGiaNhap.text = formatGia(hh.giaNhap);

    txtDonVi.text = hh.donViTinh ?? '';
    notifyListeners();
  }

  bool kiemTraDuLieu() {
    errTenHangHoa = null;
    errGiaBan = null;
    errGiaNhap = null;
    errDonVi = null;

    bool hopLe = true;

    if (txtTenHangHoa.text.trim().isEmpty) {
      errTenHangHoa = "Vui lòng nhập tên hàng hóa";
      hopLe = false;
    }

    double? giaBan = double.tryParse(txtGiaBan.text.replaceAll('.', ''));
    if (txtGiaBan.text.trim().isEmpty) {
      errGiaBan = "Vui lòng nhập giá bán";
      hopLe = false;
    } else if (giaBan == null || giaBan <= 0) {
      errGiaBan = "Giá bán phải lớn hơn 0";
      hopLe = false;
    }

    double? giaNhap = double.tryParse(txtGiaNhap.text.replaceAll('.', ''));
    if (txtGiaNhap.text.trim().isEmpty) {
      errGiaNhap = "Vui lòng nhập giá nhập";
      hopLe = false;
    } else if (giaNhap == null || giaNhap <= 0) {
      errGiaNhap = "Giá nhập phải lớn hơn 0";
      hopLe = false;
    }

    if (giaBan != null && giaNhap != null && giaBan < giaNhap) {
      errGiaBan = "Giá bán phải lớn hơn hoặc bằng giá nhập";
      hopLe = false;
    }

    if (txtDonVi.text.trim().isEmpty) {
      errDonVi = "Vui lòng nhập đơn vị";
      hopLe = false;
    } else if (!RegExp(r'^[a-zA-ZÀ-ỹ\s]+$').hasMatch(txtDonVi.text.trim())) {
      errDonVi = "Đơn vị chỉ được nhập chữ";
      hopLe = false;
    }

    notifyListeners();
    return hopLe;
  }

  Future<HangHoa?> luu() async {
    if (!kiemTraDuLieu()) return null;
    if (_isLoading) return null;

    _isLoading = true;
    notifyListeners();
    try {
      final hh = HangHoa(
        maHangHoa: _hangHoaDangSua?.maHangHoa,
        tenHangHoa: txtTenHangHoa.text.trim(),

        giaBan: double.tryParse(txtGiaBan.text.replaceAll('.', '').trim()),

        giaNhap: double.tryParse(txtGiaNhap.text.replaceAll('.', '').trim()),
        donViTinh: txtDonVi.text.trim(),
      );
      if (isEditMode) {
        final ok = await _service.capNhat(hh);
        return ok ? hh : null;
      } else {
        // them() trả về HangHoa? từ server
        final ok = await _service.them(hh);

        return ok;
      }
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> xoa() async {
    if (_hangHoaDangSua == null) return false;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      return await _service.xoa(_hangHoaDangSua!.maHangHoa!);
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _hangHoaDangSua = null;
    txtTenHangHoa.clear();
    txtGiaBan.clear();
    txtGiaNhap.clear();
    txtDonVi.clear();
    errTenHangHoa = null;
    errGiaBan = null;
    errGiaNhap = null;
    errDonVi = null;
    notifyListeners();
  }

  @override
  void dispose() {
    txtTenHangHoa.dispose();
    txtGiaBan.dispose();
    txtGiaNhap.dispose();
    txtDonVi.dispose();
    super.dispose();
  }
}
