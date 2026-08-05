import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';
import 'package:AppTroNhaToi/Provider/cau_hinh_gia_xe_provider.dart';

import '../../../../models/cau_hinh_gia.dart';
import '../../../../models/cau_hinh_gia_xe.dart';

class CauHinhGiaPageViewModel extends ChangeNotifier {
  final CauHinhGiaProvider provider;
  final CauHinhGiaXeProvider providerXe;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController giaDienController = TextEditingController();
  final TextEditingController giaNuocController = TextEditingController();

  static const Map<int, String> tenLoaiXe = {
    0: 'Xe máy',
    1: 'Ô tô',
    2: 'Xe đạp',
  };
  final Map<int, TextEditingController> giaXeControllers = {
    0: TextEditingController(),
    1: TextEditingController(),
    2: TextEditingController(),
  };
  final Map<int, double> _giaXeBanDau = {0: 0, 1: 0, 2: 0};

  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  bool _isInitLoaded = false;
  bool get isInitLoaded => _isInitLoaded;

  CauHinhGiaPageViewModel({required this.provider, required this.providerXe});

  // Lấy dữ liệu ban đầu
  Future<void> loadData() async {
    final model = await provider.getGiaHienTai();
    if (model != null) {
      _fillDataToControllers(model);
    }

    final dsGiaXe = await providerXe.getAll();
    _fillGiaXeToControllers(dsGiaXe);

    _isInitLoaded = true;
    notifyListeners();
  }

  void _fillDataToControllers(CauHinhGia model) {
    giaDienController.text = _formatNumber(model.giaDien);
    giaNuocController.text = _formatNumber(model.giaNuoc);
  }

  void _fillGiaXeToControllers(List<CauHinhGiaXe> dsGiaXe) {
    for (final loaiXe in tenLoaiXe.keys) {
      double gia = 0.0;
      for (final e in dsGiaXe) {
        if (e.loaiXe == loaiXe) {
          gia = e.giaMacDinh;
          break;
        }
      }
      _giaXeBanDau[loaiXe] = gia;
      giaXeControllers[loaiXe]!.text = _formatNumber(gia);
    }
  }

  String _formatNumber(double val) {
    if (val <= 0) return "0";
    return _formatter.format(val.toInt()).replaceAll(',', '.');
  }

  double _parsePrice(String text) {
    final cleanText = text.replaceAll('.', '').replaceAll(',', '').trim();
    return double.tryParse(cleanText) ?? -1;
  }

  // Validator kiểm tra đơn giá
  String? validateGia(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập $label";
    }

    final price = _parsePrice(value);
    if (price < 0) {
      return "$label không hợp lệ (không được âm)";
    }

    return null;
  }

  Future<bool> saveConfig() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final giaDien = _parsePrice(giaDienController.text);
    final giaNuoc = _parsePrice(giaNuocController.text);

    final result = await provider.updateGia(giaDien, giaNuoc);

    // Chỉ gọi API cho những loại xe có giá thay đổi so với lúc tải lên
    bool xeThanhCong = true;
    for (final loaiXe in tenLoaiXe.keys) {
      final giaMoi = _parsePrice(giaXeControllers[loaiXe]!.text);
      if (giaMoi == _giaXeBanDau[loaiXe]) continue;

      final ketQua = await providerXe.update(
        loaiXe: loaiXe,
        giaMacDinh: giaMoi,
        tenLoaiXe: tenLoaiXe[loaiXe],
      );
      if (ketQua == null) {
        xeThanhCong = false;
      } else {
        _giaXeBanDau[loaiXe] = giaMoi;
      }
    }

    return result != null && xeThanhCong;
  }

  @override
  void dispose() {
    giaDienController.dispose();
    giaNuocController.dispose();
    for (final controller in giaXeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}