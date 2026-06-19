class ChiTietTapHoa {
  final int? maChiTietHoaDon;
  final String? maHoaDon; // FK -> hoadontaphoa.maHoaDon
  final int? maHangHoa; // FK -> hanghoa.maHangHoa
  final int? soLuong;

  ChiTietTapHoa({
    this.maChiTietHoaDon,
    this.maHoaDon,
    this.maHangHoa,
    this.soLuong,
  });

  factory ChiTietTapHoa.fromMap(Map<String, dynamic> map) {
    return ChiTietTapHoa(
      maChiTietHoaDon: map['maChiTietHoaDon'] as int?,
      maHoaDon: map['maHoaDon'] as String?,
      maHangHoa: map['maHangHoa'] as int?,
      soLuong: map['soLuong'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maChiTietHoaDon != null) 'maChiTietHoaDon': maChiTietHoaDon,
      'maHoaDon': maHoaDon,
      'maHangHoa': maHangHoa,
      'soLuong': soLuong,
    };
  }

  ChiTietTapHoa copyWith({
    int? maChiTietHoaDon,
    String? maHoaDon,
    int? maHangHoa,
    int? soLuong,
  }) {
    return ChiTietTapHoa(
      maChiTietHoaDon: maChiTietHoaDon ?? this.maChiTietHoaDon,
      maHoaDon: maHoaDon ?? this.maHoaDon,
      maHangHoa: maHangHoa ?? this.maHangHoa,
      soLuong: soLuong ?? this.soLuong,
    );
  }

  @override
  String toString() {
    return 'ChiTietTapHoa(maChiTietHoaDon: $maChiTietHoaDon, '
        'maHoaDon: $maHoaDon, maHangHoa: $maHangHoa, soLuong: $soLuong)';
  }
}
