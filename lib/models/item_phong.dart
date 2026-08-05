import 'package:AppTroNhaToi/models/loai_phong.dart';

class ItemPhong {
  final int phongId;
  final String tenPhong;
  final int trangThai;
  final String moTa;
  final int maLoaiPhong;
  LoaiPhong loaiPhong;
  final List<hopDongTrongPhong> dsHopDong;
  final double giahientai;
  final int soNguoiHienTai;

  ItemPhong({
    required this.phongId,
    required this.tenPhong,
    required this.trangThai,
    required this.moTa,
    required this.maLoaiPhong,
    required this.loaiPhong,
    required this.dsHopDong,
    required this.giahientai,
    this.soNguoiHienTai = 0,
  });

  factory ItemPhong.fromMap(Map<String, dynamic> map) {
    return ItemPhong(
      phongId: map['phongId'] as int? ?? 0,
      tenPhong: map['tenPhong'] as String? ?? 'Chưa đặt tên',
      trangThai: map['trangThai'] as int? ?? 0,
      moTa: map['moTa'] as String? ?? '',
      maLoaiPhong: map['maLoaiPhong'] as int? ?? 0,

      loaiPhong: map['loaiPhong'] != null
          ? LoaiPhong.fromMap(map['loaiPhong'] as Map<String, dynamic>)
          : LoaiPhong(
              maLoaiPhong: 0,
              tenLoaiPhong: 'Chưa rõ',
              dienTich: 0,
              soNguoiToiDa: 0,
              giaTien: 0,
            ),

      dsHopDong: map['HopDong'] != null
          ? List<hopDongTrongPhong>.from(
              (map['HopDong'] as List).map(
                (x) => hopDongTrongPhong.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],

      giahientai: map['giahientai'] != null
          ? (double.tryParse(map['giahientai'].toString()) ?? 0.0)
          : 0.0,

      soNguoiHienTai: map['soNguoiHienTai'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'ItemPhong(phongId: $phongId, tenPhong: $tenPhong, trangThai: $trangThai, giaHienTai: $giahientai, loai: ${loaiPhong.tenLoaiPhong})';
  }
}

class hopDongTrongPhong {
  final String hopDongId;
  final int idnt;
  final int phongId;
  final DateTime? ngayKy;
  final DateTime? ngayHetHan;
  final double giaPhongThucTe;

  hopDongTrongPhong({
    required this.hopDongId,
    required this.idnt,
    required this.phongId,
    this.ngayKy,
    this.ngayHetHan,
    required this.giaPhongThucTe,
  });

  factory hopDongTrongPhong.fromMap(Map<String, dynamic> map) {
    return hopDongTrongPhong(
      hopDongId: map['hopDongId'] as String? ?? '',
      idnt: map['idnt'] as int? ?? 0,
      phongId: map['phongId'] as int? ?? 0,
      ngayKy: map['ngayKy'] != null
          ? DateTime.tryParse(map['ngayKy'].toString())
          : null,
      ngayHetHan: map['ngayHetHan'] != null
          ? DateTime.tryParse(map['ngayHetHan'].toString())
          : null,
      giaPhongThucTe: map['giaPhongThucTe'] != null
          ? (double.tryParse(map['giaPhongThucTe'].toString()) ?? 0.0)
          : 0.0,
    );
  }
}
