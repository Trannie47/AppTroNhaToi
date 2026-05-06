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
