class HoaDonGuiXe {
  final int? maHoaDon;

  final String? thangNam;

  final num? idPhuongTien;

  final DateTime? ngayLap;

  final num? soTien;

  /// 0 = chưa thu
  /// 1 = đã thu
  final int? trangThai;

  HoaDonGuiXe({
    this.maHoaDon,
    this.thangNam,
    this.idPhuongTien,
    this.ngayLap,
    this.soTien,
    this.trangThai,
  });

  factory HoaDonGuiXe.fromMap(Map<String, dynamic> map) {
    return HoaDonGuiXe(
      maHoaDon: map['maHoaDon'] as int?,
      thangNam: map['thangNam'] as String?,
      idPhuongTien: map['idPT'] ?? map['idPhuongTien'] as num?,
      ngayLap: map['ngayLap'] != null
          ? DateTime.parse(map['ngayLap'])
          : null,
      soTien: map['soTien'] != null ? num.tryParse(map['soTien'].toString()) : null,
      trangThai: map['TrangThai'] ?? map['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      'thangNam': thangNam,
      'idPhuongTien': idPhuongTien,
      'ngayLap': ngayLap?.toIso8601String(),
      'soTien': soTien,
      'trangThai': trangThai,
    };
  }

  HoaDonGuiXe copyWith({
    int? maHoaDon,
    String? thangNam,
    num? idPhuongTien,
    DateTime? ngayLap,
    num? soTien,
    int? trangThai,
  }) {
    return HoaDonGuiXe(
      maHoaDon: maHoaDon ?? this.maHoaDon,
      thangNam: thangNam ?? this.thangNam,
      idPhuongTien: idPhuongTien ?? this.idPhuongTien,
      ngayLap: ngayLap ?? this.ngayLap,
      soTien: soTien ?? this.soTien,
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
        'soTien: $soTien, '
        'trangThai: $trangThai, '
        ')';
  }
}