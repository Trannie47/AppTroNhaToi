class PhuongTien {
  final num ID;
  final String? bienSo;
  final String? hangXe;
  final String? mauSac;
  final double? giaGui;
  // Xe máy = 0, Ô tô = 1, Xe đạp = 2
  final int loaiXe;
  final int? idnt;

  PhuongTien({
    required this.ID,
    this.bienSo,
    this.hangXe,
    this.mauSac,
    this.giaGui,
    this.loaiXe = 0,
    this.idnt,
  });

  factory PhuongTien.fromMap(Map<String, dynamic> map) {
    return PhuongTien(
      ID: map['ID'] as num,
      bienSo: map['bienSo'] as String?,
      hangXe: map['hangXe'] as String?,
      mauSac: map['mauSac'] as String?,
      giaGui: map['giaGui'] as double?,
      loaiXe: map['loaiXe'] as int? ?? 0,
      idnt: map['IDNT'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'bienSo': bienSo,
      'hangXe': hangXe,
      'mauSac': mauSac,
      'giaGui': giaGui,
      'loaiXe': loaiXe,
      'IDNT': idnt,
    };
  }

  PhuongTien copyWith({
    String? bienSo,
    String? hangXe,
    String? mauSac,
    double? giaGui,
    int? loaiXe,
    int? idnt,
  }) {
    return PhuongTien(
      ID: ID,
      bienSo: bienSo ?? this.bienSo,
      hangXe: hangXe ?? this.hangXe,
      mauSac: mauSac ?? this.mauSac,
      giaGui: giaGui ?? this.giaGui,
      loaiXe: loaiXe ?? this.loaiXe,
      idnt: idnt ?? this.idnt,
    );
  }

  @override
  String toString() {
    return 'PhuongTien(bienSo: $bienSo, hangXe: $hangXe, '
        'mauSac: $mauSac, idnt: $idnt)';
  }
}
