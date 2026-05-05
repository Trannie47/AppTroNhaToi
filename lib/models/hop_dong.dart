class HopDong {
  final int? hopDongID;
  final int? idnt;
  final int? phongID;
  final DateTime? ngayKy;
  final DateTime? ngayHetHan;
  final double? tienCoc;
  final double? giaPhongThucTe;
  final String? trangThai;

  HopDong({
    this.hopDongID,
    this.idnt,
    this.phongID,
    this.ngayKy,
    this.ngayHetHan,
    this.tienCoc,
    this.giaPhongThucTe,
    this.trangThai,
  });

  factory HopDong.fromMap(Map<String, dynamic> map) {
    return HopDong(
      hopDongID: map['HopDongID'] as int?,
      idnt: map['IDNT'] as int?,
      phongID: map['PhongID'] as int?,
      ngayKy: map['ngayKy'] != null
          ? DateTime.tryParse(map['ngayKy'] as String)
          : null,
      ngayHetHan: map['ngayHetHan'] != null
          ? DateTime.tryParse(map['ngayHetHan'] as String)
          : null,
      tienCoc: (map['tienCoc'] as num?)?.toDouble(),
      giaPhongThucTe: (map['giaPhongThucTe'] as num?)?.toDouble(),
      trangThai: map['trangThai'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (hopDongID != null) 'HopDongID': hopDongID,
      'IDNT': idnt,
      'PhongID': phongID,
      'ngayKy': ngayKy?.toIso8601String().split('T').first,
      'ngayHetHan': ngayHetHan?.toIso8601String().split('T').first,
      'tienCoc': tienCoc,
      'giaPhongThucTe': giaPhongThucTe,
      'trangThai': trangThai,
    };
  }

  HopDong copyWith({
    int? hopDongID,
    int? idnt,
    int? phongID,
    DateTime? ngayKy,
    DateTime? ngayHetHan,
    double? tienCoc,
    double? giaPhongThucTe,
    String? trangThai,
  }) {
    return HopDong(
      hopDongID: hopDongID ?? this.hopDongID,
      idnt: idnt ?? this.idnt,
      phongID: phongID ?? this.phongID,
      ngayKy: ngayKy ?? this.ngayKy,
      ngayHetHan: ngayHetHan ?? this.ngayHetHan,
      tienCoc: tienCoc ?? this.tienCoc,
      giaPhongThucTe: giaPhongThucTe ?? this.giaPhongThucTe,
      trangThai: trangThai ?? this.trangThai,
    );
  }

  @override
  String toString() {
    return 'HopDong(hopDongID: $hopDongID, idnt: $idnt, phongID: $phongID, '
        'ngayKy: $ngayKy, ngayHetHan: $ngayHetHan, tienCoc: $tienCoc, '
        'giaPhongThucTe: $giaPhongThucTe, trangThai: $trangThai)';
  }
}
