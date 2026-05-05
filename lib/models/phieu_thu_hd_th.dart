class PhieuThuHdTh {
  final int? maPhieuThu;
  final DateTime? ngayThu;
  final double? soTien;
  final String? nguoiDong;
  final int? maHoaDon; // FK -> hoadontaphoa.maHoaDon

  PhieuThuHdTh({
    this.maPhieuThu,
    this.ngayThu,
    this.soTien,
    this.nguoiDong,
    this.maHoaDon,
  });

  factory PhieuThuHdTh.fromMap(Map<String, dynamic> map) {
    return PhieuThuHdTh(
      maPhieuThu: map['maPhieuThu'] as int?,
      ngayThu: map['ngayThu'] != null
          ? DateTime.tryParse(map['ngayThu'] as String)
          : null,
      soTien: (map['soTien'] as num?)?.toDouble(),
      nguoiDong: map['nguoiDong'] as String?,
      maHoaDon: map['maHoaDon'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maPhieuThu != null) 'maPhieuThu': maPhieuThu,
      'ngayThu': ngayThu?.toIso8601String().split('T').first,
      'soTien': soTien,
      'nguoiDong': nguoiDong,
      'maHoaDon': maHoaDon,
    };
  }

  PhieuThuHdTh copyWith({
    int? maPhieuThu,
    DateTime? ngayThu,
    double? soTien,
    String? nguoiDong,
    int? maHoaDon,
  }) {
    return PhieuThuHdTh(
      maPhieuThu: maPhieuThu ?? this.maPhieuThu,
      ngayThu: ngayThu ?? this.ngayThu,
      soTien: soTien ?? this.soTien,
      nguoiDong: nguoiDong ?? this.nguoiDong,
      maHoaDon: maHoaDon ?? this.maHoaDon,
    );
  }

  @override
  String toString() {
    return 'PhieuThuHdTh(maPhieuThu: $maPhieuThu, ngayThu: $ngayThu, '
        'soTien: $soTien, nguoiDong: $nguoiDong, maHoaDon: $maHoaDon)';
  }
}
