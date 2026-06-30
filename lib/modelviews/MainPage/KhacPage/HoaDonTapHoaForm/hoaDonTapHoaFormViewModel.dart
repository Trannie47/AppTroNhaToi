import 'package:AppTroNhaToi/Provider/hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HoaDonTapHoaDTO.dart';
import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:flutter/material.dart';

class HoaDonTapHoaFormViewModel extends ChangeNotifier {
  final NguoiThueProvider _nguoiThueProvider;
  final HoaDonTapHoaProvider _hoaDonTapHoaProvider;
  bool nguoiThueTro = true;

  bool coPhieuThu = true;

  String? errNguoiThue;
  String? errHangHoa;

  final txtNgayMua = TextEditingController();

  final txtNguoiDongTien = TextEditingController();

  final txtNguoiMua = TextEditingController();

  List<HangHoa> dsHangHoaChon = [];

  List<NguoiThue> dsNguoiThue = [];

  NguoiThue? selectedNguoiThue;

  Map<int, int> soLuong = {};

  int sttHoaDon = 1;

  String maHoaDon = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HoaDonTapHoaFormViewModel(
    this._nguoiThueProvider,
    this._hoaDonTapHoaProvider,
  ) {
    _nguoiThueProvider.addListener(_onNguoiThueUpdate);

    dsNguoiThue = List.from(_nguoiThueProvider.list);

    Future.microtask(() async {
      if (_nguoiThueProvider.list.isEmpty) {
        await _nguoiThueProvider.fetchAll();
      } else {
        _onNguoiThueUpdate();
      }
    });

    DateTime now = DateTime.now();

    txtNgayMua.text = formatDate(now);
  }

  Future<void> refresh() async {
    await _nguoiThueProvider.fetchAll();
  }

  void _onNguoiThueUpdate() {
    dsNguoiThue = List.from(_nguoiThueProvider.list);

    notifyListeners();
  }

  // kiểm tra dữ liệu
  bool kiemTraDuLieu() {
    errNguoiThue = null;
    errHangHoa = null;

    bool hopLe = true;

    if (nguoiThueTro && selectedNguoiThue == null) {
      errNguoiThue = "Vui lòng chọn người thuê.";

      hopLe = false;
    }

    if (dsHangHoaChon.isEmpty) {
      errHangHoa = "Vui lòng thêm ít nhất một hàng hóa.";

      hopLe = false;
    }

    notifyListeners();

    return hopLe;
  }

  // đổi trạng thái phiếu thu
  void doiTrangThaiPhieuThu(bool value) {
    if (!nguoiThueTro) {
      coPhieuThu = true;
    } else {
      coPhieuThu = value;
    }

    if (!coPhieuThu) {
      txtNguoiDongTien.clear();
    }

    notifyListeners();
  }

  // đổi trạng thái người thuê
  void doiTrangThaiNguoiThueTro(bool value) {
    nguoiThueTro = value;

    if (!nguoiThueTro) {
      selectedNguoiThue = null;

      txtNguoiMua.clear();

      coPhieuThu = true;

      txtNguoiDongTien.clear();

      errNguoiThue = null;
    }

    notifyListeners();
  }

  void themHangHoa(HangHoa hangHoa) {
    if (hangHoa.maHangHoa == null) return;

    int index = dsHangHoaChon.indexWhere(
      (e) => e.maHangHoa == hangHoa.maHangHoa,
    );

    if (index == -1) {
      dsHangHoaChon.add(hangHoa);

      soLuong[hangHoa.maHangHoa!] = 1;
    } else {
      soLuong[hangHoa.maHangHoa!] = (soLuong[hangHoa.maHangHoa!] ?? 0) + 1;
    }

    notifyListeners();
  }

  void tangSoLuong(HangHoa hangHoa) {
    soLuong[hangHoa.maHangHoa!] = (soLuong[hangHoa.maHangHoa!] ?? 0) + 1;

    notifyListeners();
  }

  void capNhatSoLuong(HangHoa hangHoa, int value) {
    if (value <= 0) {
      value = 1;
    }

    soLuong[hangHoa.maHangHoa!] = value;

    notifyListeners();
  }

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

  int laySoLuong(HangHoa hangHoa) {
    return soLuong[hangHoa.maHangHoa] ?? 1;
  }

  double get tongTien {
    double tong = 0;

    for (var hh in dsHangHoaChon) {
      tong += (hh.giaBan ?? 0) * laySoLuong(hh);
    }

    return tong;
  }

  String formatTien(double tien) {
    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  // void taoMaHoaDon() {
  //   DateTime now = DateTime.now();

  //   String nam = now.year.toString();

  //   String thang = now.month.toString().padLeft(2, '0');

  //   String ngay = now.day.toString().padLeft(2, '0');

  //   String stt = sttHoaDon.toString().padLeft(3, '0');

  //   maHoaDon = "TH$nam$thang$ngay$stt";

  //   sttHoaDon++;

  //   notifyListeners();
  // }

  Future<bool> luu() async {
    if (!kiemTraDuLieu()) return false;
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final dto = HoaDonTapHoaDTO(
        maHoaDon: maHoaDon,
        idnt: nguoiThueTro ? selectedNguoiThue?.idnt : null,
        ngayBan: DateTime.now(),
        tongTien: tongTien,
        chiTietTapHoa: dsHangHoaChon
            .map(
              (hh) => ChiTietTapHoa(
                maHangHoa: hh.maHangHoa!,
                soLuong: laySoLuong(hh),
              ),
            )
            .toList(),
        phieuThuHdTh: coPhieuThu
            ? PhieuThuHdTh(
                ngayThu: DateTime.now(),
                soTien: tongTien,
                nguoiDong: !nguoiThueTro
                    ? (txtNguoiMua.text.trim().isNotEmpty
                          ? txtNguoiMua.text.trim()
                          : (selectedNguoiThue?.hoTen ?? ""))
                    : (selectedNguoiThue?.hoTen ?? ""),
              )
            : null,
      );

      if (dto.maHoaDon != '') {
        return await _hoaDonTapHoaProvider.capNhat(dto);
      } else {
        final result = await _hoaDonTapHoaProvider.them(dto);
        return result != null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _nguoiThueProvider.removeListener(_onNguoiThueUpdate);

    txtNgayMua.dispose();
    txtNguoiDongTien.dispose();
    txtNguoiMua.dispose();

    super.dispose();
  }
}
