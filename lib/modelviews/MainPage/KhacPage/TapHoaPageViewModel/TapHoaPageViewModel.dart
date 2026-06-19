import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/material.dart';

class TapHoaPageViewModel extends ChangeNotifier {
  int currentTab = 0;
  int sttHoaDon = 1;

  List<HangHoa> dsHangHoa = [];
  List<HoaDonTapHoaModel> dsHoaDonTapHoa = [];
  List<HoaDonTapHoaModel> dsCongNoTapHoa = [];

  TapHoaPageViewModel() {
    loadData();
  }

  void loadData() {
    dsHangHoa = [
      HangHoa(
        maHangHoa: 1,
        tenHangHoa: "Mì Hảo Hảo",
        giaNhap: 3000,
        giaBan: 5000,
        donViTinh: "gói",
      ),
      HangHoa(
        maHangHoa: 2,
        tenHangHoa: "Coca Cola",
        giaNhap: 8000,
        giaBan: 12000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 3,
        tenHangHoa: "Nước suối",
        giaNhap: 4000,
        giaBan: 7000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 4,
        tenHangHoa: "Sữa Vinamilk",
        giaNhap: 28000,
        giaBan: 35000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 5,
        tenHangHoa: "Bánh Oreo",
        giaNhap: 12000,
        giaBan: 18000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 6,
        tenHangHoa: "Trứng gà",
        giaNhap: 25000,
        giaBan: 30000,
        donViTinh: "vỉ",
      ),
    ];

    //tạo 5 record trong dsHoaDonTapHoa
    dsHoaDonTapHoa = [
      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now(),
          tongTien: 50000,
          idnt: 1,
        ),
        phieuThu: null,
        tenNguoiMua: 'Trần Văn A',
      ),
      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(Duration(days: 1)),
          tongTien: 120000,
          idnt: 2,
        ),
        phieuThu: null,
        tenNguoiMua: 'Nguyễn Thị B',
      ),
      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(Duration(days: 3)),
          tongTien: 80000,
        ),
        phieuThu: PhieuThuHdTh(
          maPhieuThu: 1002,
          ngayThu: DateTime.now().subtract(Duration(days: 2)),
          soTien: 80000,
          nguoiDong: 'Lê Văn C',
        ),
        tenNguoiMua: 'Lê Văn C',
      ),
      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now(),
          tongTien: 30000,
        ),
        phieuThu: null,
        tenNguoiMua: 'Phạm Thị D',
      ),
      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(Duration(days: 7)),
          tongTien: 150000,
        ),
        phieuThu: PhieuThuHdTh(
          maPhieuThu: 1003,
          ngayThu: DateTime.now().subtract(Duration(days: 6)),
          soTien: 50000,
          nguoiDong: 'Hoàng Văn E',
        ),
        tenNguoiMua: 'Hoàng Văn E',
      ),
    ];
    //Nếu hoá đơn tạp hoá chưa có phiếu thu trở thành danh sách công nợ và id người thuê trên hoá đơn phải khác null
    dsCongNoTapHoa = dsHoaDonTapHoa
        .where((item) => (item.phieuThu == null) && (item.hoaDon.idnt != null))
        .toList();

    notifyListeners();
  }

  /// mặc định mã tự động
  String taoMaHoaDon() {
    DateTime now = DateTime.now();

    String nam = now.year.toString();

    String thang = now.month.toString().padLeft(2, '0');

    String ngay = now.day.toString().padLeft(2, '0');

    String stt = sttHoaDon.toString().padLeft(3, '0');

    sttHoaDon++;

    return "$nam$thang$ngay$stt";
  }

  /// tab
  void changeTab(int index) {
    currentTab = index;

    print("currentTab = $currentTab");

    notifyListeners();
  }

  /// thêm hàng hóa
  void themHoaDon(double tongTien) {
    // dsHoaDon.insert(
    //   0,
    //   HoaDonTapHoa(
    //     maHoaDon: taoMaHoaDon(),
    //     ngayBan: DateTime.now(),
    //     tongTien: tongTien,
    //   ),
    // );

    // notifyListeners();
  }

  /// sửa hàng hóa
  void suaHangHoa(HangHoa hangHoa) {
    int index = dsHangHoa.indexWhere((e) => e.maHangHoa == hangHoa.maHangHoa);

    if (index != -1) {
      dsHangHoa[index] = hangHoa;
      notifyListeners();
    }
  }

  /// xóa hàng hóa
  void xoaHangHoa(int maHangHoa) {
    dsHangHoa.removeWhere((e) => e.maHangHoa == maHangHoa);

    notifyListeners();
  }

  /// tổng mặt hàng
  int get tongMatHang {
    return dsHangHoa.length;
  }

  //// Tính số lượng công nợ
  int get soCongNo {
    return dsCongNoTapHoa.length;
  }

  //// Tính tổng số tiền công nợ
  double get tongCongNo {
    return dsCongNoTapHoa.fold<double>(
      0,
      (sum, item) => sum + (item.hoaDon.tongTien ?? 0),
    );
  }

  int get tongHoaDon {
    return dsHoaDonTapHoa.length;
  }
}
