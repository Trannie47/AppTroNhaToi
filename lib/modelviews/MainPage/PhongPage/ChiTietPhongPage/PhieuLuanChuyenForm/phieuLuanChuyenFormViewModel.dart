import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_luan_chuyen_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/ItemHopDong.dart';
import 'package:flutter/material.dart';

class PhieuLuanChuyenFormViewModel extends ChangeNotifier {
  final HopDongProvider hopDongProvider;
  final PhongProvider phongProvider;
  final PhieuLuanChuyenProvider phieuLuanChuyenProvider;

  PhieuLuanChuyenFormViewModel({
    required this.hopDongProvider,
    required this.phongProvider,
    required this.phieuLuanChuyenProvider,
  });

  PhieuLuanChuyen? _item;
  int? _phongCuIdCoDinh;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  // ===== Dữ liệu chọn =====
  String? hopDongDaChonId;
  int? phongMoiDaChonId;

  /// Phòng mới hiện tại của phiếu đang sửa, dùng để bổ sung vào dropdown
  /// nếu nó không còn nằm trong danh sách "còn chỗ trống" trả về từ backend.
  ItemPhong? _phongMoiHienTaiCoDinh;

  final txtTuNgay = TextEditingController();
  final txtDenNgay = TextEditingController();
  final txtLyDo = TextEditingController();
  final txtChiPhi = TextEditingController();
  final txtGhiChu = TextEditingController();

  // ===== Lỗi validate =====
  String? errHopDong;
  String? errPhongMoi;
  String? errTuNgay;
  String? errDenNgay;
  String? errLyDo;
  String? errChiPhi;
  String? errGhiChu;

  List<ItemHopDong> get dsHopDong =>
      hopDongProvider.dsHopDongTheoPhong; // backend đã lọc còn hạn

  /// Danh sách phòng có thể chuyển tới, phụ thuộc hợp đồng đã chọn.
  /// Nếu đang sửa phiếu và phòng mới hiện tại không nằm trong danh sách
  /// backend trả về (do đã hết chỗ), tự bổ sung nó vào để dropdown chọn được.
  List<ItemPhong> get dsPhongCoTheChon {
    final list = phongProvider.dsPhongCoTheLuanChuyen;

    if (_phongMoiHienTaiCoDinh != null &&
        !list.any((p) => p.phongId == _phongMoiHienTaiCoDinh!.phongId)) {
      return [_phongMoiHienTaiCoDinh!, ...list];
    }

    return list;
  }

  ItemHopDong? get hopDongDaChon => dsHopDong
      .where((hd) => hd.hopDongId == hopDongDaChonId)
      .cast<ItemHopDong?>()
      .firstOrNull;

  bool get isEdit => _item != null;

