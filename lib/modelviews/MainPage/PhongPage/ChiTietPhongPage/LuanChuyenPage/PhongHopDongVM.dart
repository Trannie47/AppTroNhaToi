class PhongHopDongVM {
  final int? phongId;
  final String? tenPhong;
  final int? sucChua;
  final int? soNguoiDangO;
  final int? soChoTrong;
  final bool? daCoHopDong;
  final int? suCoId;

  PhongHopDongVM({
    this.phongId,
    this.tenPhong,
    this.sucChua,
    this.soNguoiDangO,
    this.soChoTrong,
    this.daCoHopDong,
    this.suCoId,
  });

  factory PhongHopDongVM.fromMap(Map<String, dynamic> map) {
    return PhongHopDongVM(
      phongId: (map['phongId'] ?? map['PhongID']) as int?,
      tenPhong: map['tenPhong'] as String?,
      sucChua: map['sucChua'] as int?,
      soNguoiDangO: map['soNguoiDangO'] as int?,
      soChoTrong: map['soChoTrong'] as int?,
      daCoHopDong: map['daCoHopDong'] as bool?,
      suCoId: (map['suCoId'] ?? map['SuCoID']) as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (phongId != null) 'phongId': phongId,
      'tenPhong': tenPhong,
      'sucChua': sucChua,
      'soNguoiDangO': soNguoiDangO,
      'soChoTrong': soChoTrong,
      'daCoHopDong': daCoHopDong,
      'suCoId': suCoId,
    };
  }

  PhongHopDongVM copyWith({
    int? phongId,
    String? tenPhong,
    int? sucChua,
    int? soNguoiDangO,
    int? soChoTrong,
    bool? daCoHopDong,
    int? suCoId,
  }) {
    return PhongHopDongVM(
      phongId: phongId ?? this.phongId,
      tenPhong: tenPhong ?? this.tenPhong,
      sucChua: sucChua ?? this.sucChua,
      soNguoiDangO: soNguoiDangO ?? this.soNguoiDangO,
      soChoTrong: soChoTrong ?? this.soChoTrong,
      daCoHopDong: daCoHopDong ?? this.daCoHopDong,
      suCoId: suCoId ?? this.suCoId,
    );
  }

  @override
  String toString() {
    return 'PhongHopDongVM(phongId: $phongId, tenPhong: $tenPhong, '
        'sucChua: $sucChua, soNguoiDangO: $soNguoiDangO, '
        'soChoTrong: $soChoTrong, daCoHopDong: $daCoHopDong, '
        'suCoId: $suCoId)';
  }
}
