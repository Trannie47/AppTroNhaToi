class SuaChua {
  final int? id;
  final int? phongID;
  final String? nguyenNhan;
  final DateTime? ngaySuaChua;

  SuaChua({
    this.id,
    this.phongID,
    this.nguyenNhan,
    this.ngaySuaChua,
  });

  factory SuaChua.fromMap(Map<String, dynamic> map) {
    return SuaChua(
      id: map['id'] as int?,
      phongID: map['PhongID'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua: map['ngaySuaChua'] != null
          ? DateTime.tryParse(map['ngaySuaChua'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'PhongID': phongID,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua?.toIso8601String().split('T').first,
    };
  }

  SuaChua copyWith({
    int? id,
    int? phongID,
    String? nguyenNhan,
    DateTime? ngaySuaChua,
  }) {
    return SuaChua(
      id: id ?? this.id,
      phongID: phongID ?? this.phongID,
      nguyenNhan: nguyenNhan ?? this.nguyenNhan,
      ngaySuaChua: ngaySuaChua ?? this.ngaySuaChua,
    );
  }

  @override
  String toString() {
    return 'SuaChua(id: $id, phongID: $phongID, '
        'nguyenNhan: $nguyenNhan, ngaySuaChua: $ngaySuaChua)';
  }
}

class HoaDonSuaChua {
  final int? maHoaDonSC;
  final String? trangThai;
  final double? giaTien;
  final String? loaiSua;
  final DateTime? ngayLapHoaDonSC;
  final int? id; // FK -> suachua.id

  HoaDonSuaChua({
    this.maHoaDonSC,
    this.trangThai,
    this.giaTien,
    this.loaiSua,
    this.ngayLapHoaDonSC,
    this.id,
  });

  factory HoaDonSuaChua.fromMap(Map<String, dynamic> map) {
    return HoaDonSuaChua(
      maHoaDonSC: map['maHoaDonSC'] as int?,
      trangThai: map['TrangThai'] as String?,
      giaTien: (map['giaTien'] as num?)?.toDouble(),
      loaiSua: map['loaiSua'] as String?,
      ngayLapHoaDonSC: map['ngayLapHoaDonSC'] != null
          ? DateTime.tryParse(map['ngayLapHoaDonSC'] as String)
          : null,
      id: map['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDonSC != null) 'maHoaDonSC': maHoaDonSC,
      'TrangThai': trangThai,
      'giaTien': giaTien,
      'loaiSua': loaiSua,
      'ngayLapHoaDonSC': ngayLapHoaDonSC?.toIso8601String().split('T').first,
      'id': id,
    };
  }

  HoaDonSuaChua copyWith({
    int? maHoaDonSC,
    String? trangThai,
    double? giaTien,
    String? loaiSua,
    DateTime? ngayLapHoaDonSC,
    int? id,
  }) {
    return HoaDonSuaChua(
      maHoaDonSC: maHoaDonSC ?? this.maHoaDonSC,
      trangThai: trangThai ?? this.trangThai,
      giaTien: giaTien ?? this.giaTien,
      loaiSua: loaiSua ?? this.loaiSua,
      ngayLapHoaDonSC: ngayLapHoaDonSC ?? this.ngayLapHoaDonSC,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'HoaDonSuaChua(maHoaDonSC: $maHoaDonSC, trangThai: $trangThai, '
        'giaTien: $giaTien, loaiSua: $loaiSua, '
        'ngayLapHoaDonSC: $ngayLapHoaDonSC, id: $id)';
  }
}
