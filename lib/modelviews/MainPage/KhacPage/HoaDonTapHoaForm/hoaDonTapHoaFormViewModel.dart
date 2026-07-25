import 'package:AppTroNhaToi/Provider/chi_tiet_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_thu_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HoaDonTapHoaDTO.dart';
import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoaPage/chiTietHoaDonTapHoaPage_Model.dart';
import 'package:flutter/material.dart';

class HoaDonTapHoaFormViewModel extends ChangeNotifier {
  final NguoiThueProvider _nguoiThueProvider;
  final HoaDonTapHoaProvider _hoaDonTapHoaProvider;
  final ChiTietTapHoaProvider _chiTietHoaDonTapHoaProvider;
  final PhieuThuHdThProvider _phieuThuHdThProvider;

  bool nguoiThueTro = true;
  bool coPhieuThu = true;
  bool isXacNhanPhieuThu = false;
  double SoTienConThieu = 0;

  String? errNguoiThue;
  String? errHangHoa;

  final txtNgayMua = TextEditingController();
  final txtNguoiDongTien = TextEditingController();
  final txtNguoiMua = TextEditingController();

  List<NguoiThue> dsNguoiThue = [];
  NguoiThue? selectedNguoiThue;
  PhieuThuHdTh? phieuThu;

  String maHoaDon = "";

  bool _isLoading = false;
  bool get isLoading =>
      _isLoading ||
      _chiTietHoaDonTapHoaProvider.isLoading ||
      _phieuThuHdThProvider.isLoading;

  // Danh sách hàng hóa đã chọn trong form (editable, người dùng thêm/bớt)
  List<chiTietHoaDonTapHoaPageModel> dsHangHoaChon = [];
  List<chiTietHoaDonTapHoaPageModel> get list =>
      List.unmodifiable(dsHangHoaChon);

  List<PhieuThuHdTh> dsPhieuThu = [];
  List<PhieuThuHdTh> get listPhieuThu => List.unmodifiable(dsPhieuThu);

  HoaDonTapHoaFormViewModel(
    this._nguoiThueProvider,
    this._hoaDonTapHoaProvider,
    this._chiTietHoaDonTapHoaProvider,
    this._phieuThuHdThProvider, {
    HoaDonTapHoa? hoaDonEdit,
  }) {
    _nguoiThueProvider.addListener(_onNguoiThueUpdate);
    _chiTietHoaDonTapHoaProvider.addListener(_onChiTietHoaDonTapHoaUpdate);
    _phieuThuHdThProvider.addListener(_onPhieuThuUpdate);

    dsNguoiThue = List.from(_nguoiThueProvider.list);

    Future.microtask(() async {
      if (_nguoiThueProvider.list.isEmpty) {
        await _nguoiThueProvider.fetchAll();
      } else {
        _onNguoiThueUpdate();
      }

      if (hoaDonEdit != null &&
          hoaDonEdit.maHoaDon != null &&
          hoaDonEdit.maHoaDon!.isNotEmpty) {
        maHoaDon = hoaDonEdit.maHoaDon!;
        isXacNhanPhieuThu = false;
        await Future.wait([
          _chiTietHoaDonTapHoaProvider.fetchByMaHoaDon(maHoaDon),
          _phieuThuHdThProvider.fetchByMaHoaDon(maHoaDon),
        ]);

        _onChiTietHoaDonTapHoaUpdate();
        _onPhieuThuUpdate();
      }
    });

    txtNgayMua.text = hoaDonEdit?.ngayBan != null
        ? formatDate(hoaDonEdit?.ngayBan!)
        : formatDate(DateTime.now());
  }

  Future<void> refresh() async {
    await _nguoiThueProvider.fetchAll();
  }

  void _onNguoiThueUpdate() {
    dsNguoiThue = List.from(_nguoiThueProvider.list);
    notifyListeners();
  }

  // Đồng bộ dữ liệu chi tiết tạp hóa từ provider vào danh sách đang chỉnh sửa
  void _onChiTietHoaDonTapHoaUpdate() {
    if (maHoaDon.isNotEmpty) {
      dsHangHoaChon = List.from(_chiTietHoaDonTapHoaProvider.list);
    }
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

      dsPhieuThu.clear();
      isXacNhanPhieuThu = false;

      errNguoiThue = null;
    }

