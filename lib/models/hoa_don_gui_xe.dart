class HoaDonGuiXe {
  final int? maHoaDon;

  final String? thangNam;

  final num? idPhuongTien;

  /// 0 = chưa thu
  /// 1 = đã thu
  /// 2 = không còn ở
  /// 3 = đã hủy
  final int? trangThai;

  HoaDonGuiXe({
    this.maHoaDon,
    this.thangNam,
    this.idPhuongTien,
    this.trangThai,
  });

  factory HoaDonGuiXe.fromMap(Map<String, dynamic> map) {
    return HoaDonGuiXe(
      maHoaDon: map['maHoaDon'] as int?,

      thangNam: map['thangNam'] as String?,

      idPhuongTien: map['idPhuongTien'] as num?,

      trangThai: map['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,

      'thangNam': thangNam,

      'idPhuongTien': idPhuongTien,

      'trangThai': trangThai,
    };
  }

  HoaDonGuiXe copyWith({
    int? maHoaDon,
    String? thangNam,
    String? bienSo,
    int? trangThai,
  }) {
    return HoaDonGuiXe(
      maHoaDon: maHoaDon ?? this.maHoaDon,

      thangNam: thangNam ?? this.thangNam,

      idPhuongTien: idPhuongTien ?? this.idPhuongTien,

      trangThai: trangThai ?? this.trangThai,
    );
  }

  @override
  String toString() {
    return 'HoaDonGuiXe('
        'maHoaDon: $maHoaDon, '
        'thangNam: $thangNam, '
        'idPhuongTien: $idPhuongTien, '
        'trangThai: $trangThai, '
        ')';
  }
}
