class LichSuMuaThietBi {
  final int? id;
  final int? thietBiID;
  final int? soLuong;
  final double? donGia;
  final int? thangBaoHanh; // mặc định 0 ở DB
  final DateTime? ngayMua;
  final String? ghiChu;

  const LichSuMuaThietBi({
    this.id,
    this.thietBiID,
    this.soLuong,
    this.donGia,
    this.thangBaoHanh = 0,
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
      thangBaoHanh: map['thangBaoHanh'] as int? ?? 0,
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
      'thangBaoHanh': thangBaoHanh ?? 0,
      'ngayMua': ngayMua?.toUtc().toIso8601String(),
      'ghiChu': ghiChu,
    };
  }

  LichSuMuaThietBi copyWith({
    int? id,
    int? thietBiID,
    int? soLuong,
    double? donGia,
    int? thangBaoHanh,
    DateTime? ngayMua,
    String? ghiChu,
  }) {
    return LichSuMuaThietBi(
      id: id ?? this.id,
      thietBiID: thietBiID ?? this.thietBiID,
      soLuong: soLuong ?? this.soLuong,
      donGia: donGia ?? this.donGia,
      thangBaoHanh: thangBaoHanh ?? this.thangBaoHanh,
      ngayMua: ngayMua ?? this.ngayMua,
      ghiChu: ghiChu ?? this.ghiChu,
    );
  }

  /// Thành tiền của lần mua
  double get thanhTien => (soLuong ?? 0) * (donGia ?? 0);

  /// Ngày hết hạn bảo hành = ngày mua + số tháng bảo hành (nếu có đủ dữ liệu)
  DateTime? get ngayHetBaoHanh {
    if (ngayMua == null) return null;
    final soThang = thangBaoHanh ?? 0;
    if (soThang <= 0) return null;
    return DateTime(ngayMua!.year, ngayMua!.month + soThang, ngayMua!.day);
  }

  /// Còn trong thời hạn bảo hành tính đến thời điểm hiện tại hay không
  bool get conBaoHanh {
    final hetHan = ngayHetBaoHanh;
    if (hetHan == null) return false;
    return hetHan.isAfter(DateTime.now());
  }

  @override
  String toString() {
    return 'LichSuMuaThietBi('
        'id: $id, '
        'thietBiID: $thietBiID, '
        'soLuong: $soLuong, '
        'donGia: $donGia, '
        'thangBaoHanh: $thangBaoHanh, '
        'ngayMua: $ngayMua, '
        'ghiChu: $ghiChu'
        ')';
  }
}