    notifyListeners();
  }

  void themHangHoa(HangHoa hangHoa) {
    if (hangHoa.maHangHoa == null) return;

    final index = dsHangHoaChon.indexWhere(
      (e) => e.hangHoa.maHangHoa == hangHoa.maHangHoa,
    );

    if (index == -1) {
      dsHangHoaChon.add(
        chiTietHoaDonTapHoaPageModel(
          hangHoa: hangHoa,
          chiTietTapHoa: ChiTietTapHoa(
            maHangHoa: hangHoa.maHangHoa!,
            soLuong: 1,
          ),
        ),
      );
    } else {
      final item = dsHangHoaChon[index];

      dsHangHoaChon[index] = chiTietHoaDonTapHoaPageModel(
        hangHoa: item.hangHoa,
        chiTietTapHoa: item.chiTietTapHoa.copyWith(
          soLuong: (item.chiTietTapHoa.soLuong ?? 0) + 1,
        ),
      );
    }
    tinhSoTienConThieu();
    notifyListeners();
  }

  void tangSoLuong(chiTietHoaDonTapHoaPageModel item) {
    final index = dsHangHoaChon.indexWhere(
      (e) => e.hangHoa.maHangHoa == item.hangHoa.maHangHoa,
    );

    if (index == -1) return;

    final sl = dsHangHoaChon[index].chiTietTapHoa.soLuong ?? 0;

    dsHangHoaChon[index] = chiTietHoaDonTapHoaPageModel(
      hangHoa: item.hangHoa,
      chiTietTapHoa: item.chiTietTapHoa.copyWith(soLuong: sl + 1),
    );
    tinhSoTienConThieu();
    notifyListeners();
  }

  void capNhatSoLuong(chiTietHoaDonTapHoaPageModel item, int value) {
    if (value <= 0) value = 1;

    final index = dsHangHoaChon.indexWhere(
      (e) => e.hangHoa.maHangHoa == item.hangHoa.maHangHoa,
    );

    if (index == -1) return;

    dsHangHoaChon[index] = chiTietHoaDonTapHoaPageModel(
      hangHoa: item.hangHoa,
      chiTietTapHoa: item.chiTietTapHoa.copyWith(soLuong: value),
    );
    tinhSoTienConThieu();

    notifyListeners();
  }

  void giamSoLuong(chiTietHoaDonTapHoaPageModel item) {
    final index = dsHangHoaChon.indexWhere(
      (e) => e.hangHoa.maHangHoa == item.hangHoa.maHangHoa,
    );

    if (index == -1) return;

    final sl = dsHangHoaChon[index].chiTietTapHoa.soLuong ?? 1;
    if (sl > 1) {
      dsHangHoaChon[index] = chiTietHoaDonTapHoaPageModel(
        hangHoa: item.hangHoa,
        chiTietTapHoa: item.chiTietTapHoa.copyWith(soLuong: sl - 1),
      );
    } else {
      dsHangHoaChon.removeAt(index);
    }
    tinhSoTienConThieu();

    notifyListeners();
  }

  double get tongTien {
    double tong = 0;

    for (final item in dsHangHoaChon) {
      tong += (item.hangHoa.giaBan ?? 0) * (item.chiTietTapHoa.soLuong ?? 0);
    }

    return tong;
  }

  String formatTien(double tien) {
    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

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
                maChiTietHoaDon: hh.chiTietTapHoa.maChiTietHoaDon ?? -1,
                maHangHoa: hh.hangHoa.maHangHoa!,
                maHoaDon: maHoaDon,
                soLuong: hh.chiTietTapHoa.soLuong ?? 1,
              ),
            )
            .toList(),
        phieuThuHdTh: dsPhieuThu.isNotEmpty
            ? dsPhieuThu
                  .map(
                    (e) => e.copyWith(
                      ngayThu: e.ngayThu ?? DateTime.now(),
                      soTien: e.soTien ?? 0,
                      nguoiDong: !nguoiThueTro
                          ? (txtNguoiMua.text.trim().isNotEmpty
                                ? txtNguoiMua.text.trim()
                                : (selectedNguoiThue?.hoTen ?? ""))
                          : (selectedNguoiThue?.hoTen ?? ""),
                    ),
                  )
                  .toList()
            : [],
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

  void tinhSoTienConThieu() {
    final daThu = dsPhieuThu.fold<double>(
      0,
      (tong, item) => tong + (item.soTien ?? 0),
    );

    SoTienConThieu = tongTien - daThu;

    if (SoTienConThieu.abs() < 0.01) {
      SoTienConThieu = 0;
    }

    if (SoTienConThieu < 0) {
      SoTienConThieu = 0;
    }

    notifyListeners();
  }

  bool get hienNutThemPhieuThu {
    return nguoiThueTro &&
        !isXacNhanPhieuThu &&
        dsHangHoaChon.isNotEmpty &&
        SoTienConThieu > 0;
  }

  void themPhieuThu() {
    dsPhieuThu.add(PhieuThuHdTh());
    isXacNhanPhieuThu = true;
    tinhSoTienConThieu();
    notifyListeners();
  }

  void _onPhieuThuUpdate() {
    dsPhieuThu = List.from(_phieuThuHdThProvider.list);
    tinhSoTienConThieu();
    notifyListeners();
  }

  Future<void> chonNgay(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      lastDate: DateTime.now(),
    );

    if (ngay != null) {
      controller.text = formatDate(ngay);

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _nguoiThueProvider.removeListener(_onNguoiThueUpdate);
    _chiTietHoaDonTapHoaProvider.removeListener(_onChiTietHoaDonTapHoaUpdate);
    _phieuThuHdThProvider.removeListener(_onPhieuThuUpdate);

    txtNgayMua.dispose();
    txtNguoiDongTien.dispose();
    txtNguoiMua.dispose();

    super.dispose();
  }
}
