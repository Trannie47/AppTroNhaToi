import 'package:AppTroNhaToi/models/phong.dart';

class HopDong {
  final String? hopDongID;
  final int? idnt;
  final int? phongID;
  final DateTime? ngayKy;
  final DateTime? ngayHetHan;
  final double? tienCoc;
  final double? giaPhongThucTe;
  final String? ghiChu;
  final List<String>? dsAnhHopDong;
  final int? trangThai; //0: Khởi tạo , 1 Đã ký , 2: Hết hạn
  final bool? hinhThucO; // false: ở ghép, true: ở một mình
  final Phong?
  phong; // cái này dùng để lấy thông tin phòng hiển thị phòng trên chi tiết ngthue vì cần ngày ký

  HopDong({
    this.hopDongID,
    this.idnt,
    this.phongID,
    this.ngayKy,
    this.ngayHetHan,
    this.tienCoc,
    this.giaPhongThucTe,
    this.trangThai,
    this.dsAnhHopDong,
    this.ghiChu,
    this.hinhThucO,
    this.phong,
  });

  factory HopDong.fromMap(Map<String, dynamic> map) {
    return HopDong(
      hopDongID: map['hopDongId'] as String?,
      idnt: map['idntDaiDien'] as int? ?? map['idnt'] as int?,
      phongID: map['phongId'] as int?,

      ngayKy: map['ngayKy'] != null
          ? DateTime.tryParse(map['ngayKy'].toString())
          : null,
      ngayHetHan: map['ngayHetHan'] != null
          ? DateTime.tryParse(map['ngayHetHan'].toString())
          : null,
      tienCoc: map['tienCoc'] != null
          ? double.tryParse(map['tienCoc'].toString())
          : null,
      giaPhongThucTe: map['giaPhongThucTe'] != null
          ? double.tryParse(map['giaPhongThucTe'].toString())
          : null,
      trangThai: map['trangThai'] as int?,
      dsAnhHopDong: map['anhHopDong'] != null
          ? (map['anhHopDong'] is String
                ? (map['anhHopDong'] as String).split(',')
                : List<String>.from(map['anhHopDong']))
          : null,
      ghiChu: map['ghiChu'] as String?,
      hinhThucO: map['hinhThucO'] != null
          ? (map['hinhThucO'] is bool
                ? map['hinhThucO'] as bool
                : map['hinhThucO'].toString() == 'true' ||
                      map['hinhThucO'].toString() == '1')
          : null,
      phong: map['phong'] != null
          ? Phong.fromMap(map['phong'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (hopDongID != null) 'HopDongID': hopDongID,
      'IDNT': idnt,
      'PhongID': phongID,
      'ngayKy': ngayKy?.toIso8601String().split('T').first,
      'ngayHetHan': ngayHetHan?.toIso8601String().split('T').first,
      'tienCoc': tienCoc,
      'giaPhongThucTe': giaPhongThucTe,
      'trangThai': trangThai,
      'ghiChu': ghiChu,
      if (hinhThucO != null) 'hinhThucO': hinhThucO,
      if (dsAnhHopDong != null) 'dsAnhHopDong': dsAnhHopDong,
    };
  }

  HopDong copyWith({
    String? hopDongID,
    int? idnt,
    int? phongID,
    DateTime? ngayKy,
    DateTime? ngayHetHan,
    double? tienCoc,
    double? giaPhongThucTe,
    String? ghiChu,
    int? trangThai,
    bool? hinhThucO,
    List<String>? dsAnhHopDong,
  }) {
    return HopDong(
      hopDongID: hopDongID ?? this.hopDongID,
      idnt: idnt ?? this.idnt,
      phongID: phongID ?? this.phongID,
      ngayKy: ngayKy ?? this.ngayKy,
      ngayHetHan: ngayHetHan ?? this.ngayHetHan,
      tienCoc: tienCoc ?? this.tienCoc,
      giaPhongThucTe: giaPhongThucTe ?? this.giaPhongThucTe,
      ghiChu: ghiChu ?? this.ghiChu,
      trangThai: trangThai ?? this.trangThai,
      hinhThucO: hinhThucO ?? this.hinhThucO,
      dsAnhHopDong: dsAnhHopDong ?? this.dsAnhHopDong,
    );
  }

  @override
  String toString() {
    return 'HopDong(hopDongID: $hopDongID, idnt: $idnt, phongID: $phongID, '
        'ngayKy: $ngayKy, ngayHetHan: $ngayHetHan, tienCoc: $tienCoc, '
        'giaPhongThucTe: $giaPhongThucTe, trangThai: $trangThai, hinhThucO: $hinhThucO, '
        'ghiChu: $ghiChu, dsAnhHopDong: $dsAnhHopDong)';
  }
}
