class HangHoa {
  final int? maHangHoa;
  final String? tenHangHoa;
  final double? giaNhap;
  final double? giaBan;

  HangHoa({
    this.maHangHoa,
    this.tenHangHoa,
    this.giaNhap,
    this.giaBan,
  });

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

class HoaDonTapHoa {
  final int? maHoaDon;
  final int? idnt; // FK -> nguoithue.IDNT
  final DateTime? ngayBan;
  final double? tongTien;

  HoaDonTapHoa({
    this.maHoaDon,
    this.idnt,
    this.ngayBan,
    this.tongTien,
  });

  factory HoaDonTapHoa.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoa(
      maHoaDon: map['maHoaDon'] as int?,
      idnt: map['IDNT'] as int?,
      ngayBan: map['ngayBan'] != null
          ? DateTime.tryParse(map['ngayBan'] as String)
          : null,
      tongTien: (map['tongTien'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      'IDNT': idnt,
      'ngayBan': ngayBan?.toIso8601String().split('T').first,
      'tongTien': tongTien,
    };
  }

  HoaDonTapHoa copyWith({
    int? maHoaDon,
    int? idnt,
    DateTime? ngayBan,
    double? tongTien,
  }) {
    return HoaDonTapHoa(
      maHoaDon: maHoaDon ?? this.maHoaDon,
      idnt: idnt ?? this.idnt,
      ngayBan: ngayBan ?? this.ngayBan,
      tongTien: tongTien ?? this.tongTien,
    );
  }

  @override
  String toString() {
    return 'HoaDonTapHoa(maHoaDon: $maHoaDon, idnt: $idnt, '
        'ngayBan: $ngayBan, tongTien: $tongTien)';
  }
}

class ChiTietTapHoa {
  final int? maChiTietHoaDon;
  final int? maHoaDon; // FK -> hoadontaphoa.maHoaDon
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
      maHoaDon: map['maHoaDon'] as int?,
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
    int? maHoaDon,
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
