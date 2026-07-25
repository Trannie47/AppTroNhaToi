class PhieuThuHangThang {
  final int? maPhieuThu;
  final DateTime? ngayThu;
  final double? soTien;
  final String? ghiChu;
  final String? maHoaDon;

  PhieuThuHangThang({
    this.maPhieuThu,
    this.ngayThu,
    this.soTien,
    this.ghiChu,
    this.maHoaDon,
  });

  factory PhieuThuHangThang.fromMap(Map<String, dynamic> map) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return PhieuThuHangThang(
      maPhieuThu: parseInt(map['maPhieuThu']),
      ngayThu: map['ngayThu'] != null
          ? DateTime.tryParse(map['ngayThu'].toString())
          : null,
      soTien: parseDouble(map['soTien']), // Parse an toànDecimal/String từ Prisma
      ghiChu: map['ghiChu'] as String?,
      maHoaDon: map['maHoaDon']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maPhieuThu != null) 'maPhieuThu': maPhieuThu,
      if (ngayThu != null) 'ngayThu': ngayThu?.toIso8601String(),
      'soTien': soTien,
      'ghiChu': ghiChu,
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
    };
  }

  PhieuThuHangThang copyWith({
    int? maPhieuThu,
    DateTime? ngayThu,
    double? soTien,
    String? ghiChu,
    String? maHoaDon,
  }) {
    return PhieuThuHangThang(
      maPhieuThu: maPhieuThu ?? this.maPhieuThu,
      ngayThu: ngayThu ?? this.ngayThu,
      soTien: soTien ?? this.soTien,
      ghiChu: ghiChu ?? this.ghiChu,
      maHoaDon: maHoaDon ?? this.maHoaDon,
    );
  }

  @override
  String toString() {
    return 'PhieuThuHangThang(maPhieuThu: $maPhieuThu, ngayThu: $ngayThu, '
        'soTien: $soTien, ghiChu: $ghiChu, maHoaDon: $maHoaDon)';
  }
}