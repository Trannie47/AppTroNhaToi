import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:flutter/material.dart';

class FormLoaiPhongViewModel extends ChangeNotifier {
  late TextEditingController tenLoaiPhongController;
  late TextEditingController dienTichController;
  late TextEditingController soNguoiController;
  late TextEditingController giaTienController;

  bool isMayLanh = false;

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