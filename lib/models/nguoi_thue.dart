class NguoiThue {
  final int? idnt;
  final String? cccd;
  final String? hoTen;
  final DateTime? ngaySinh;
  final String? sdt;
  final String? queQuan;
  final String? ghiChu;
  final bool? gioiTinh;

  NguoiThue({
    this.idnt,
    this.cccd,
    this.hoTen,
    this.ngaySinh,
    this.sdt,
    this.queQuan,
    this.ghiChu,
    this.gioiTinh,
  });

  factory NguoiThue.fromMap(Map<String, dynamic> map) {
    return NguoiThue(
      idnt: map['idnt'] as int?,
      cccd: map['cccd'] as String?,
      hoTen: map['hoTen'] as String?,
      ngaySinh: map['ngaySinh'] != null
          ? DateTime.tryParse(map['ngaySinh'] as String)
          : null,
      sdt: map['sdt'] as String?,
      queQuan: map['queQuan'] as String?,
      ghiChu: map['ghiChu'] as String?,
      gioiTinh: map['gioiTinh'] != null
          ? map['gioiTinh'] == 1 || map['gioiTinh'] == true
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idnt != null) 'idnt': idnt,
      'cccd': cccd,
      'hoTen': hoTen,
      'ngaySinh': ngaySinh?.toIso8601String().split('T').first,
      'sdt': sdt,
      'queQuan': queQuan,
      'ghiChu': ghiChu,
      'gioiTinh': gioiTinh == true ? 1 : 0,
    };
  }

  NguoiThue copyWith({
    int? idnt,
    String? cccd,
    String? hoTen,
    DateTime? ngaySinh,
    String? sdt,
    String? queQuan,
    String? ghiChu,
    bool? gioiTinh,
  }) {
    return NguoiThue(
      idnt: idnt ?? this.idnt,
      cccd: cccd ?? this.cccd,
      hoTen: hoTen ?? this.hoTen,
      ngaySinh: ngaySinh ?? this.ngaySinh,
      sdt: sdt ?? this.sdt,
      queQuan: queQuan ?? this.queQuan,
      ghiChu: ghiChu ?? this.ghiChu,
      gioiTinh: gioiTinh ?? this.gioiTinh,
    );
  }

  @override
  String toString() {
    return 'NguoiThue(idnt: $idnt, cccd: $cccd, hoTen: $hoTen, ngaySinh: $ngaySinh, sdt: $sdt, queQuan: $queQuan, ghiChu: $ghiChu, gioiTinh: $gioiTinh)';
  }
}