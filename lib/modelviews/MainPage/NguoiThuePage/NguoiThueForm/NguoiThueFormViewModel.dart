import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/repositories/nguoithue_repository.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/nguoi_thue_provider.dart';

class NguoiThueFormViewModel extends ChangeNotifier {
  final NguoiThueProvider _service;
  final TextEditingController txtSearch = TextEditingController();
  final TextEditingController txtHoTen = TextEditingController();
  final TextEditingController txtSDT = TextEditingController();
  final TextEditingController txtCCCD = TextEditingController();
  final TextEditingController txtNgaySinh = TextEditingController();
  final TextEditingController txtQueQuan = TextEditingController();
  final TextEditingController txtPhong = TextEditingController();
  final TextEditingController txtVaiTro = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();
  final NguoithueRepository repository = NguoithueRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? gioiTinh;
  late NguoiThue nguoiThue;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NguoiThueFormViewModel(this._service);
  Future<bool> luuNguoiThue() async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    try {
      DateTime? ngaySinhParsed;
      if (txtNgaySinh.text.isNotEmpty) {
        List<String> arr = txtNgaySinh.text.split('/');
        if (arr.length == 3) {
          ngaySinhParsed = DateTime(
            int.parse(arr[2]), // Năm
            int.parse(arr[1]), // Tháng
            int.parse(arr[0]), // Ngày
          );
        }
      }

      NguoiThue nguoiThue = NguoiThue(
        hoTen: txtHoTen.text.trim(),
        cccd: txtCCCD.text.trim(),
        sdt: txtSDT.text.trim(),
        ngaySinh: ngaySinhParsed,
        gioiTinh: gioiTinh ?? true,
        ghiChu: txtGhiChu.text.trim(),
        queQuan: txtQueQuan.text.trim(),
      );
      bool result = await _service.them(nguoiThue);
      if (result) {
        clearAllFileds();
        return true;
      }
      return false;
    } catch (e) {
      print("Lỗi người thuê $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  void clearAllFileds() {
    txtHoTen.clear();
    txtSDT.clear();
    txtCCCD.clear();
    txtNgaySinh.clear();
    txtQueQuan.clear();
    txtGhiChu.clear();
    gioiTinh = null;
    notifyListeners();
  }
}
