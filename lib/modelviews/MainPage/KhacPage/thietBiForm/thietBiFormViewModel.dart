import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ThietBiFormViewModel extends ChangeNotifier {
  final ThietBiProvider _service;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  ThietBi? _thietBiDangSua;

  bool get isEditMode => _thietBiDangSua != null;

  final TextEditingController txtTenThietBi = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();

  String? loaiThietBi;
  int? phongID;
  String? trangThai;
  String? ghiChu;

  String? errTenThietBi;
  String? errLoaiThietBi;
  String? errTrangThai;
  String? errGhiChu;

  final List<String> dsLoaiThietBi = [
    "Điều hòa",
    "Tủ lạnh",
    "Máy giặt",
    "Tivi",
    "Quạt",
    "Lò vi sóng",
    "Bình nóng lạnh",
    "Bếp điện",
    "Khác",
  ];
  final List<String> dsTrangThai = ["Tốt", "Đang sửa"];

  ThietBiFormViewModel(this._service, {ThietBi? thietBiInput}) {
    if (thietBiInput != null) {
      loadDeSua(thietBiInput);
    }
  }

  void loadDeSua(ThietBi tb, {List<LapRap>? dsLapRap}) {
    _thietBiDangSua = tb;

    txtTenThietBi.text = tb.tenThietBi ?? "";

    loaiThietBi = tb.loai;
    trangThai = tb.trangThaiText;

    if (dsLapRap != null) {
      final lapRap = dsLapRap.firstWhere((e) => e.thietBiID == tb.thietBiID);

      phongID = lapRap.phongID;
    }

    notifyListeners();
  }

  bool kiemTraDuLieu() {
    errTenThietBi = null;
    errLoaiThietBi = null;

    errTrangThai = null;

    bool hopLe = true;

    // Tên thiết bị
    if (txtTenThietBi.text.trim().isEmpty) {
      errTenThietBi = "Vui lòng nhập tên thiết bị";
      hopLe = false;
    }

    // Loại thiết bị
    if (loaiThietBi == null) {
      errLoaiThietBi = "Vui lòng chọn loại thiết bị";
      hopLe = false;
    }

    // Trạng thái
    if (trangThai == null) {
      errTrangThai = "Vui lòng chọn trạng thái";

      hopLe = false;
    }

    notifyListeners();

    return hopLe;
  }

  Future<ThietBi?> luu() async {
    if (!kiemTraDuLieu()) return null;
    if (_isLoading) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final tb = ThietBi(
        thietBiID: _thietBiDangSua?.thietBiID,
        tenThietBi: txtTenThietBi.text.trim(),
        loai: loaiThietBi,
        trangThai: trangThai == "Tốt" ? 0 : 1,
      );

      if (isEditMode) {
        final ok = await _service.capNhat(tb);

        return ok ? tb : null;
      } else {
        final result = await _service.them(tb);

        return result;
      }
    } catch (e) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _thietBiDangSua = null;

    txtTenThietBi.clear();

    loaiThietBi = null;
    phongID = null;
    trangThai = null;

    errTenThietBi = null;
    errLoaiThietBi = null;

    errTrangThai = null;

    notifyListeners();
  }

  Future<bool> xoa() async {
    if (_thietBiDangSua == null) return false;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      return await _service.xoa(_thietBiDangSua!.thietBiID!);
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    txtTenThietBi.dispose();

    super.dispose();
  }

  Future<void> chonNgay(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";

      notifyListeners();
    }
  }
}
