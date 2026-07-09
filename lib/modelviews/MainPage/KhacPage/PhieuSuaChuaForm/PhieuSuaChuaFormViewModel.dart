import 'dart:ffi';

import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
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
  int? maSuaChua;
  String? errNgayHoaDon;
  String? errNgaySuaChua;
  String? errNguyenNhan;
  String? errChiPhi;
  int? loaiSua = 0;
  int? trangThai = 0;
  late Phong phong;
  late ThietBi thietBi;

  SuaChua? suaChua;
  HoaDonSuaChua? hoaDonSuaChua;
  DateTime ngaySua = DateTime.now();
  DateTime ngayLapHoaDon = DateTime.now();

  final Map<int, String> dsLoaiSua = {
    0: "Sửa chữa nhỏ",
    1: "Sửa chữa lớn",
    2: "Bảo trì định kỳ",
    3: "Thay thế linh kiện",
    4: "Vệ sinh thiết bị",
    5: "Khắc phục sự cố điện",
    6: "Khắc phục sự cố nước",
    7: "Sửa chữa khẩn cấp",
    8: "Nâng cấp thiết bị",
    9: "Khác",
  };

  final Map<int, String> dsTrangThai = {
    0: "Đang sửa chữa",
    1: "Đã hoàn thành",
    2: "Đã thanh toán",
    3: "Đã hủy",
  };

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

  void setLoaiSua(int value) {
    loaiSua = value;

    notifyListeners();
  }

  void setTrangThai(int value) {
    trangThai = value;

    notifyListeners();
  }

  bool kiemTraDuLieu() {
    bool hopLe = true;

    errNgaySuaChua = null;
    errNguyenNhan = null;
    errChiPhi = null;
    errNgayHoaDon = null;

    if (taoHoaDon) {
      DateTime? ngaySua = chuyenNgay(txtNgaySuaChua.text);

      DateTime? ngayHoaDon = chuyenNgay(txtNgayHoaDon.text);

      if (ngaySua != null &&
          ngayHoaDon != null &&
          ngaySua.isAfter(ngayHoaDon)) {
        errNgayHoaDon = "Ngày lập hóa đơn phải lớn hơn hoặc bằng ngày sửa chữa";

        hopLe = false;
      }

      errNgayHoaDon = kiemTraNgay(txtNgayHoaDon.text, minYear: 2000);

      if (errNgayHoaDon != null) {
        hopLe = false;
      }

      if (loaiSua == null) {
        hopLe = false;
      }

      if (trangThai == null) {
        hopLe = false;
      }
      errNgaySuaChua = kiemTraNgay(txtNgaySuaChua.text, minYear: 2000);
    }

    if (errNgaySuaChua != null) {
      hopLe = false;
    } else {
      DateTime? ngaySua = chuyenNgay(txtNgaySuaChua.text);

      if (ngaySua != null && ngaySua.isAfter(DateTime.now())) {
        errNgaySuaChua = "Ngày sửa chữa không được lớn hơn ngày hiện tại";

        hopLe = false;
      }
    }

    if (txtNguyenNhan.text.trim().isEmpty) {
      errNguyenNhan = "Vui lòng nhập nguyên nhân / triệu chứng";

      hopLe = false;
    } else if (txtNguyenNhan.text.trim().length < 5) {
      errNguyenNhan = "Nguyên nhân phải có ít nhất 5 ký tự";

      hopLe = false;
    }

    if (taoHoaDon) {
      if (txtChiPhi.text.trim().isEmpty) {
        errChiPhi = "Vui lòng nhập chi phí sửa chữa";

        hopLe = false;
      }
    }

    if (txtChiPhi.text.trim().isNotEmpty) {
      int? chiPhi = int.tryParse(txtChiPhi.text);
      if (chiPhi == null) {
        errChiPhi = "Chi phí chỉ được nhập số nguyên";

        hopLe = false;
      } else if (chiPhi <= 0) {
        errChiPhi = "Chi phí phải lớn hơn 0";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }

  void init(
    ThietBi thietBiData, {
    SuaChua? suaChuaData,
    HoaDonSuaChua? hoaDonData,
  }) {
    thietBi = thietBiData;

    suaChua = suaChuaData;
    hoaDonSuaChua = hoaDonData;

    if (suaChua == null) {
      txtNgaySuaChua.text = formatDate(DateTime.now());

      ngaySua = DateTime.now();

      txtNgayHoaDon.text = txtNgaySuaChua.text;

      ngayLapHoaDon = ngaySua;
    } else {
      maSuaChua = suaChua!.id;
      ngaySua = suaChua!.ngaySuaChua!;
      txtNgaySuaChua.text = formatDate(ngaySua);

      txtNguyenNhan.text = suaChua!.nguyenNhan ?? "";
    }

    if (hoaDonSuaChua != null) {
      taoHoaDon = true;
      daTaoHoaDon = true;
      maHoaDon = hoaDonSuaChua!.maHoaDonSC?.toString() ?? "";

      ngayLapHoaDon = hoaDonSuaChua!.ngayLapHoaDonSC!;

      txtNgayHoaDon.text = formatDate(hoaDonSuaChua!.ngayLapHoaDonSC);

      txtChiPhi.text = (hoaDonSuaChua!.giaTien ?? 0).toInt().toString();

      loaiSua = hoaDonSuaChua!.loaiSua ?? 0;

      trangThai = hoaDonSuaChua!.trangThai ?? 0;
    }
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

    String thang = now.month.toString().padLeft(2, '0');

    String ngay = now.day.toString().padLeft(2, '0');

    String stt = sttHoaDon.toString().padLeft(3, '0');

    maHoaDon = "PSC${nam}${thang}${ngay}$stt";

    sttHoaDon++;
  }
}
