import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:flutter/material.dart';

class HopDongFormModelView extends ChangeNotifier {
  final txtPhong = TextEditingController();
  final txtNguoiThue = TextEditingController();

  final txtNgayKy = TextEditingController();
  final txtNgayHetHan = TextEditingController();

  final txtTongGiaPhong = TextEditingController();
  final txtGiaHopDong = TextEditingController();
  final txtGiaDeXuat = TextEditingController();

  final txtTienCoc = TextEditingController();
  final txtGhiChu = TextEditingController();

  int soNguoiHienTai = 0;

  HopDong? hopDong;
  String? errNgayKy;
  String? errNgayHetHan;
  String? errPhong;
  String? errNguoiThue;
  String? errTongGiaPhong;
  String? errGiaHopDong;
  String? errTienCoc;
  String? errGiaDeXuat;
  String? errGhiChu;

  bool get isEdit => hopDong != null;

  void init({HopDong? hopDong}) {
    this.hopDong = hopDong;

    if (hopDong != null) {
      txtNgayKy.text = formatDate(hopDong.ngayKy);
      txtNgayHetHan.text = formatDate(hopDong.ngayHetHan);

      txtGiaHopDong.text = (hopDong.giaPhongThucTe ?? 0).toString();

      txtTienCoc.text = (hopDong.tienCoc ?? 0).toString();

      txtGhiChu.text = "";
    }

    notifyListeners();
  }

  DateTime? chuyenNgay(String ngay) {
    try {
      final tach = ngay.split('/');

      return DateTime(
        int.parse(tach[2]),
        int.parse(tach[1]),
        int.parse(tach[0]),
      );
    } catch (_) {
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
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (ngay != null) {
      controller.text = formatDate(ngay);

      notifyListeners();
    }
  }

  bool kiemTraDuLieu() {
    errPhong = null;
    errNguoiThue = null;
    errNgayKy = null;
    errNgayHetHan = null;
    errGiaHopDong = null;
    errTienCoc = null;
    errGhiChu = null;
    errTongGiaPhong = null;
    errGiaDeXuat = null;

    bool hopLe = true;

    errNgayKy = kiemTraNgay(txtNgayKy.text, minYear: 2000);

    if (errNgayKy != null) {
      hopLe = false;
    }

    errNgayHetHan = kiemTraNgay(txtNgayHetHan.text, minYear: 1);

    if (errNgayHetHan != null) {
      hopLe = false;
    }

    if (hopLe) {
      DateTime ngayKy = chuyenNgay(txtNgayKy.text)!;

      DateTime ngayHetHan = chuyenNgay(txtNgayHetHan.text)!;

      if (!ngayHetHan.isAfter(ngayKy)) {
        errNgayHetHan = "Ngày hết hạn phải lớn hơn ngày ký";

        hopLe = false;
      }
    }
    double? tongGiaPhong = double.tryParse(txtTongGiaPhong.text);

    if (tongGiaPhong == null || tongGiaPhong < 0) {
      errTongGiaPhong = "Tổng giá phòng phải là số ≥ 0";

      hopLe = false;
    }

    double? giaHopDong = double.tryParse(txtGiaHopDong.text);

    if (giaHopDong == null || giaHopDong < 0) {
      errGiaHopDong = "Giá thuê phải là số ≥ 0";

      hopLe = false;
    }

    double? tienCoc = double.tryParse(txtTienCoc.text);

    if (tienCoc == null || tienCoc < 0) {
      errTienCoc = "Tiền cọc phải là số ≥ 0";

      hopLe = false;
    }

    double? giaDeXuat = double.tryParse(txtGiaDeXuat.text);

    if (giaDeXuat == null || giaDeXuat < 0) {
      errGiaDeXuat = "Giá đề xuất phải là số ≥ 0";

      hopLe = false;
    }
    if (txtPhong.text.trim().isEmpty) {
      errPhong = "Vui lòng nhập phòng thuê";

      hopLe = false;
    }

    if (txtNguoiThue.text.trim().isEmpty) {
      errNguoiThue = "Vui lòng nhập người thuê";

      hopLe = false;
    }

    notifyListeners();

    return hopLe;
  }

  void capNhatGiaDeXuat() {
    double giaHopDong = double.tryParse(txtGiaHopDong.text) ?? 0;

    if (soNguoiHienTai <= 0) {
      txtGiaDeXuat.text = giaHopDong.round().toString();
    } else {
      double giaDeXuat = giaHopDong / (soNguoiHienTai + 1);

      txtGiaDeXuat.text = giaDeXuat.round().toString();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    txtPhong.dispose();
    txtNguoiThue.dispose();
    txtNgayKy.dispose();
    txtNgayHetHan.dispose();
    txtTongGiaPhong.dispose();
    txtGiaHopDong.dispose();
    txtGiaDeXuat.dispose();
    txtTienCoc.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}
