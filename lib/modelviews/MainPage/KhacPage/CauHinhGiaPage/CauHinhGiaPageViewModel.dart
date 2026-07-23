import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';

import '../../../../models/cau_hinh_gia.dart';

class CauHinhGiaPageViewModel extends ChangeNotifier {
  final CauHinhGiaProvider provider;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController giaDienController = TextEditingController();
  final TextEditingController giaNuocController = TextEditingController();

  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  bool _isInitLoaded = false;
  bool get isInitLoaded => _isInitLoaded;

  CauHinhGiaPageViewModel({required this.provider});

  // Lấy dữ liệu ban đầu
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

  // Xử lý Lưu cấu hình giá
  Future<bool> saveConfig() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final giaDien = _parsePrice(giaDienController.text);
    final giaNuoc = _parsePrice(giaNuocController.text);

    final result = await provider.updateGia(giaDien, giaNuoc);
    return result != null;
  }

  @override
  void dispose() {
    giaDienController.dispose();
    giaNuocController.dispose();
    super.dispose();
  }
}