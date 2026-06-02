import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:flutter/material.dart';

class NguoiThueFormViewModel extends ChangeNotifier {
  final TextEditingController txtSearch = TextEditingController();
  final TextEditingController txtHoTen = TextEditingController();
  final TextEditingController txtSDT = TextEditingController();
  final TextEditingController txtCCCD = TextEditingController();
  final TextEditingController txtNgaySinh = TextEditingController();
  final TextEditingController txtQueQuan = TextEditingController();
  final TextEditingController txtPhong = TextEditingController();
  final TextEditingController txtVaiTro = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();

  bool? gioiTinh;
  late NguoiThue nguoiThue;

  NguoiThueFormViewModel({
    NguoiThue? nguoiThueInput,
  }) {
    if (nguoiThueInput != null) {
      nguoiThue = nguoiThueInput;

      txtHoTen.text = nguoiThue.hoTen ?? "";
      txtSDT.text = nguoiThue.sdt ?? "";
      txtCCCD.text = nguoiThue.cccd ?? "";

      txtNgaySinh.text =
          "${nguoiThue.ngaySinh?.day.toString().padLeft(2, '0')}/"
          "${nguoiThue.ngaySinh?.month.toString().padLeft(2, '0')}/"
          "${nguoiThue.ngaySinh?.year}";

      txtQueQuan.text = nguoiThue.queQuan ?? "";
      txtGhiChu.text = nguoiThue.ghiChu ?? "";
      gioiTinh = nguoiThue.gioiTinh;
    }
  }

  void setGioiTinh(bool? value) {
    gioiTinh = value;
    notifyListeners();
  }

  void parseCCCDQR(String raw) {
    final parts = raw.split('|');

    if (parts.length < 6) return;

    txtCCCD.text = parts[0].trim();

    txtHoTen.text = parts[2].trim();

    final dob = parts[3].trim();

    if (dob.length == 8) {
      txtNgaySinh.text =
          "${dob.substring(0, 2)}/${dob.substring(2, 4)}/${dob.substring(4, 8)}";
    }

    final gender = parts[4].trim().toLowerCase();

    gioiTinh = gender == "nam";

    txtQueQuan.text = parts[5].trim();

    notifyListeners();
  }

  @override
  void dispose() {
    txtSearch.dispose();
    txtHoTen.dispose();
    txtSDT.dispose();
    txtCCCD.dispose();
    txtNgaySinh.dispose();
    txtQueQuan.dispose();
    txtPhong.dispose();
    txtVaiTro.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}