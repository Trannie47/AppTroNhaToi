class LoaiPhong {
  final int maLoaiPhong;
  final String tenLoaiPhong;
  final double dienTich;
  final bool isMayLanh;
  final int soNguoiToiDa;
  final double giaTien;
  final List<PhongTrongLoaiPhong> phong;

  LoaiPhong({
    required this.maLoaiPhong,
    required this.tenLoaiPhong,
    required this.dienTich,
    this.isMayLanh = true,
    required this.soNguoiToiDa,
    required this.giaTien,
    this.phong = const [],
  });

  int get tongSoPhong => phong.length;
  int get soPhongTrong => phong.where((p) => p.trangThai == 0).length;
  int get soPhongDangThue => phong.where((p) => p.trangThai == 1).length;
  int get soPhongDangSua => phong.where((p) => p.trangThai == 2).length;

  factory LoaiPhong.fromMap(Map<String, dynamic> map) {
    return LoaiPhong(
      maLoaiPhong: map['maLoaiPhong'] as int,
      tenLoaiPhong: map['tenLoaiPhong'] as String,
      dienTich: map['dienTich'] != null
          ? (double.tryParse(map['dienTich'].toString()) ?? 0.0)
          : 0.0,
      isMayLanh: map['isMayLanh'] == 1 || map['isMayLanh'] == true,
      soNguoiToiDa: map['soNguoiToiDa'] as int,
      giaTien: map['giaTien'] != null
          ? (double.tryParse(map['giaTien'].toString()) ?? 0.0)
          : 0.0,
      phong: map['phong'] is List
          ? (map['phong'] as List)
              .map(
                (e) =>
                    PhongTrongLoaiPhong.fromMap(e as Map<String, dynamic>),
              )
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maLoaiPhong': maLoaiPhong,
      'tenLoaiPhong': tenLoaiPhong,
      'dienTich': dienTich,
      'isMayLanh': isMayLanh == true ? 1 : 0,
      'soNguoiToiDa': soNguoiToiDa,
      'giaTien': giaTien,
    };
  }

  LoaiPhong copyWith({
    int? maLoaiPhong,
    String? tenLoaiPhong,
    double? dienTich,
    bool? isMayLanh,
    int? soNguoiToiDa,
    double? giaTien,
    List<PhongTrongLoaiPhong>? phong,
  }) {
    return LoaiPhong(
      maLoaiPhong: maLoaiPhong ?? this.maLoaiPhong,
      dienTich: dienTich ?? this.dienTich,
      isMayLanh: isMayLanh ?? this.isMayLanh,
      soNguoiToiDa: soNguoiToiDa ?? this.soNguoiToiDa,
      giaTien: giaTien ?? this.giaTien,
      tenLoaiPhong: tenLoaiPhong ?? this.tenLoaiPhong,
      phong: phong ?? this.phong,
    );
  }

  @override
  String toString() {
    return 'LoaiPhong(maLoaiPhong: $maLoaiPhong, dienTich: $dienTich, '
        'isMayLanh: $isMayLanh, soNguoiToiDa: $soNguoiToiDa, giaTien: $giaTien, '
        'tongSoPhong: $tongSoPhong)';
  }
}

class PhongTrongLoaiPhong {
  final int phongId;
  final String tenPhong;
  final int trangThai; // 0: còn trống, 1: đang cho thuê, 2: đang sửa chữa

  PhongTrongLoaiPhong({
    required this.phongId,
    required this.tenPhong,
    required this.trangThai,
  });

  factory PhongTrongLoaiPhong.fromMap(Map<String, dynamic> map) {
    return PhongTrongLoaiPhong(
      phongId: map['phongId'] as int? ?? 0,
      tenPhong: map['tenPhong'] as String? ?? 'Chưa đặt tên',
      trangThai: map['trangThai'] as int? ?? 0,
    );
  }
}
