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
