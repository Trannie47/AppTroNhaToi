import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

class HopDongFormModelView extends ChangeNotifier {
  final txtNgayKy = TextEditingController();
  final txtNgayHetHan = TextEditingController();

  final txtTongGiaPhong = TextEditingController();
  final txtGiaHopDong = TextEditingController();
  final txtGiaDeXuat = TextEditingController();

  final txtTienCoc = TextEditingController();
  final txtGhiChu = TextEditingController();

  HopDong? hopDong;

  //Ds Phòng có thể thuê
  List<Phong> dsPhong = [
    Phong(
      phongID: 1,
      tenPhong: "Phòng 101",
      trangThai: 1,
      maLoaiPhong: 101,
      moTa: "Phòng có ban công",
    ),
    Phong(
      phongID: 2,
      tenPhong: "Phòng 102",
      trangThai: 2,
      maLoaiPhong: 102,
      moTa: "Phòng có bếp",
    ),
    Phong(
      phongID: 3,
      tenPhong: "Phòng 103",
      trangThai: 0,
      maLoaiPhong: 103,
      moTa: "Phòng có sân thượng",
    ),
  ];
  Phong? selectedPhong;

  List<LoaiPhong> dsLoaiPhong = [
    LoaiPhong(
      maLoaiPhong: 101,
      tenLoaiPhong: "Loại 1",
      dienTich: 12,
      soNguoiToiDa: 5,
      giaTien: 12,
    ),
    LoaiPhong(
      maLoaiPhong: 102,
      tenLoaiPhong: "Loại 2",
      dienTich: 15,
      soNguoiToiDa: 3,
      giaTien: 15,
    ),
    LoaiPhong(
      maLoaiPhong: 103,
      tenLoaiPhong: "Loại 3",
      dienTich: 20,
      soNguoiToiDa: 2,
      giaTien: 20,
    ),
  ];

  //Danh sách người thuê
  List<NguoiThue> dsNguoiThue = [
    NguoiThue(
      idnt: 1,
      hoTen: "Nguyễn Văn A",
      cccd: "079001234567",
      sdt: "0901234567",
      ghiChu: "",
    ),
    NguoiThue(
      idnt: 2,
      hoTen: "Trần Thị B",
      cccd: "079001234890",
      sdt: "0912345678",
      ghiChu: "Ở ghép",
    ),
    NguoiThue(
      idnt: 3,
      hoTen: "Lê Văn C",
      cccd: "079001234567",
      sdt: "0901234567",
      ghiChu: "",
    ),
  ];

  NguoiThue? selectedNguoiThue;
  bool get isEdit => hopDong != null;

  //Chọn phòng sẽ tự động tính tổng giá phòng
  void onSelectedPhong(Phong? phong) {
    selectedPhong = phong;
    if (phong != null) {
      final loaiPhong = dsLoaiPhong.firstWhere(
        (e) => e.maLoaiPhong == phong.maLoaiPhong,
      );
      txtTongGiaPhong.text = loaiPhong.giaTien.toString();
    } else {
      txtTongGiaPhong.text = "";
    }
    notifyListeners();
  }

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
    txtNgayKy.dispose();
    txtNgayHetHan.dispose();
    txtTongGiaPhong.dispose();
    txtGiaHopDong.dispose();
    txtGiaDeXuat.dispose();
    txtTienCoc.dispose();
    txtGhiChu.dispose();
    dsNguoiThue.clear();
    dsPhong.clear();
    selectedNguoiThue = null;
    selectedPhong = null;
    super.dispose();
  }
}
