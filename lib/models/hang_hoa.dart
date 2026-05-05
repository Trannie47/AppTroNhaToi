class HangHoa {
  final int? maHangHoa;
  final String? tenHangHoa;
  final double? giaNhap;
  final double? giaBan;

  HangHoa({this.maHangHoa, this.tenHangHoa, this.giaNhap, this.giaBan});

  factory HangHoa.fromMap(Map<String, dynamic> map) {
    return HangHoa(
      maHangHoa: map['maHangHoa'] as int?,
      tenHangHoa: map['tenHangHoa'] as String?,
      giaNhap: (map['giaNhap'] as num?)?.toDouble(),
      giaBan: (map['giaBan'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHangHoa != null) 'maHangHoa': maHangHoa,
      'tenHangHoa': tenHangHoa,
      'giaNhap': giaNhap,
      'giaBan': giaBan,
    };
  }

  HangHoa copyWith({
    int? maHangHoa,
    String? tenHangHoa,
    double? giaNhap,
    double? giaBan,
  }) {
    return HangHoa(
      maHangHoa: maHangHoa ?? this.maHangHoa,
      tenHangHoa: tenHangHoa ?? this.tenHangHoa,
      giaNhap: giaNhap ?? this.giaNhap,
      giaBan: giaBan ?? this.giaBan,
    );
  }

  @override
  String toString() {
    return 'HangHoa(maHangHoa: $maHangHoa, tenHangHoa: $tenHangHoa, '
        'giaNhap: $giaNhap, giaBan: $giaBan)';
  }
}
