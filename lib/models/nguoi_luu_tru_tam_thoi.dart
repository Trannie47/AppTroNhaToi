class NguoiLuuTruTamThoi {
  final int? idtt;
  final String? hoTen;
  final String? moiQuanHe;
  final String? cccd;
  final String? sdt;
  final int? phongId;
  final int? idnt;
  final DateTime? ngayDen;
  final DateTime? ngayVe;

  NguoiLuuTruTamThoi({
    this.idtt,
    this.hoTen,
    this.moiQuanHe,
    this.cccd,
    this.sdt,
    this.phongId,
    this.idnt,
    this.ngayDen,
    this.ngayVe,
  });

  bool get isDangO {
    if (ngayVe == null) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ve = DateTime(ngayVe!.year, ngayVe!.month, ngayVe!.day);
    return ve.isAfter(today) || ve.isAtSameMomentAs(today);
  }

  // Text trạng thái hiển thị trên Card UI
  String get trangThaiText => isDangO ? "Đang ở" : "Đã về";

  factory NguoiLuuTruTamThoi.fromMap(Map<String, dynamic> map) {
    return NguoiLuuTruTamThoi(
      idtt: (map['idtt'] ?? map['IDTT']) as int?,
      hoTen: map['hoTen'] as String?,
      moiQuanHe: map['moiQuanHe'] as String?,
      cccd: (map['cccd'] ?? map['CCCD']) as String?,
      sdt: (map['sdt'] ?? map['SDT']) as String?,
      phongId: (map['phongId'] ?? map['PhongID']) as int?,
      idnt: (map['idnt'] ?? map['IDNT']) as int?,
      ngayDen: map['ngayDen'] != null
          ? DateTime.tryParse(map['ngayDen'] as String)
          : null,
      ngayVe: map['ngayVe'] != null
          ? DateTime.tryParse(map['ngayVe'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idtt != null) 'idtt': idtt,
      'hoTen': hoTen,
      'moiQuanHe': moiQuanHe,
      'cccd': cccd,
      'sdt': sdt,
      'phongId': phongId,
      'IDNT': idnt,
      'ngayDen': ngayDen?.toIso8601String().split('T').first,
      'ngayVe': ngayVe?.toIso8601String().split('T').first,
    };
  }

  NguoiLuuTruTamThoi copyWith({
    int? idtt,
    String? hoTen,
    String? moiQuanHe,
    String? cccd,
    String? sdt,
    int? phongId,
    int? idnt,
    DateTime? ngayDen,
    DateTime? ngayVe,
  }) {
    return NguoiLuuTruTamThoi(
      idtt: idtt ?? this.idtt,
      hoTen: hoTen ?? this.hoTen,
      moiQuanHe: moiQuanHe ?? this.moiQuanHe,
      cccd: cccd ?? this.cccd,
      sdt: sdt ?? this.sdt,
      phongId: phongId ?? this.phongId,
      idnt: idnt ?? this.idnt,
      ngayDen: ngayDen ?? this.ngayDen,
      ngayVe: ngayVe ?? this.ngayVe,
    );
  }

  @override
  String toString() {
    return 'NguoiLuuTruTamThoi(idtt: $idtt, hoTen: $hoTen, moiQuanHe: $moiQuanHe, '
        'cccd: $cccd, sdt: $sdt, phongId: $phongId, idnt: $idnt, ngayDen: $ngayDen, ngayVe: $ngayVe)';
  }
}
