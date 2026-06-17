import 'package:flutter/material.dart';

class HangHoaFormViewModel extends ChangeNotifier {
  final txtTenHangHoa = TextEditingController();
  final txtGiaBan = TextEditingController();
  final txtGiaNhap = TextEditingController();
  final txtSoLuong = TextEditingController();
  final txtDonVi = TextEditingController();

  String? errTenHangHoa;
  String? errGiaBan;
  String? errGiaNhap;
  String? errSoLuong;
  String? errDonVi;

  bool kiemTraDuLieu() {
    errTenHangHoa = null;
    errGiaBan = null;
    errGiaNhap = null;
    errSoLuong = null;
    errDonVi = null;

    bool hopLe = true;

    if (txtTenHangHoa.text.trim().isEmpty) {
      errTenHangHoa = "Vui lòng nhập tên hàng hóa";
      hopLe = false;
    }

    double? giaBan = double.tryParse(txtGiaBan.text);

    if (txtGiaBan.text.trim().isEmpty) {
      errGiaBan = "Vui lòng nhập giá bán";
      hopLe = false;
    } else if (giaBan == null || giaBan <= 0) {
      errGiaBan = "Giá bán phải lớn hơn 0";
      hopLe = false;
    }

    double? giaNhap = double.tryParse(txtGiaNhap.text);

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

    int? soLuong = int.tryParse(txtSoLuong.text);

    if (txtSoLuong.text.trim().isEmpty) {
      errSoLuong = "Vui lòng nhập số lượng";
      hopLe = false;
    } else if (soLuong == null || soLuong <= 0) {
      errSoLuong = "Số lượng phải là số nguyên dương";
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

  @override
  void dispose() {
    txtTenHangHoa.dispose();
    txtGiaBan.dispose();
    txtGiaNhap.dispose();
    txtSoLuong.dispose();
    txtDonVi.dispose();
    super.dispose();
  }
}
