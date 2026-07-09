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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController txtTenThietBi = TextEditingController();
  final TextEditingController txtGiaTri = TextEditingController();
  final TextEditingController txtNgayMua = TextEditingController();

  String? loaiThietBi;
  String? trangThai;

  String? errTenThietBi;
  String? errLoaiThietBi;
  String? errNgayMua;
  String? errGiaTri;
  String? errTrangThai;

  late ThietBi thietBi;

  final List<String> dsLoaiThietBi = [
    "Điều hòa",
    "Tủ lạnh",
    "Máy giặt",
    "Tivi",
    "Quạt",
    "Lò vi sóng",
    "Bình nóng lạnh",
    "Bếp điện",
  ];

  final List<String> dsTrangThai = ["Tốt", "Đang sửa"];

  ThietBiFormViewModel(this._service, {ThietBi? thietBiInput}) {
    if (thietBiInput != null) {
      _thietBiDangSua = thietBiInput;
      thietBi = thietBiInput;

      txtTenThietBi.text = thietBi.tenThietBi ?? "";

      txtGiaTri.text = thietBi.giaTri?.toInt().toString() ?? "";

      txtNgayMua.text =
          "${thietBi.ngayMua?.day.toString().padLeft(2, '0')}/"
          "${thietBi.ngayMua?.month.toString().padLeft(2, '0')}/"
          "${thietBi.ngayMua?.year}";

      loaiThietBi = thietBi.loai;
      trangThai = thietBi.trangThaiText;
    }
  }

  bool kiemTraDuLieu() {
    errTenThietBi = null;
    errLoaiThietBi = null;
    errNgayMua = null;
    errGiaTri = null;
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

    // Ngày mua
    if (txtNgayMua.text.trim().isEmpty) {
      errNgayMua = "Vui lòng nhập ngày mua";
      hopLe = false;
    } else {
      errNgayMua = kiemTraNgay(
        txtNgayMua.text,
        minYear: 2000,
        khongLonHonHienTai: true,
      );

      if (errNgayMua != null) {
        hopLe = false;
      }
    }

    // Giá trị
    if (txtGiaTri.text.trim().isEmpty) {
      errGiaTri = "Vui lòng nhập giá trị";

      hopLe = false;
    } else {
      double? giaTri = double.tryParse(txtGiaTri.text);

      if (giaTri == null || giaTri < 0) {
        errGiaTri = "Giá trị không được âm";

        hopLe = false;
      }
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
      final parts = txtNgayMua.text.split('/');

      final tb = ThietBi(
        thietBiID: _thietBiDangSua?.thietBiID,
        tenThietBi: txtTenThietBi.text.trim(),
        loai: loaiThietBi,
        giaTri: double.parse(txtGiaTri.text),

        ngayMua: DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        ),

        trangThai: trangThai == "Tốt" ? 0 : 1,
      );

      if (isEditMode) {
        final ok = await _service.capNhat(tb);

        return ok ? tb : null;
      } else {
        // return await _service.them(tb);

        print(tb.toMap());

        final result = await _service.them(tb);

        print(result);

        return result;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    txtTenThietBi.dispose();
    txtGiaTri.dispose();
    txtNgayMua.dispose();

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
