class ThietBi {
  final int? thietBiID;
  final String? tenThietBi;
  final String? loai;
  final int? trangThai;

  const ThietBi({this.thietBiID, this.tenThietBi, this.loai, this.trangThai});

  factory ThietBi.fromMap(Map<String, dynamic> map) {
    return ThietBi(
      thietBiID: map['thietBiID'] as int?,
      tenThietBi: map['tenThietBi'] as String?,
      loai: map['loai'] as String?,
      trangThai: map['trangThai'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (thietBiID != null) 'thietBiID': thietBiID,
      'tenThietBi': tenThietBi,
      'loai': loai,
      'trangThai': trangThai,
    };
  }

  ThietBi copyWith({
    int? thietBiID,
    String? tenThietBi,
    String? loai,
    int? trangThai,
  }) {
    return ThietBi(
      thietBiID: thietBiID ?? this.thietBiID,
      tenThietBi: tenThietBi ?? this.tenThietBi,
      loai: loai ?? this.loai,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  /// 0: Tốt
  /// 1: Đang sửa
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

  bool get laTot => trangThai == 0;

  bool get dangSua => trangThai == 1;

  @override
  String toString() {
    return 'ThietBi('
        'thietBiID: $thietBiID, '
        'tenThietBi: $tenThietBi, '
        'loai: $loai, '
        'trangThai: $trangThai'
        ')';
  }
}
