class HoaDonGuiXe {
  final int? maHoaDon;

  final String? thangNam;

  final num? idPhuongTien;

  final DateTime? ngayLap;

  /// 0 = chưa thu
  /// 1 = đã thu
  /// 2 = không còn ở
  /// 3 = đã hủy
  final int? trangThai;

  HoaDonGuiXe({
    this.maHoaDon,
    this.thangNam,
    this.idPhuongTien,
    this.ngayLap,
    this.trangThai,
  });

  factory HoaDonGuiXe.fromMap(Map<String, dynamic> map) {
    return HoaDonGuiXe(
      maHoaDon: map['maHoaDon'] as int?,

      thangNam: map['thangNam'] as String?,

      idPhuongTien: map['idPhuongTien'] as num?,

      ngayLap:
      map['ngayLap'] != null
          ? DateTime.parse(map['ngayLap'])
          : null,

      trangThai: map['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,

      'thangNam': thangNam,

      'idPhuongTien': idPhuongTien,

      'ngayLap': ngayLap?.toIso8601String(),

      'trangThai': trangThai,
    };
  }

  HoaDonGuiXe copyWith({
    int? maHoaDon,
    String? thangNam,
    num? idPhuongTien,
    DateTime? ngayLap,
    int? trangThai,
  }) {
    return HoaDonGuiXe(
      maHoaDon: maHoaDon ?? this.maHoaDon,

      thangNam: thangNam ?? this.thangNam,

      idPhuongTien: idPhuongTien ?? this.idPhuongTien,

      ngayLap: ngayLap ?? this.ngayLap,

      trangThai: trangThai ?? this.trangThai,
    );
  }

  @override
  String toString() {
    return 'HoaDonGuiXe('
        'maHoaDon: $maHoaDon, '
        'thangNam: $thangNam, '
        'idPhuongTien: $idPhuongTien, '
        'ngayLap: $ngayLap, '
        'trangThai: $trangThai, '
        ')';
  }
}