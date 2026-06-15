import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:flutter/material.dart';

class FormLoaiPhongViewModel extends ChangeNotifier {
  late TextEditingController tenLoaiPhongController;
  late TextEditingController dienTichController;
  late TextEditingController soNguoiController;
  late TextEditingController giaTienController;

  bool isMayLanh = false;
  String? errTenLoaiPhong;
  String? errDienTich;
  String? errSoNguoi;
  String? errGiaTien;

  FormLoaiPhongViewModel(LoaiPhong? loaiPhong) {
    tenLoaiPhongController = TextEditingController(
      text: loaiPhong?.tenLoaiPhong ?? "",
    );
    dienTichController = TextEditingController(
      text: loaiPhong?.dienTich.toString() ?? "",
    );
    soNguoiController = TextEditingController(
      text: loaiPhong?.soNguoiToiDa.toString() ?? "",
    );
    giaTienController = TextEditingController(
      text: loaiPhong?.giaTien.toStringAsFixed(0) ?? "",
    );
    isMayLanh = loaiPhong?.isMayLanh ?? false;
  }

  void toggleMayLanh(bool value) {
    isMayLanh = value;
    notifyListeners();
  }

  void clear() {
    tenLoaiPhongController.clear();
    dienTichController.clear();
    soNguoiController.clear();
    giaTienController.clear();

    isMayLanh = false;

    errTenLoaiPhong = null;
    errDienTich = null;
    errSoNguoi = null;
    errGiaTien = null;

    notifyListeners();
  }

  bool kiemTraDuLieu() {

    errTenLoaiPhong = null;
    errDienTich = null;
    errSoNguoi = null;
    errGiaTien = null;

    bool hopLe = true;

    if (tenLoaiPhongController.text.trim().isEmpty) {

      errTenLoaiPhong = "Vui lòng nhập tên loại phòng";

      hopLe = false;
    }

    if (dienTichController.text.trim().isEmpty) {

      errDienTich = "Vui lòng nhập diện tích";

      hopLe = false;
    }
    else {

      double? dienTich =
      double.tryParse(dienTichController.text);

      if (dienTich == null || dienTich <= 0) {

        errDienTich = "Diện tích phải lớn hơn 0";

        hopLe = false;
      }
    }

    if (soNguoiController.text.trim().isEmpty) {

      errSoNguoi = "Vui lòng nhập số người tối đa";

      hopLe = false;
    }
    else {

      int? soNguoi =
      int.tryParse(soNguoiController.text);

      if (soNguoi == null || soNguoi <= 0) {

        errSoNguoi = "Số người phải lớn hơn 0";

        hopLe = false;
      }
    }

    if (giaTienController.text.trim().isEmpty) {

      errGiaTien = "Vui lòng nhập giá thuê";

      hopLe = false;
    }
    else {

      double? giaTien =
      double.tryParse(giaTienController.text);

      if (giaTien == null || giaTien <= 0) {

        errGiaTien = "Giá thuê phải lớn hơn 0";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }

  LoaiPhong buildLoaiPhong(int maLoaiPhong) {
    return LoaiPhong(
      tenLoaiPhong: tenLoaiPhongController.text,
      dienTich: double.tryParse(dienTichController.text) ?? 0,
      soNguoiToiDa: int.tryParse(soNguoiController.text) ?? 0,
      giaTien: double.tryParse(giaTienController.text) ?? 0,
      isMayLanh: isMayLanh,
      maLoaiPhong: maLoaiPhong,
    );
  }

  @override
  void dispose() {
    tenLoaiPhongController.dispose();
    dienTichController.dispose();
    soNguoiController.dispose();
    giaTienController.dispose();
    super.dispose();
  }
}