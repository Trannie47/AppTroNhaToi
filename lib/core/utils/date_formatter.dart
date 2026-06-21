import 'package:flutter/material.dart';

String formatDateVN(DateTime date) {
  const days = [
    "Chủ Nhật",
    "Thứ Hai",
    "Thứ Ba",
    "Thứ Tư",
    "Thứ Năm",
    "Thứ Sáu",
    "Thứ Bảy",
  ];

  String dayName = days[date.weekday % 7];

  return "$dayName, ${date.day} tháng ${date.month} · ${date.year}";
}

// Hàm định dạng ngày theo kiểu "dd/MM/yyyy"
String formatDate(DateTime? date) {
  if (date == null) return "";
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();
  return "$day/$month/$year";
}

String? kiemTraNgay(
  String text, {
  int minYear = 1900,
  int? maxYear,
  bool khongLonHonHienTai = false,
}) {
  if (text.trim().isEmpty) {
    return "Vui lòng nhập ngày";
  }

  try {
    List<String> arr = text.split('/');

    if (arr.length != 3) {
      return "Định dạng phải là dd/MM/yyyy";
    }

    int day = int.parse(arr[0]);
    int month = int.parse(arr[1]);
    int year = int.parse(arr[2]);

    maxYear ??= DateTime.now().year;

    if (year < minYear || year > maxYear) {
      return "Năm không hợp lệ";
    }

    if (month < 1 || month > 12) {
      return "Tháng phải từ 1 đến 12";
    }

    DateTime date = DateTime(year, month, day);

    if (date.day != day || date.month != month || date.year != year) {
      return "Ngày không hợp lệ";
    }

    if (khongLonHonHienTai && date.isAfter(DateTime.now())) {
      return "Ngày không được lớn hơn hôm nay";
    }

    return null;
  } catch (_) {
    return "Ngày không hợp lệ";
  }
}

DateTime chuyenNgay(String text) {
  List<String> arr = text.split('/');

  return DateTime(int.parse(arr[2]), int.parse(arr[1]), int.parse(arr[0]));
}

Future<DateTime?> chonNgayChuan(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2020),
    lastDate: lastDate ?? DateTime(2100),
  );
}
