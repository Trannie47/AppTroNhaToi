import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/service/hang_hoa_service.dart';
import 'package:AppTroNhaToi/service/hoa_don_tap_hoa_service.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/material.dart';

class TapHoaPageViewModel extends ChangeNotifier {
  final HangHoaService _service_hh;
  final HoaDonTapHoaService _service_hdth;
  int currentTab = 0;
  int sttHoaDon = 1;

  List<HangHoa> dsHangHoa = [];
  List<HoaDonTapHoaModel> dsHoaDonTapHoa = [];
  List<HoaDonTapHoaModel> dsCongNoTapHoa = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TapHoaPageViewModel(this._service_hh, this._service_hdth) {
    _service_hh.addListener(_onHangHoaUpdate);
    _service_hdth.addListener(_onHoaDonUpdate);
    Future.microtask(() => _service_hh.fetchAll());
    Future.microtask(() => _service_hdth.fetchAll());
  }
  Future<void> refresh() async {
    await _service_hh.fetchAll();
    await _service_hdth.fetchAll();
    loadData();
  }

  void loadData() {
    // tạo 5 record trong dsHoaDonTapHoa
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

  //Hàng hoá
  void _onHangHoaUpdate() {
    dsHangHoa = List.from(_service_hh.list);

    notifyListeners();
  }

  Future<bool> xoa(HangHoa hangHoa) async {
    if (_isLoading) return false;

    if (hangHoa.maHangHoa == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service_hh.xoa(hangHoa.maHangHoa!);

      if (result) {
        dsHangHoa.removeWhere((e) => e.maHangHoa == hangHoa.maHangHoa);
      }

      return result;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // hoá đơn tạp hoá
  void _onHoaDonUpdate() {
    dsHoaDonTapHoa = List.from(_service_hdth.list);
    loadData();
    notifyListeners();
  }

  @override
  void dispose() {
    _service_hh.removeListener(_onHangHoaUpdate);
    _service_hdth.removeListener(_onHoaDonUpdate);
    super.dispose();
  }
}
