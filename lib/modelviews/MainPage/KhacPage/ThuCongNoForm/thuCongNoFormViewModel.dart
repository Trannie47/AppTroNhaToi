import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_thu_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/ThuCongNoDTO.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThuCongNoFormViewModel extends ChangeNotifier {
  final PhieuThuHdThProvider _provider;
  final NguoiThueProvider _nguoiThueProvider;

  ThuCongNoFormViewModel(this._provider, this._nguoiThueProvider) {
    txtSoTien = TextEditingController();

    txtNgayThu = TextEditingController(text: formatDate(DateTime.now()));
  }

  late TextEditingController txtSoTien;
  late TextEditingController txtNgayThu;

  final formKey = GlobalKey<FormState>();

  List<NguoiThue> listNguoiThue = [];

  NguoiThue? nguoiThue;

  double tongCongNo = 0;

  bool get isLoading => _provider.isLoading;

  Future<void> init() async {
    await _nguoiThueProvider.fetchAll();

    listNguoiThue = _nguoiThueProvider.list;

    notifyListeners();
  }

  Future<void> chonNguoiThue(NguoiThue? value) async {
    nguoiThue = value;

    if (value != null) {
      /// TODO:
      /// Gọi API lấy tổng công nợ
      ///
      /// tongCongNo = await ...
    } else {
      tongCongNo = 0;
    }

    notifyListeners();
  }

  Future<void> chonNgayThu(BuildContext context) async {
    final DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: dateOf(txtNgayThu.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (ngay == null) return;

    txtNgayThu.text = formatDate(ngay);

    notifyListeners();
  }

  String? validateSoTien() {
    if (txtSoTien.text.trim().isEmpty) {
      return "Vui lòng nhập số tiền";
    }

    final money =
        double.tryParse(txtSoTien.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    if (money <= 0) {
      return "Số tiền phải lớn hơn 0";
    }

    if (tongCongNo > 0 && money > tongCongNo) {
      return "Số tiền không được vượt quá công nợ";
    }

    return null;
  }

  Future<bool> thuCongNo() async {
    if (nguoiThue == null) {
      return false;
    }

    if (!formKey.currentState!.validate()) {
      return false;
    }

    final soTien = double.parse(
      txtSoTien.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    final dto = ThuCongNoDTO(
      idnt: nguoiThue!.idnt,
      soTien: soTien,
      ngayThu: dateOf(txtNgayThu.text),
    );

    return await _provider.thuCongNo(dto);
  }

  String get tongCongNoText {
    return NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    ).format(tongCongNo);
  }

  @override
  void dispose() {
    txtSoTien.dispose();
    txtNgayThu.dispose();
    super.dispose();
  }
}
