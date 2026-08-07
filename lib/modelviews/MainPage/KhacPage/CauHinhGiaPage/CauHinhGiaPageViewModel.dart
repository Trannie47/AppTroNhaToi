import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';

import '../../../../models/cau_hinh_gia.dart';

class CauHinhGiaPageViewModel extends ChangeNotifier {
  final CauHinhGiaProvider provider;

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

  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  bool _isInitLoaded = false;
  bool get isInitLoaded => _isInitLoaded;

  CauHinhGiaPageViewModel({required this.provider});

  Future<void> loadData() async {
    final model = await provider.getGiaHienTai();
    if (model != null) {
      _fillDataToControllers(model);
    }

    _isInitLoaded = true;
    notifyListeners();
  }

  void _fillDataToControllers(CauHinhGia model) {
    giaDienController.text = _formatNumber(model.giaDien);
    giaNuocController.text = _formatNumber(model.giaNuoc);
    giaXeControllers[0]!.text = _formatNumber(model.giaXeMay);
    giaXeControllers[1]!.text = _formatNumber(model.giaXeHoi);
    giaXeControllers[2]!.text = _formatNumber(model.giaXeDap);
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

    final result = await provider.updateGia(
      giaDien: giaDien,
      giaNuoc: giaNuoc,
      giaXeMay: _parsePrice(giaXeControllers[0]!.text),
      giaXeHoi: _parsePrice(giaXeControllers[1]!.text),
      giaXeDap: _parsePrice(giaXeControllers[2]!.text),
    );

    return result != null;
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