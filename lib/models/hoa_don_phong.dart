class HoaDonPhong {
  final String? maHoaDon;
  final String? hopDongId;
  final String? thangNam;
  final DateTime? ngayLap;
  final double? soTien;
  final String? chiTietJson;
  final int? trangThai;
  final String? ghiChu;

  HoaDonPhong({
    this.maHoaDon,
    this.hopDongId,
    this.thangNam,
    this.ngayLap,
    this.soTien,
    this.chiTietJson,
    this.trangThai,
    this.ghiChu,
  });

  double get tongTien => soTien ?? 0;

  // Hỗ trợ ép kiểu double an toàn (chấp nhận cả String, int, double)
  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val);
    return null;
  }

  // Hỗ trợ ép kiểu int an toàn
  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val);
    return null;
  }

  factory HoaDonPhong.fromMap(Map<String, dynamic> map) {
    return HoaDonPhong(
      maHoaDon: map['maHoaDon']?.toString(),
      hopDongId: map['hopDongId']?.toString() ?? map['HopDongID']?.toString(),
      thangNam: map['thangNam']?.toString(),
      ngayLap: map['ngayLap'] != null
          ? DateTime.tryParse(map['ngayLap'].toString())
          : null,
      soTien: _toDouble(map['soTien']) ?? _toDouble(map['tongTien']),
      chiTietJson: map['chiTietJson']?.toString(),
      trangThai: _toInt(map['trangThai']),
      ghiChu: map['ghiChu']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      if (hopDongId != null) 'hopDongId': hopDongId,
      'thangNam': thangNam,
      if (soTien != null) 'soTien': soTien,
      if (chiTietJson != null) 'chiTietJson': chiTietJson,
      if (trangThai != null) 'trangThai': trangThai,
      if (ghiChu != null) 'ghiChu': ghiChu,
      if (ngayLap != null) 'ngayLap': ngayLap?.toIso8601String(),
    };
  }
}
