import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

class SuCoFormViewModel extends ChangeNotifier {
  final SuCoProvider _service;
  final PhongProvider _phongProvider;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  PhieuSuCo? _suCoDangSua;

  bool get isEditMode => _suCoDangSua != null;

  SuCoFormViewModel(
      this._service,
      this._phongProvider, {
        PhieuSuCo? suCoInput,
      }) {
    _phongProvider.addListener(_onPhongUpdate);

    Future.microtask(() async {
      if (_phongProvider.listPhong.isEmpty) {
        await _phongProvider.getListPhong();
      } else {
        _onPhongUpdate();
      }

      if (suCoInput != null) {
        loadDeSua(suCoInput);
      }
    });
  }

  final txtTenSuCo = TextEditingController();

  final txtNgayBatDau = TextEditingController();

  final txtNgayHoanThanh = TextEditingController();

  final txtChiPhi = TextEditingController();

  final txtGhiChu = TextEditingController();

  ///==========================
  /// Data
  ///==========================

  List<Phong> dsPhong = [];

  Phong? phong;

  int? trangThaiThongBao = 0;

  final List<Map<String, dynamic>> dsTrangThai = [
    {
      "value": 0,
      "text": "Chưa xử lý",
    },
    {
      "value": 1,
      "text": "Đang xử lý",
    },
    {
      "value": 2,
      "text": "Hoàn thành",
    },
  ];

  ///==========================
  /// Error
  ///==========================

  String? errTenSuCo;

  String? errPhong;

  String? errNgayBatDau;

  String? errNgayHoanThanh;

  String? errChiPhi;

  String? errTrangThai;

  String? errGhiChu;

  void loadDeSua(PhieuSuCo suCo) {
    _suCoDangSua = suCo;

    txtTenSuCo.text = suCo.tenSuCo ?? "";

    txtNgayBatDau.text = suCo.ngayBatDau != null
        ? formatDate(suCo.ngayBatDau)
        : "";

    txtNgayHoanThanh.text = suCo.ngayHoanThanh != null
        ? formatDate(suCo.ngayHoanThanh)
        : "";

    txtChiPhi.text = suCo.chiPhi != null
        ? suCo.chiPhi!.toStringAsFixed(0)
        : "";

    txtGhiChu.text = suCo.ghiChu ?? "";

    trangThaiThongBao = suCo.trangThaiThongBao;

    if (suCo.phongId != null) {
      try {
        phong = dsPhong.firstWhere(
              (e) => e.phongID == suCo.phongId,
        );
      } catch (_) {
        phong = null;
      }
    }

    notifyListeners();
  }

  bool kiemTraDuLieu() {
    errTenSuCo = null;
    errPhong = null;
    errNgayBatDau = null;
    errNgayHoanThanh = null;
    errChiPhi = null;
    errTrangThai = null;
    errGhiChu = null;

    bool hopLe = true;

    if (txtTenSuCo.text.trim().isEmpty) {
      errTenSuCo = "Vui lòng nhập tên sự cố";
      hopLe = false;
    }

    if (phong == null) {
      errPhong = "Vui lòng chọn phòng";
      hopLe = false;
    }

    errNgayBatDau = kiemTraNgay(
      txtNgayBatDau.text,
    );

    if (errNgayBatDau != null) {
      hopLe = false;
    }

    if (trangThaiThongBao == null) {
      errTrangThai = "Vui lòng chọn trạng thái";
      hopLe = false;
    }

    if (txtChiPhi.text.trim().isNotEmpty) {
      final value = numOf(
        txtChiPhi.text
            .replaceAll(",", "")
            .replaceAll(".", ""),
      );

      if (value < 0) {
        errChiPhi = "Chi phí không hợp lệ";
        hopLe = false;
      }
    }

    if (txtNgayBatDau.text.isNotEmpty &&
        txtNgayHoanThanh.text.isNotEmpty) {
      final ngayBatDau = chuyenNgay(txtNgayBatDau.text);
      final ngayHoanThanh = chuyenNgay(txtNgayHoanThanh.text);

      if (ngayHoanThanh.isBefore(ngayBatDau)) {
        errNgayHoanThanh =
        "Ngày hoàn thành phải lớn hơn hoặc bằng ngày bắt đầu";

        hopLe = false;
      }
    }

    notifyListeners();

    return hopLe;
  }

  Future<PhieuSuCo?> luu() async {
    if (!kiemTraDuLieu()) return null;

    if (_isLoading) return null;

    _isLoading = true;
    notifyListeners();

    try {
      final phieu = PhieuSuCo(
        suCoId: _suCoDangSua?.suCoId,
        phongId: phong?.phongID,
        tenSuCo: txtTenSuCo.text.trim(),
        ghiChu: txtGhiChu.text.trim().isEmpty
            ? null
            : txtGhiChu.text.trim(),
        ngayBatDau: txtNgayBatDau.text.trim().isEmpty
            ? null
            : chuyenNgay(txtNgayBatDau.text.trim()),

        ngayHoanThanh: txtNgayHoanThanh.text.trim().isEmpty
            ? null
            : chuyenNgay(txtNgayHoanThanh.text.trim()),

        trangThaiThongBao: trangThaiThongBao,
        chiPhi: txtChiPhi.text.trim().isEmpty
            ? 0
            : numOf(
          txtChiPhi.text
              .replaceAll(".", "")
              .replaceAll(",", ""),
        ),
      );

      if (isEditMode) {
        final ok = await _service.capNhat(phieu);

        return ok ? phieu : null;
      } else {
        return await _service.them(phieu);
      }
    } catch (_) {
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> xoa() async {
    if (_suCoDangSua == null) return false;

    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      return await _service.xoa(_suCoDangSua!.suCoId!);
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onPhongUpdate() {
    dsPhong = _phongProvider.listPhong
        .map(
          (e) => Phong(
        phongID: e.phongId,
        tenPhong: e.tenPhong,
        trangThai: e.trangThai,
        moTa: e.moTa,
        maLoaiPhong: e.maLoaiPhong,
        loaiPhong: e.loaiPhong,
      ),
    )
        .toList();

    notifyListeners();
  }



  void clear() {
    _suCoDangSua = null;

    txtTenSuCo.clear();
    txtNgayBatDau.clear();
    txtNgayHoanThanh.clear();
    txtChiPhi.clear();
    txtGhiChu.clear();

    phong = null;

    trangThaiThongBao = 0;

    errTenSuCo = null;
    errPhong = null;
    errNgayBatDau = null;
    errNgayHoanThanh = null;
    errChiPhi = null;
    errTrangThai = null;
    errGhiChu = null;

    notifyListeners();
  }

  Future<void> chonNgay(
      BuildContext context,
      TextEditingController controller,
      ) async {
    DateTime initialDate = DateTime.now();

    DateTime? current;

    if (controller.text.isNotEmpty) {
      current = chuyenNgay(controller.text);
    }

    if (current != null) {
      initialDate = current;
    }

    final picked = await chonNgayChuan(
      context,
      initialDate: initialDate,
    );

    if (picked != null) {
      controller.text = formatDate(picked);

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _phongProvider.removeListener(_onPhongUpdate);
    txtTenSuCo.dispose();
    txtNgayBatDau.dispose();
    txtNgayHoanThanh.dispose();
    txtChiPhi.dispose();
    txtGhiChu.dispose();

    super.dispose();
  }
}

