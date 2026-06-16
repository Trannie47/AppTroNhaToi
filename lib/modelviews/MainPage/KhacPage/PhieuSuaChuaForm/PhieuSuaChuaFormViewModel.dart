import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class PhieuSuaChuaViewModel extends ChangeNotifier {

  final txtNgaySuaChua = TextEditingController();

  final txtNguyenNhan = TextEditingController();

  final txtChiPhi = TextEditingController();
  int sttHoaDon = 1;
  bool taoHoaDon = false;
  bool daTaoHoaDon = false;
  final txtNgayHoaDon = TextEditingController();
  String maHoaDon = "";
  String? errNgayHoaDon;
  String? loaiSuaChua = "Sửa chữa nhỏ";
  String? trangThai = "Đang sửa chữa";
  String? errNgaySuaChua;
  String? errNguyenNhan;
  String? errChiPhi;

  List<String> dsLoaiSuaChua = [
    "Sửa chữa nhỏ",
    "Sửa chữa lớn",
    "Bảo trì định kỳ",
    "Thay thế linh kiện",
    "Vệ sinh thiết bị",
    "Khắc phục sự cố điện",
    "Khắc phục sự cố nước",
    "Sửa chữa khẩn cấp",
    "Nâng cấp thiết bị",
    "Khác",
  ];

  List<String> dsTrangThai = [
    "Đang sửa chữa",
    "Đã hoàn thành",
    "Đã thanh toán",
    "Đã hủy",
  ];



  DateTime? chuyenNgay(String ngay) {

    try {

      final tach = ngay.split('/');

      return DateTime(
        int.parse(tach[2]),
        int.parse(tach[1]),
        int.parse(tach[0]),
      );
    }
    catch (_) {

      return null;
    }
  }

  Future<void> chonNgay(
      BuildContext context,
      TextEditingController controller,
      ) async {

    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (ngay != null) {

      controller.text = formatDate(ngay);

      notifyListeners();
    }
  }

  bool kiemTraDuLieu() {

    bool hopLe = true;

    errNgaySuaChua = null;
    errNguyenNhan = null;
    errChiPhi = null;
    errNgayHoaDon = null;

    if (taoHoaDon) {

      DateTime? ngaySua =
      chuyenNgay(txtNgaySuaChua.text);

      DateTime? ngayHoaDon =
      chuyenNgay(txtNgayHoaDon.text);

      if (ngaySua != null &&
          ngayHoaDon != null &&
          ngaySua.isAfter(ngayHoaDon)) {

        errNgayHoaDon =
        "Ngày lập hóa đơn phải lớn hơn hoặc bằng ngày sửa chữa";

        hopLe = false;
      }

      errNgayHoaDon = kiemTraNgay(
        txtNgayHoaDon.text,
        minYear: 2000,
      );

      if (errNgayHoaDon != null) {
        hopLe = false;
      }

      if (loaiSuaChua == null) {
        hopLe = false;
      }

      if (trangThai == null) {
        hopLe = false;
      }
      errNgaySuaChua = kiemTraNgay(
        txtNgaySuaChua.text,
        minYear: 2000,
      );
    }

    if (errNgaySuaChua != null) {

      hopLe = false;
    }

    else {


      DateTime? ngaySua =
      chuyenNgay(txtNgaySuaChua.text);

      if (ngaySua != null &&
          ngaySua.isAfter(DateTime.now())) {

        errNgaySuaChua =
        "Ngày sửa chữa không được lớn hơn ngày hiện tại";

        hopLe = false;
      }
    }

    if (txtNguyenNhan.text.trim().isEmpty) {

      errNguyenNhan =
      "Vui lòng nhập nguyên nhân / triệu chứng";

      hopLe = false;
    }

    else if (txtNguyenNhan.text
        .trim()
        .length < 5) {

      errNguyenNhan =
      "Nguyên nhân phải có ít nhất 5 ký tự";

      hopLe = false;
    }

    if (taoHoaDon) {

      if (txtChiPhi.text.trim().isEmpty) {

        errChiPhi =
        "Vui lòng nhập chi phí sửa chữa";

        hopLe = false;
      }
    }

    if (txtChiPhi.text.trim().isNotEmpty) {

      int? chiPhi =
      int.tryParse(txtChiPhi.text);
      if (chiPhi == null) {

        errChiPhi =
        "Chi phí chỉ được nhập số nguyên";

        hopLe = false;
      }

      else if (chiPhi <= 0) {

        errChiPhi =
        "Chi phí phải lớn hơn 0";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }
  PhieuSuaChuaViewModel() {

    txtNgaySuaChua.text =
        formatDate(DateTime.now());

    txtNgayHoaDon.text =
        txtNgaySuaChua.text;
  }

  @override
  void dispose() {

    txtNgaySuaChua.dispose();
    txtNguyenNhan.dispose();
    txtChiPhi.dispose();
    txtNgayHoaDon.dispose();


    super.dispose();
  }

  void doiTrangThaiTaoHoaDon(bool value) {

    if (daTaoHoaDon && value == false) {
      return;
    }

    taoHoaDon = value;

    if (!taoHoaDon) {

      errChiPhi = null;

      errNgayHoaDon = null;
    }

    notifyListeners();
  }

  void taoMaHoaDon() {

    DateTime now = DateTime.now();

    String nam = now.year.toString();

    String thang =
    now.month.toString().padLeft(2, '0');

    String ngay =
    now.day.toString().padLeft(2, '0');

    String stt =
    sttHoaDon.toString().padLeft(3, '0');

    maHoaDon =
    "PSC${nam}${thang}${ngay}$stt";

    sttHoaDon++;
  }

}