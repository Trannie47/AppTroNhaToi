import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/service/hang_hoa_service.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/material.dart';

class TapHoaPageViewModel extends ChangeNotifier {
  final HangHoaService _service_hh;
  int currentTab = 0;
  int sttHoaDon = 1;

  List<HangHoa> dsHangHoa = [];
  List<HoaDonTapHoaModel> dsHoaDonTapHoa = [];
  List<HoaDonTapHoaModel> dsCongNoTapHoa = [];

  TapHoaPageViewModel(this._service_hh) {
    _service_hh.addListener(_onServiceUpdate);
    Future.microtask(() => _service_hh.fetchAll());
    // loadData();
  }
  Future<void> refresh() => _service_hh.fetchAll();

  void loadData() {
    // tạo 5 record trong dsHoaDonTapHoa
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

        dsHangHoa: [
          dsHangHoa[0], // Mì Hảo Hảo
          dsHangHoa[1], // Coca Cola
        ],

        soLuong: {dsHangHoa[0].maHangHoa!: 2, dsHangHoa[1].maHangHoa!: 3},
      ),

      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(const Duration(days: 1)),
          tongTien: 120000,
          idnt: 2,
        ),
        phieuThu: null,
        tenNguoiMua: 'Nguyễn Thị B',

        dsHangHoa: [
          dsHangHoa[2], // Nước suối
          dsHangHoa[3], // Sữa Vinamilk
        ],

        soLuong: {dsHangHoa[2].maHangHoa!: 5, dsHangHoa[3].maHangHoa!: 2},
      ),

      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(const Duration(days: 3)),
          tongTien: 80000,
        ),
        phieuThu: PhieuThuHdTh(
          maPhieuThu: 1002,
          ngayThu: DateTime.now().subtract(const Duration(days: 2)),
          soTien: 80000,
          nguoiDong: 'Lê Văn C',
        ),
        tenNguoiMua: 'Lê Văn C',

        dsHangHoa: [
          dsHangHoa[4], // Bánh Oreo
          dsHangHoa[5], // Trứng gà
        ],

        soLuong: {dsHangHoa[4].maHangHoa!: 2, dsHangHoa[5].maHangHoa!: 1},
      ),

      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now(),
          tongTien: 30000,
        ),
        phieuThu: null,
        tenNguoiMua: 'Phạm Thị D',

        dsHangHoa: [
          dsHangHoa[1], // Coca Cola
          dsHangHoa[2], // Nước suối
        ],

        soLuong: {dsHangHoa[1].maHangHoa!: 1, dsHangHoa[2].maHangHoa!: 2},
      ),

      HoaDonTapHoaModel(
        hoaDon: HoaDonTapHoa(
          maHoaDon: taoMaHoaDon(),
          ngayBan: DateTime.now().subtract(const Duration(days: 7)),
          tongTien: 150000,
        ),
        phieuThu: PhieuThuHdTh(
          maPhieuThu: 1003,
          ngayThu: DateTime.now().subtract(const Duration(days: 6)),
          soTien: 50000,
          nguoiDong: 'Hoàng Văn E',
        ),
        tenNguoiMua: 'Hoàng Văn E',

        dsHangHoa: [
          dsHangHoa[0], // Mì Hảo Hảo
          dsHangHoa[3], // Sữa Vinamilk
          dsHangHoa[5], // Trứng gà
        ],

        soLuong: {
          dsHangHoa[0].maHangHoa!: 5,
          dsHangHoa[3].maHangHoa!: 2,
          dsHangHoa[5].maHangHoa!: 1,
        },
      ),
    ];
    //Nếu hoá đơn tạp hoá chưa có phiếu thu trở thành danh sách công nợ và id người thuê trên hoá đơn phải khác null
    dsCongNoTapHoa = dsHoaDonTapHoa
        .where((item) => (item.phieuThu == null) && (item.hoaDon.idnt != null))
        .toList();

    notifyListeners();
  }

  // xoa hóa đơn và công nợ
  void xoaHoaDon(String maHoaDon) {
    dsHoaDonTapHoa.removeWhere((e) => e.hoaDon.maHoaDon == maHoaDon);

    dsCongNoTapHoa.removeWhere((e) => e.hoaDon.maHoaDon == maHoaDon);

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
  void themHoaDon(HoaDonTapHoaModel hoaDonModel) {
    dsHoaDonTapHoa.insert(0, hoaDonModel);

    // Nếu chưa có phiếu thu và có id người thuê
    if (hoaDonModel.phieuThu == null && hoaDonModel.hoaDon.idnt != null) {
      dsCongNoTapHoa.insert(0, hoaDonModel);
    }

    notifyListeners();
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

  void _onServiceUpdate() {
    dsHangHoa = List.from(_service_hh.list);

    notifyListeners();
  }

  @override
  void dispose() {
    _service_hh.removeListener(_onServiceUpdate);
    super.dispose();
  }
}
