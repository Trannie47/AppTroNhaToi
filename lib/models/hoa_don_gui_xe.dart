class HoaDonGuiXe {
  final int? maHoaDon;
  final String? thangNam;
  final double? soTien;
  final String? bienSo; // FK -> phuongtien.bienSo

  HoaDonGuiXe({
    this.maHoaDon,
    this.thangNam,
    this.soTien,
    this.bienSo,
  });

  factory HoaDonGuiXe.fromMap(Map<String, dynamic> map) {
    return HoaDonGuiXe(
      maHoaDon: map['maHoaDon'] as int?,
      thangNam: map['thangNam'] as String?,
      soTien: (map['soTien'] as num?)?.toDouble(),
      bienSo: map['bienSo'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      'thangNam': thangNam,
      'soTien': soTien,
      'bienSo': bienSo,
    };
  }

  HoaDonGuiXe copyWith({
    int? maHoaDon,
    String? thangNam,
    double? soTien,
    String? bienSo,
  }) {
    return HoaDonGuiXe(
      maHoaDon: maHoaDon ?? this.maHoaDon,
      thangNam: thangNam ?? this.thangNam,
      soTien: soTien ?? this.soTien,
      bienSo: bienSo ?? this.bienSo,
    );
  }

  @override
  String toString() {
    return 'HoaDonGuiXe(maHoaDon: $maHoaDon, thangNam: $thangNam, '
        'soTien: $soTien, bienSo: $bienSo)';
  }
}
