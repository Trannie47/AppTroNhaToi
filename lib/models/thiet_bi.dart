class ThietBi {
  final int? thietBiID;
  final String? tenThietBi;
  final String? loai;
  final double? giaTri;
  final DateTime? ngayMua;
  final int? trangThai;

  ThietBi({
    this.thietBiID,
    this.tenThietBi,
    this.loai,
    this.giaTri,
    this.ngayMua,
    this.trangThai,
  });

  factory ThietBi.fromMap(Map<String, dynamic> map) {
    return ThietBi(
      thietBiID: map['thietBiID'] as int?,
      tenThietBi: map['tenThietBi'] as String?,
      loai: map['loai'] as String?,
      giaTri: (map['giaTri'] as num?)?.toDouble(),
      ngayMua: map['ngayMua'] != null
          ? DateTime.tryParse(map['ngayMua'] as String)
          : null,
      trangThai: map['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (thietBiID != null) 'thietBiID': thietBiID,
      'tenThietBi': tenThietBi,
      'loai': loai,
      'giaTri': giaTri,
      'ngayMua': ngayMua?.toIso8601String().split('T').first,
      'trangThai': trangThai,
    };
  }

  ThietBi copyWith({
    int? thietBiID,
    String? tenThietBi,
    String? loai,
    double? giaTri,
    DateTime? ngayMua,
    int? trangThai,
  }) {
    return ThietBi(
      thietBiID: thietBiID ?? this.thietBiID,
      tenThietBi: tenThietBi ?? this.tenThietBi,
      loai: loai ?? this.loai,
      giaTri: giaTri ?? this.giaTri,
      ngayMua: ngayMua ?? this.ngayMua,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  // 0: Tốt, 1: Đang sửa
  String get trangThaiText {
    switch (trangThai) {
      case 0:
        return "Tốt";
      case 1:
        return "Đang sửa";
      default:
        return "Không xác định";
    }
  }

  @override
  String toString() {
    return 'ThietBi(thietBiID: $thietBiID, tenThietBi: $tenThietBi, '
        'loai: $loai, giaTri: $giaTri, ngayMua: $ngayMua, trangThai: $trangThai)';
  }
}
