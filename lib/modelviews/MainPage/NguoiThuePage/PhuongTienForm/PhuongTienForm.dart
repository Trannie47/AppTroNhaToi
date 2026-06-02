import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

class PhuongTienFormViewModel extends ChangeNotifier {
  final txtHangXe = TextEditingController();
  final txtBienSo = TextEditingController();
  final txtMauSac = TextEditingController();
  final txtGiaGui = TextEditingController();

  int loaiXe = 0;

  PhuongTienFormViewModel({
    PhuongTien? phuongTienSua,
  }) {
    if (phuongTienSua != null) {
      txtHangXe.text = phuongTienSua.hangXe ?? "";
      txtBienSo.text = phuongTienSua.bienSo ?? "";
      txtMauSac.text = phuongTienSua.mauSac ?? "";
      txtGiaGui.text = (phuongTienSua.giaGui ?? 0).toString();
      loaiXe = phuongTienSua.loaiXe ?? 0;
    }
  }

  void changeLoaiXe(int value) {
    loaiXe = value;
    notifyListeners();
  }

  PhuongTien buildPhuongTien(int? idnt) {
    return PhuongTien(
      ID: DateTime.now().millisecondsSinceEpoch,
      bienSo: txtBienSo.text,
      hangXe: txtHangXe.text,
      mauSac: txtMauSac.text,
      giaGui: double.tryParse(txtGiaGui.text),
      loaiXe: loaiXe,
      idnt: idnt,
    );
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