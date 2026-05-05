class NguoiLuuTruTamThoi {
  final int? idtt;
  final String? hoTen;
  final String? cccd;
  final DateTime? ngaySinh;
  final String? sdt;
  final String? queQuan;
  final int? phongID;

  NguoiLuuTruTamThoi({
    this.idtt,
    this.hoTen,
    this.cccd,
    this.ngaySinh,
    this.sdt,
    this.queQuan,
    this.phongID,
  });

  factory NguoiLuuTruTamThoi.fromMap(Map<String, dynamic> map) {
    return NguoiLuuTruTamThoi(
      idtt: map['IDTT'] as int?,
      hoTen: map['hoTen'] as String?,
      cccd: map['CCCD'] as String?,
      ngaySinh: map['ngaySinh'] != null
          ? DateTime.tryParse(map['ngaySinh'] as String)
          : null,
      sdt: map['SDT'] as String?,
      queQuan: map['queQuan'] as String?,
      phongID: map['PhongID'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idtt != null) 'IDTT': idtt,
      'hoTen': hoTen,
      'CCCD': cccd,
      'ngaySinh': ngaySinh?.toIso8601String().split('T').first,
      'SDT': sdt,
      'queQuan': queQuan,
      'PhongID': phongID,
    };
  }

  NguoiLuuTruTamThoi copyWith({
    int? idtt,
    String? hoTen,
    String? cccd,
    DateTime? ngaySinh,
    String? sdt,
    String? queQuan,
    int? phongID,
  }) {
    return NguoiLuuTruTamThoi(
      idtt: idtt ?? this.idtt,
      hoTen: hoTen ?? this.hoTen,
      cccd: cccd ?? this.cccd,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      sdt: sdt ?? this.sdt,
      queQuan: queQuan ?? this.queQuan,
      phongID: phongID ?? this.phongID,
    );
  }

  @override
  String toString() {
    return 'NguoiLuuTruTamThoi(idtt: $idtt, hoTen: $hoTen, cccd: $cccd, '
        'ngaySinh: $ngaySinh, sdt: $sdt, queQuan: $queQuan, phongID: $phongID)';
  }
}
