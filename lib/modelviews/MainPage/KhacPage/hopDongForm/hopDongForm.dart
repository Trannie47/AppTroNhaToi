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

  HopDong? hopDong;

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

  String? validateHopDong() {
    final ngayKy = chuyenNgay(txtNgayKy.text);
    final ngayHetHan = chuyenNgay(txtNgayHetHan.text);

    if (ngayKy == null || ngayHetHan == null) {
      return "Vui lòng nhập ngày hợp lệ";
    }

    if (!ngayHetHan.isAfter(ngayKy)) {
      return "Ngày hết hạn phải lớn hơn ngày ký";
    }

    return null;
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