  Future<void> init(PhieuLuanChuyen? item, {int? phongCuIdCoDinh}) async {
    _item = item;
    _phongCuIdCoDinh = phongCuIdCoDinh;

    _isLoading = true;
    notifyListeners();

    try {
      if (phongCuIdCoDinh != null) {
        await hopDongProvider.getHopDongByPhong(phongCuIdCoDinh);
      }

      if (item != null) {
        hopDongDaChonId = item.hopDongId;
        phongMoiDaChonId = item.phongMoiId;
        txtTuNgay.text = formatDate(item.tuNgay);
        txtDenNgay.text = formatDate(item.denNgay);
        txtLyDo.text = item.lyDoLuanChuyen ?? '';
        txtChiPhi.text = item.chiPhi != null
            ? intOf(item.chiPhi).toString()
            : '';
        txtGhiChu.text = item.ghiChu ?? '';

        // Đang sửa phiếu có sẵn hợp đồng -> load luôn danh sách phòng khả dụng
        if (hopDongDaChonId != null) {
          await phongProvider.getCoTheLuanChuyenByHopDong(hopDongDaChonId!);
        }

        // Nếu phòng mới hiện tại của phiếu không còn trong ds "còn chỗ trống"
        // (do đã đầy/đã bị luân chuyển đi chỗ khác) -> fetch riêng để bổ sung vào dropdown
        if (item.phongMoiId != null &&
            !phongProvider.dsPhongCoTheLuanChuyen.any(
              (p) => p.phongId == item.phongMoiId,
            )) {
          try {
            _phongMoiHienTaiCoDinh = await phongProvider.getInforPhong(
              item.phongMoiId!,
            );
          } catch (_) {
            _phongMoiHienTaiCoDinh = null;
          }
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void chonHopDong(String? hopDongId) {
    hopDongDaChonId = hopDongId;
    phongMoiDaChonId =
        null; // đổi hợp đồng -> danh sách phòng khả dụng đổi theo
    _phongMoiHienTaiCoDinh =
        null; // đổi hợp đồng -> phòng cố định cũ không còn liên quan
    errHopDong = null;
    errPhongMoi = null;
    notifyListeners();

    if (hopDongId != null) {
      phongProvider.getCoTheLuanChuyenByHopDong(hopDongId);
    }
  }

  void chonPhongMoi(int? phongId) {
    phongMoiDaChonId = phongId;
    errPhongMoi = null;
    notifyListeners();
  }

  Future<void> chonNgayBatDau(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime ngayHienTai;
    try {
      ngayHienTai = controller.text.isNotEmpty
          ? (chuyenNgay(controller.text) ?? DateTime.now())
          : DateTime.now();
    } catch (_) {
      ngayHienTai = DateTime.now();
    }

    final ngayChon = await showDatePicker(
      context: context,
      initialDate: ngayHienTai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (ngayChon != null) {
      controller.text = formatDate(ngayChon);

      final ngayKetThucHienTai = chuyenNgay(txtDenNgay.text);
      if (ngayKetThucHienTai != null && ngayKetThucHienTai.isBefore(ngayChon)) {
        txtDenNgay.text = formatDate(ngayChon);
      }

      notifyListeners();
    }
  }

  Future<void> chonNgayKetThuc(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final ngayBatDau = chuyenNgay(txtTuNgay.text);
    final minDate = ngayBatDau ?? DateTime(2000);

    DateTime ngayHienTai;
    try {
      final ngayDangCo = controller.text.isNotEmpty
          ? chuyenNgay(controller.text)
          : null;

      ngayHienTai = (ngayDangCo != null && !ngayDangCo.isBefore(minDate))
          ? ngayDangCo
          : minDate;
    } catch (_) {
      ngayHienTai = minDate;
    }

    final ngayChon = await showDatePicker(
      context: context,
      initialDate: ngayHienTai,
      firstDate: minDate,
      lastDate: DateTime(2100),
    );

    if (ngayChon != null) {
      controller.text = formatDate(ngayChon);
      notifyListeners();
    }
  }

  bool _validate() {
    bool hopLe = true;

    errHopDong = null;
    errPhongMoi = null;
    errTuNgay = null;
    errDenNgay = null;
    errLyDo = null;
    errChiPhi = null;
    errGhiChu = null;

    if (hopDongDaChonId == null || hopDongDaChonId!.isEmpty) {
      errHopDong = "Vui lòng chọn hợp đồng";
      hopLe = false;
    }

    if (phongMoiDaChonId == null) {
      errPhongMoi = "Vui lòng chọn phòng mới";
      hopLe = false;
    } else if (phongMoiDaChonId == _phongCuIdCoDinh) {
      errPhongMoi = "Phòng mới phải khác phòng hiện tại";
      hopLe = false;
    }

    final tuNgay = chuyenNgay(txtTuNgay.text);
    final denNgay = chuyenNgay(txtDenNgay.text);

    if (txtTuNgay.text.isNotEmpty && tuNgay == null) {
      errTuNgay = "Ngày không hợp lệ";
      hopLe = false;
    }

    if (txtDenNgay.text.isNotEmpty && denNgay == null) {
      errDenNgay = "Ngày không hợp lệ";
      hopLe = false;
    }

    if (tuNgay != null && denNgay != null && denNgay.isBefore(tuNgay)) {
      errDenNgay = "Ngày kết thúc phải sau ngày bắt đầu";
      hopLe = false;
    }

    notifyListeners();
    return hopLe;
  }

  Future<PhieuLuanChuyen?> luu() async {
    if (!_validate()) return null;

    _isSaving = true;
    notifyListeners();

    try {
      final data = PhieuLuanChuyen(
        chiTietLuanChuyenID: _item?.chiTietLuanChuyenID,
        hopDongId: hopDongDaChonId,
        phongMoiId: phongMoiDaChonId,
        tuNgay: chuyenNgay(txtTuNgay.text),
        denNgay: chuyenNgay(txtDenNgay.text),
        lyDoLuanChuyen: strOf(txtLyDo.text.trim()),
        chiPhi: numOf(txtChiPhi.text.replaceAll('.', '').replaceAll(',', '')),
        ghiChu: strOf(txtGhiChu.text.trim()),
      );

      if (isEdit) {
        final ok = await phieuLuanChuyenProvider.capNhat(data);
        return ok ? data : null;
      } else {
        return await phieuLuanChuyenProvider.them(data);
      }
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    txtTuNgay.dispose();
    txtDenNgay.dispose();
    txtLyDo.dispose();
    txtChiPhi.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}
