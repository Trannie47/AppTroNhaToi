class LoaiPhong {
  final int? maLoaiPhong;
  final double? dienTich;
  final bool? isMayLanh;
  final int? soNguoiToiDa;
  final double? giaTien;

  LoaiPhong({
    this.maLoaiPhong,
    this.dienTich,
    this.isMayLanh,
    this.soNguoiToiDa,
    this.giaTien,
  });

  factory LoaiPhong.fromMap(Map<String, dynamic> map) {
    return LoaiPhong(
      maLoaiPhong: map['maLoaiPhong'] as int?,
      dienTich: (map['dienTich'] as num?)?.toDouble(),
      isMayLanh: map['isMayLanh'] == 1 || map['isMayLanh'] == true,
      soNguoiToiDa: map['soNguoiToiDa'] as int?,
      giaTien: (map['giaTien'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maLoaiPhong != null) 'maLoaiPhong': maLoaiPhong,
      'dienTich': dienTich,
      'isMayLanh': isMayLanh == true ? 1 : 0,
      'soNguoiToiDa': soNguoiToiDa,
      'giaTien': giaTien,
    };
  }

  LoaiPhong copyWith({
    int? maLoaiPhong,
    double? dienTich,
    bool? isMayLanh,
    int? soNguoiToiDa,
    double? giaTien,
  }) {
    return LoaiPhong(
      maLoaiPhong: maLoaiPhong ?? this.maLoaiPhong,
      dienTich: dienTich ?? this.dienTich,
      isMayLanh: isMayLanh ?? this.isMayLanh,
      soNguoiToiDa: soNguoiToiDa ?? this.soNguoiToiDa,
      giaTien: giaTien ?? this.giaTien,
    );
  }

  @override
  String toString() {
    return 'LoaiPhong(maLoaiPhong: $maLoaiPhong, dienTich: $dienTich, '
        'isMayLanh: $isMayLanh, soNguoiToiDa: $soNguoiToiDa, giaTien: $giaTien)';
  }
}
