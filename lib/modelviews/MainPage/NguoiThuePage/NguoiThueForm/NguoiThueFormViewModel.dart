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

  NguoiThue? _initialTenant;
  bool get isEdit => _initialTenant != null;

  NguoiThueFormViewModel(this._service);
  Future<NguoiThue?> luuNguoiThue() async {
    if (_isLoading) return null;
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

      NguoiThue ntData = NguoiThue(
        idnt: isEdit ? _initialTenant!.idnt : null,
        hoTen: txtHoTen.text.trim(),
        cccd: txtCCCD.text.trim(),
        sdt: txtSDT.text.trim(),
        ngaySinh: ngaySinhParsed,
        gioiTinh: gioiTinh ?? true,
        ghiChu: txtGhiChu.text.trim(),
        queQuan: txtQueQuan.text.trim(),
        trangThai: isEdit ? _initialTenant!.trangThai : 0,
      );
      if (isEdit) {
        // Luồng 1: Cập nhật thông tin
        final updatedResult = await _service.update(_initialTenant!.idnt!, ntData);
        return updatedResult;
      } else {
        // Luồng 2: Thêm mới người thuê
        bool result = await _service.them(ntData);
        if (result) {
          clearAllFileds();
          return ntData;
        }
      }
      return null;
    } catch (e) {
      print("Lỗi lưu người thuê: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  //Đổ dữ liệu cũ lên form nếu là trạng thái chỉnh sửa
  void initData(NguoiThue? tenant) {
    _initialTenant = tenant;
    if (tenant != null) {
      txtHoTen.text = tenant.hoTen ?? '';
      txtSDT.text = tenant.sdt ?? '';
      txtCCCD.text = tenant.cccd ?? '';
      gioiTinh = tenant.gioiTinh;
      txtQueQuan.text = tenant.queQuan ?? '';
      txtGhiChu.text = tenant.ghiChu ?? '';
      if (tenant.ngaySinh != null) {
        txtNgaySinh.text = "${tenant.ngaySinh!.day.toString().padLeft(2, '0')}/"
            "${tenant.ngaySinh!.month.toString().padLeft(2, '0')}/"
            "${tenant.ngaySinh!.year}";
      }
    }
  }
  bool checkTrungCCCD(){
    String cccd= txtCCCD.text.trim();
    if (cccd.isEmpty) return false;
    List<NguoiThue> ds= _service.list;
    return ds.any((nt) => nt.cccd == cccd && (!isEdit || nt.idnt != _initialTenant?.idnt));  }
  bool checkTrungSDT() {
    String sdt = txtSDT.text.trim();
    if (sdt.isEmpty) return false;

    List<NguoiThue> ds = _service.list;
    return ds.any((nt) => nt.sdt == sdt && (!isEdit || nt.idnt != _initialTenant?.idnt));  }

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
