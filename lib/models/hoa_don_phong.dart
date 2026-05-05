class HoaDonPhong {
  final int? maHoaDon;
  final String? thangNam;
  final double? soTien;
  final int? hopDongID;

  HoaDonPhong({this.maHoaDon, this.thangNam, this.soTien, this.hopDongID});

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
