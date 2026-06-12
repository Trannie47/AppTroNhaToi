import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ThietBiFormViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController txtTenThietBi = TextEditingController();
  final TextEditingController txtGiaTri = TextEditingController();
  final TextEditingController txtNgayMua = TextEditingController();

  String? loaiThietBi;
  int? phongID;
  String? trangThai;

  String? errTenThietBi;
  String? errLoaiThietBi;
  String? errPhong;
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

  ThietBiFormViewModel({ThietBi? thietBiInput}) {
    if (thietBiInput != null) {
      thietBi = thietBiInput;

      txtTenThietBi.text = thietBi.tenThietBi ?? "";

      txtGiaTri.text = thietBi.giaTri?.toInt().toString() ?? "";

      txtNgayMua.text =
          "${thietBi.ngayMua?.day.toString().padLeft(2, '0')}/"
          "${thietBi.ngayMua?.month.toString().padLeft(2, '0')}/"
          "${thietBi.ngayMua?.year}";

      loaiThietBi = thietBi.loai;
      trangThai = thietBi.trangThai;
    }
  }

  bool kiemTraDuLieu() {
    errTenThietBi = null;
    errLoaiThietBi = null;
    errPhong = null;
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

    // Phòng
    if (phongID == null) {
      errPhong = "Vui lòng chọn phòng";
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
