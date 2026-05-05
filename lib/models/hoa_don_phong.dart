class HoaDonPhong {
  final int? maHoaDon;
  final String? thangNam;
  final double? soTien;
  final int? hopDongID;

  HoaDonPhong({
    this.maHoaDon,
    this.thangNam,
    this.soTien,
    this.hopDongID,
  });

  factory HoaDonPhong.fromMap(Map<String, dynamic> map) {
    return HoaDonPhong(
      maHoaDon: map['maHoaDon'] as int?,
      thangNam: map['thangNam'] as String?,
      soTien: (map['soTien'] as num?)?.toDouble(),
      hopDongID: map['HopDongID'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      'thangNam': thangNam,
      'soTien': soTien,
      'HopDongID': hopDongID,
    };
  }

  HoaDonPhong copyWith({
    int? maHoaDon,
    String? thangNam,
    double? soTien,
    int? hopDongID,
  }) {
    return HoaDonPhong(
      maHoaDon: maHoaDon ?? this.maHoaDon,
      thangNam: thangNam ?? this.thangNam,
      soTien: soTien ?? this.soTien,
      hopDongID: hopDongID ?? this.hopDongID,
    );
  }

  @override
  String toString() {
    return 'HoaDonPhong(maHoaDon: $maHoaDon, thangNam: $thangNam, '
        'soTien: $soTien, hopDongID: $hopDongID)';
  }
}

class PhieuThuHangThang {
  final int? maPhieuThu;
  final DateTime? ngayThu;
  final double? soTien;
  final String? ghiChu;
  final int? maHoaDon; // FK -> hoadonphong.maHoaDon

  PhieuThuHangThang({
    this.maPhieuThu,
    this.ngayThu,
    this.soTien,
    this.ghiChu,
    this.maHoaDon,
  });

  factory PhieuThuHangThang.fromMap(Map<String, dynamic> map) {
    return PhieuThuHangThang(
      maPhieuThu: map['maPhieuThu'] as int?,
      ngayThu: map['ngayThu'] != null
          ? DateTime.tryParse(map['ngayThu'] as String)
          : null,
      soTien: (map['soTien'] as num?)?.toDouble(),
      ghiChu: map['ghiChu'] as String?,
      maHoaDon: map['maHoaDon'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maPhieuThu != null) 'maPhieuThu': maPhieuThu,
      'ngayThu': ngayThu?.toIso8601String().split('T').first,
      'soTien': soTien,
      'ghiChu': ghiChu,
      'maHoaDon': maHoaDon,
    };
  }

  PhieuThuHangThang copyWith({
    int? maPhieuThu,
    DateTime? ngayThu,
    double? soTien,
    String? ghiChu,
    int? maHoaDon,
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
