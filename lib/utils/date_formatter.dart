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
