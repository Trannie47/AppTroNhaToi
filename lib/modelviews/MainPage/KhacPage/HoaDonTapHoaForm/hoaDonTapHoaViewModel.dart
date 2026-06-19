import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:flutter/material.dart';

class HoaDonTapHoaFormViewModel extends ChangeNotifier {
  bool nguoiThueTro = true;

  bool coPhieuThu = true;

  final txtNgayMua = TextEditingController();

  final txtNguoiDongTien = TextEditingController();

  final txtNguoiMua = TextEditingController();

  List<HangHoa> dsHangHoaChon = [];
  List<NguoiThue> dsNguoiThue = [];
  NguoiThue? selectedNguoiThue;
  Map<int, int> soLuong = {};

  int sttHoaDon = 1;

  String maHoaDon = "";

  HoaDonTapHoaFormViewModel() {
    DateTime now = DateTime.now();

    txtNgayMua.text =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
  }

  //LoadingData
  void LoadData() {
    dsNguoiThue = [
      NguoiThue(
        idnt: 1,
        cccd: '012345678901',
        hoTen: 'Nguyễn Văn An',
        ngaySinh: DateTime(1995, 4, 12),
        sdt: '0987654321',
        queQuan: 'Hà Nội',
        ghiChu: 'Thích nuôi cây',
        gioiTinh: true,
      ),
      NguoiThue(
        idnt: 2,
        cccd: '023456789012',
        hoTen: 'Trần Thị Bích',
        ngaySinh: DateTime(1998, 10, 3),
        sdt: '0911222333',
        queQuan: 'Hồ Chí Minh',
        ghiChu: 'Làm IT',
        gioiTinh: false,
      ),
      NguoiThue(
        idnt: 3,
        cccd: '034567890123',
        hoTen: 'Lê Văn Cường',
        ngaySinh: DateTime(1992, 1, 20),
        sdt: '0903344556',
        queQuan: 'Đà Nẵng',
        ghiChu: null,
        gioiTinh: true,
      ),
      NguoiThue(
        idnt: 4,
        cccd: '045678901234',
        hoTen: 'Phạm Thị Duyên',
        ngaySinh: DateTime(2000, 6, 5),
        sdt: '0977000111',
        queQuan: 'Cần Thơ',
        ghiChu: 'Sinh viên',
        gioiTinh: false,
      ),
      NguoiThue(
        idnt: 5,
        cccd: '056789012345',
        hoTen: 'Hoàng Văn Em',
        ngaySinh: DateTime(1988, 12, 30),
        sdt: '0966123456',
        queQuan: 'Hải Phòng',
        ghiChu: 'Người sửa chữa',
        gioiTinh: true,
      ),
    ];
  }

  // đổi trạng thái phiếu thu
  void doiTrangThaiPhieuThu(bool value) {
    coPhieuThu = value;

    if (!coPhieuThu) {
      txtNguoiDongTien.clear();
    }

    notifyListeners();
  }

  // ĐỔI TRẠNG THÁI người thuê
  void doiTrangThaiNguoiThueTro(bool value) {
    nguoiThueTro = value;

    if (!nguoiThueTro) {
      txtNguoiMua.clear();
    }

    notifyListeners();
  }

  /// thêm hàng hóa
  void themHangHoa(HangHoa hangHoa) {
    int index = dsHangHoaChon.indexWhere(
      (e) => e.maHangHoa == hangHoa.maHangHoa,
    );

    if (index == -1) {
      dsHangHoaChon.add(hangHoa);

      soLuong[hangHoa.maHangHoa!] = 1;
    } else {
      tangSoLuong(hangHoa);

      return;
    }

    notifyListeners();
  }

  /// tăng số lượng
  void tangSoLuong(HangHoa hangHoa) {
    soLuong[hangHoa.maHangHoa!] = (soLuong[hangHoa.maHangHoa] ?? 0) + 1;

    notifyListeners();
  }

  //Cập nhật số lượng
  void capNhatSoLuong(HangHoa hangHoa, int value) {
    if (value <= 0) {
      value = 1;
    }

    soLuong[hangHoa.maHangHoa!] = value;

    notifyListeners();
  }

  /// giảm số lượng
  void giamSoLuong(HangHoa hangHoa) {
    int sl = soLuong[hangHoa.maHangHoa] ?? 1;

    if (sl > 1) {
      soLuong[hangHoa.maHangHoa!] = sl - 1;
    } else {
      dsHangHoaChon.removeWhere((e) => e.maHangHoa == hangHoa.maHangHoa);

      soLuong.remove(hangHoa.maHangHoa);
    }

    notifyListeners();
  }

  /// lấy số lượng
  int laySoLuong(HangHoa hangHoa) {
    return soLuong[hangHoa.maHangHoa] ?? 1;
  }

  /// tổng tiền
  double get tongTien {
    double tong = 0;

    for (var hh in dsHangHoaChon) {
      tong += (hh.giaBan ?? 0) * laySoLuong(hh);
    }

    return tong;
  }

  /// format tiền
  String formatTien(double tien) {
    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  /// sinh mã hóa đơn
  void taoMaHoaDon() {
    DateTime now = DateTime.now();

    String nam = now.year.toString();

    String thang = now.month.toString().padLeft(2, '0');

    String ngay = now.day.toString().padLeft(2, '0');

    String stt = sttHoaDon.toString().padLeft(3, '0');

    maHoaDon = "TH$nam$thang$ngay$stt";

    sttHoaDon++;

    notifyListeners();
  }

  @override
  void dispose() {
    txtNgayMua.dispose();

    txtNguoiDongTien.dispose();

    txtNguoiMua.dispose();

    super.dispose();
  }
}
