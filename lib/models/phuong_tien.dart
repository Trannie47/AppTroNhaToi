class PhuongTien {
  final String bienSo;
  final String? hangXe;
  final String? mauSac;
  final int? idnt;

  PhuongTien({
    required this.bienSo,
    this.hangXe,
    this.mauSac,
    this.idnt,
  });

  factory PhuongTien.fromMap(Map<String, dynamic> map) {
    return PhuongTien(
      bienSo: map['bienSo'] as String,
      hangXe: map['hangXe'] as String?,
      mauSac: map['mauSac'] as String?,
      idnt: map['IDNT'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bienSo': bienSo,
      'hangXe': hangXe,
      'mauSac': mauSac,
      'IDNT': idnt,
    };
  }

  PhuongTien copyWith({
    String? bienSo,
    String? hangXe,
    String? mauSac,
    int? idnt,
  }) {
    return PhuongTien(
      bienSo: bienSo ?? this.bienSo,
      hangXe: hangXe ?? this.hangXe,
      mauSac: mauSac ?? this.mauSac,
      idnt: idnt ?? this.idnt,
    );
  }

  @override
  String toString() {
    return 'PhuongTien(bienSo: $bienSo, hangXe: $hangXe, '
        'mauSac: $mauSac, idnt: $idnt)';
  }
}
