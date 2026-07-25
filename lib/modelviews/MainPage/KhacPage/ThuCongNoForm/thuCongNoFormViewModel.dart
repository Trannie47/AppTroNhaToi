import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_thu_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/ThuCongNoDTO.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';
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

  List<ThuCongNoFormModel> listNguoiThue = [];

  ThuCongNoFormModel? nguoiThue;
  String? errNguoiThue;

  double tongCongNo = 0;

  bool get isLoading => _provider.isLoading;

  Future<void> init() async {
    await _nguoiThueProvider.fetchNguoiThueCongNoTapHoa();

    listNguoiThue = _nguoiThueProvider.listCongNoTapHoa;
    notifyListeners();
  }

  Future<void> chonNguoiThue(ThuCongNoFormModel? value) async {
    nguoiThue = value;

    tongCongNo = value?.tongCongNoTapHoa ?? 0;

    notifyListeners();
  }

  Future<void> chonNgayThu(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: dateOf(txtNgayThu.text) ?? now,
      firstDate: DateTime(2020, 1, 1), // hoặc DateTime(1900, 1, 1)
      lastDate: now,
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
    // validate người thuê trước, hiện lỗi rõ ràng
    errNguoiThue = nguoiThue == null ? "Vui lòng chọn người thuê" : null;
    notifyListeners();

    final hopLeForm = formKey.currentState?.validate() ?? false;

    if (errNguoiThue != null || !hopLeForm) {
      return false;
    }

    final soTien = double.parse(
      txtSoTien.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    final dto = ThuCongNoDTO(
      idnt: nguoiThue!.nguoiThue.idnt,
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
