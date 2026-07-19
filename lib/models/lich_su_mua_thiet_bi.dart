class LichSuMuaThietBi {
  final int? id;
  final int? thietBiID;
  final int? soLuong;
  final double? donGia;
  final DateTime? ngayMua;
  final String? ghiChu;

  const LichSuMuaThietBi({
    this.id,
    this.thietBiID,
    this.soLuong,
    this.donGia,
    this.ngayMua,
    this.ghiChu,
  });

  factory LichSuMuaThietBi.fromMap(Map<String, dynamic> map) {
    return LichSuMuaThietBi(
      id: map['id'] as int?,
      thietBiID: map['thietBiId'] as int?,
      soLuong: map['soLuong'] as int?,
      donGia: map['donGia'] == null
          ? null
          : double.tryParse(map['donGia'].toString()),
      ngayMua: map['ngayMua'] != null
          ? DateTime.tryParse(map['ngayMua'].toString())
          : null,
      ghiChu: map['ghiChu'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'thietBiId': thietBiID,
      'soLuong': soLuong,
      'donGia': donGia,
      'ngayMua': ngayMua?.toUtc().toIso8601String(),
      'ghiChu': ghiChu,
    };
  }

  LichSuMuaThietBi copyWith({
    int? id,
    int? thietBiID,
    int? soLuong,
    double? donGia,
    DateTime? ngayMua,
    String? ghiChu,
  }) {
    return LichSuMuaThietBi(
      id: id ?? this.id,
      thietBiID: thietBiID ?? this.thietBiID,
      soLuong: soLuong ?? this.soLuong,
      donGia: donGia ?? this.donGia,
      ngayMua: ngayMua ?? this.ngayMua,
      ghiChu: ghiChu ?? this.ghiChu,
    );
  }

  /// Thành tiền của lần mua
  double get thanhTien => (soLuong ?? 0) * (donGia ?? 0);

  @override
  String toString() {
    return 'LichSuMuaThietBi('
        'id: $id, '
        'thietBiID: $thietBiID, '
        'soLuong: $soLuong, '
        'donGia: $donGia, '
        'ngayMua: $ngayMua, '
        'ghiChu: $ghiChu'
        ')';
  }
}
