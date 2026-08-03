import 'package:AppTroNhaToi/models/loai_phong.dart';

class Phong {
  final int phongID;
  final String tenPhong;
  final int trangThai;
  final String? moTa;
  final int maLoaiPhong;
  final LoaiPhong?
  loaiPhong; //cái này dùng để lấy kèm thông tin tên loại phòng để hiển thị lên item phòng trên chi tiết người thuê

  Phong({
    required this.phongID,
    required this.tenPhong,
    required this.trangThai,
    this.moTa,
    required this.maLoaiPhong,
    this.loaiPhong,
  });

  factory Phong.fromMap(Map<String, dynamic> map) {
    return Phong(
      phongID: map['phongId'] as int? ?? 0,
      tenPhong: map['tenPhong'] as String? ?? "Phòng chưa đặt tên",
      trangThai: map['trangThai'] as int? ?? 0,
      moTa: map['moTa'] as String?,
      maLoaiPhong: map['maLoaiPhong'] as int? ?? 0,
      loaiPhong: map['loaiPhong'] != null
          ? LoaiPhong.fromMap(map['loaiPhong'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PhongID': phongID,
      'tenPhong': tenPhong,
      'trangThai': trangThai,
      'moTa': moTa,
      'maLoaiPhong': maLoaiPhong,
    };
  }

  Phong copyWith({
    int? phongID,
    String? tenPhong,
    int? trangThai,
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

  //Hiển thị trạng thái thông qua số
  String get trangThaiText {
    switch (trangThai) {
      case 0:
        return 'Trống';
      case 1:
        return 'Đã thuê';
      case 2:
        return 'Đang sửa chữa';
      default:
        return 'Không xác định';
    }
  }

  @override
  String toString() {
    return 'Phong(phongID: $phongID, tenPhong: $tenPhong, '
        'trangThai: $trangThai, moTa: $moTa, maLoaiPhong: $maLoaiPhong)';
  }
}
