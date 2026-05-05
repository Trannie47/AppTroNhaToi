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
