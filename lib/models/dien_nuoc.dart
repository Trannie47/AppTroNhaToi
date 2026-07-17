class DienNuoc {
  final int? phongId;
  final String? thangNam;
  final int? lanGhi;

  final int? chiSoDienCu;
  final int? chiSoDienMoi;
  final int? chiSoNuocCu;
  final int? chiSoNuocMoi;

  final String? anhDienCu;
  final String? anhDienMoi;
  final String? anhNuocCu;
  final String? anhNuocMoi;

  final String? ngayGhi;
  final int? trangThai;  // 0: bản ghi này chưa chốt hóa đơn, 1: bản ghi này đã chốt hóa đơn

  DienNuoc({
    this.phongId,
    this.thangNam,
    this.lanGhi,
    this.chiSoDienCu,
    this.chiSoDienMoi,
    this.chiSoNuocCu,
    this.chiSoNuocMoi,
    this.anhDienCu,
    this.anhDienMoi,
    this.anhNuocCu,
    this.anhNuocMoi,
    this.ngayGhi,
    this.trangThai,
  });

  factory DienNuoc.fromMap(Map<String, dynamic> map) {
    return DienNuoc(
      phongId: map['phongId'] as int?,
      thangNam: map['thangNam'] as String?,
      lanGhi: map['lanGhi'] as int?,
      chiSoDienCu: map['chiSoDienCu'] as int?,
      chiSoDienMoi: map['chiSoDienMoi'] as int?,
      chiSoNuocCu: map['chiSoNuocCu'] as int?,
      chiSoNuocMoi: map['chiSoNuocMoi'] as int?,
      anhDienCu: map['anhDienCu'] as String?,
      anhDienMoi: map['anhDienMoi'] as String?,
      anhNuocCu: map['anhNuocCu'] as String?,
      anhNuocMoi: map['anhNuocMoi'] as String?,
      ngayGhi: map['ngayGhi'] as String?,
      trangThai: (map['TrangThai'] ?? map['trangThai']) as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phongId': phongId,
      'thangNam': thangNam,
      if (lanGhi != null) 'lanGhi': lanGhi,
      'chiSoDienCu': chiSoDienCu,
      'chiSoDienMoi': chiSoDienMoi,
      'chiSoNuocCu': chiSoNuocCu,
      'chiSoNuocMoi': chiSoNuocMoi,
      'anhDienCu': anhDienCu,
      'anhDienMoi': anhDienMoi,
      'anhNuocCu': anhNuocCu,
      'anhNuocMoi': anhNuocMoi,
      'ngayGhi': ngayGhi,
      'TrangThai': trangThai,
    };
  }

  DienNuoc copyWith({
    int? phongId,
    String? thangNam,
    int? lanGhi,
    int? chiSoDienCu,
    int? chiSoDienMoi,
    int? chiSoNuocCu,
    int? chiSoNuocMoi,
    String? anhDienCu,
    String? anhDienMoi,
    String? anhNuocCu,
    String? anhNuocMoi,
    String? ngayGhi,
    int? trangThai,
  }) {
    return DienNuoc(
      phongId: phongId ?? this.phongId,
      thangNam: thangNam ?? this.thangNam,
      lanGhi: lanGhi ?? this.lanGhi,
      chiSoDienCu: chiSoDienCu ?? this.chiSoDienCu,
      chiSoDienMoi: chiSoDienMoi ?? this.chiSoDienMoi,
      chiSoNuocCu: chiSoNuocCu ?? this.chiSoNuocCu,
      chiSoNuocMoi: chiSoNuocMoi ?? this.chiSoNuocMoi,
      anhDienCu: anhDienCu ?? this.anhDienCu,
      anhDienMoi: anhDienMoi ?? this.anhDienMoi,
      anhNuocCu: anhNuocCu ?? this.anhNuocCu,
      anhNuocMoi: anhNuocMoi ?? this.anhNuocMoi,
      ngayGhi: ngayGhi ?? this.ngayGhi,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  @override
  String toString() {
    return 'DienNuoc(phongId: $phongId, thangNam: $thangNam, lanGhi: $lanGhi, '
        'chiSoDienMoi: $chiSoDienMoi, chiSoNuocMoi: $chiSoNuocMoi, trangThai: $trangThai)';
  }
}