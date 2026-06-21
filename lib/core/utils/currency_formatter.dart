import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatMoneyShort(num value) {
  if (value >= 1000000000) {
    double v = value / 1000000000;
    return "${_format(v)} tỷ";
  } else if (value >= 1000000) {
    double v = value / 1000000;
    return "${_format(v)} tr";
  } else if (value >= 1000) {
    double v = value / 1000;
    return "${_format(v)} K";
  } else {
    return value.toString();
  }
}

String _format(double number) {
  if (number % 1 == 0) {
    return number.toInt().toString();
  }
  return number.toStringAsFixed(1);
}

//Format tiền tệ có dấu phân cách hàng nghìn
String formatMoney(num? value) {
  if (value == null) {
    return "0đ";
  }
  return "${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ";
}

class DinhDangGiaVN extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat('#,###', 'vi_VN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String digits = newValue.text.replaceAll('.', '');

    int value = int.parse(digits);

    String newText = formatter.format(value).replaceAll(',', '.');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
