class Phong {
  final int? phongID;
  final String? tenPhong;
  final String? trangThai;
  final String? moTa;
  final int? maLoaiPhong;

  Phong({
    this.phongID,
    this.tenPhong,
    this.trangThai,
    this.moTa,
    this.maLoaiPhong,
  });

  factory Phong.fromMap(Map<String, dynamic> map) {
    return Phong(
      phongID: map['PhongID'] as int?,
      tenPhong: map['tenPhong'] as String?,
      trangThai: map['trangThai'] as String?,
      moTa: map['moTa'] as String?,
      maLoaiPhong: map['maLoaiPhong'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (phongID != null) 'PhongID': phongID,
      'tenPhong': tenPhong,
      'trangThai': trangThai,
      'moTa': moTa,
      'maLoaiPhong': maLoaiPhong,
    };
  }

  Phong copyWith({
    int? phongID,
    String? tenPhong,
    String? trangThai,
    String? moTa,
    int? maLoaiPhong,
  }) {
    return Phong(
      phongID: phongID ?? this.phongID,
      tenPhong: tenPhong ?? this.tenPhong,
      trangThai: trangThai ?? this.trangThai,
      moTa: moTa ?? this.moTa,
      maLoaiPhong: maLoaiPhong ?? this.maLoaiPhong,
    );
  }

  @override
  String toString() {
    return 'Phong(phongID: $phongID, tenPhong: $tenPhong, '
        'trangThai: $trangThai, moTa: $moTa, maLoaiPhong: $maLoaiPhong)';
  }
}
