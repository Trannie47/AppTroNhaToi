class PhuongTien {
  final num ID;
  final String? bienSo;
  final String? hangXe;
  final String? mauSac;
  final double? giaGui;
  final int loaiXe; // Xe máy = 0, Ô tô = 1, Xe đạp = 2
  final int? idnt;
  final int? phongId;
  final String? tenPhong;

  PhuongTien({
    required this.ID,
    this.bienSo,
    this.hangXe,
    this.mauSac,
    this.giaGui,
    this.loaiXe = 0,
    this.idnt,
    this.phongId,
    this.tenPhong,
  });

  factory PhuongTien.fromMap(Map<String, dynamic> map) {
    final double? parsedMoney = (map['SoTien'] as num?)?.toDouble() ??
        (map['soTien'] as num?)?.toDouble() ??
        (map['giaGui'] as num?)?.toDouble();

    return PhuongTien(
      ID: map['ID'] as num? ?? 0,
      bienSo: map['bienSo'] as String?,
      hangXe: map['hangXe'] as String?,
      mauSac: map['mauSac'] as String?,
      giaGui: parsedMoney,
      loaiXe: map['loaixe'] as int? ?? map['loaiXe'] as int? ?? 0,
      idnt: map['idnt'] as int? ?? map['IDNT'] as int?,
      phongId: map['phongId'] as int? ?? map['PhongID'] as int?,
      tenPhong: map['phong'] != null ? map['phong']['tenPhong'] as String? : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'bienSo': bienSo,
      'hangXe': hangXe,
      'mauSac': mauSac,
      'SoTien': giaGui,
      'loaiXe': loaiXe,
      'loaixe': loaiXe,
      'IDNT': idnt,
      'idnt': idnt,
      'phongId': phongId,
      'PhongID': phongId,
    };
  }

  PhuongTien copyWith({
    num? ID,
    String? bienSo,
    String? hangXe,
    String? mauSac,
    double? giaGui,
    int? loaiXe,
    int? idnt,
    int? phongId,
    String? tenPhong,
  }) {
    return PhuongTien(
      ID: ID ?? this.ID,
      bienSo: bienSo ?? this.bienSo,
      hangXe: hangXe ?? this.hangXe,
      mauSac: mauSac ?? this.mauSac,
      giaGui: giaGui ?? this.giaGui,
      loaiXe: loaiXe ?? this.loaiXe,
      idnt: idnt ?? this.idnt,
      phongId: phongId ?? this.phongId,
      tenPhong: tenPhong ?? this.tenPhong,
    );
  }

  @override
  String toString() {
    return 'PhuongTien(ID: $ID, bienSo: $bienSo, hangXe: $hangXe, '
        'mauSac: $mauSac, soTien: $giaGui, idnt: $idnt, phongId: $phongId, tenPhong: $tenPhong)';
  }
}