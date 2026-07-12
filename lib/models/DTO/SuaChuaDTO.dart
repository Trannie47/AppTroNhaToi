import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';

class SuaChuaDTO {
  final int? id;
  final int? phongId;
  final int? thietBiId;
  final String? nguyenNhan;
  final DateTime ngaySuaChua;
  final HoaDonSuaChua? hoaDonSuaChua;

  SuaChuaDTO({
    this.id,
    this.phongId,
    this.thietBiId,
    this.nguyenNhan,
    required this.ngaySuaChua,
    this.hoaDonSuaChua,
  });

  factory SuaChuaDTO.fromMap(Map<String, dynamic> map) {
    return SuaChuaDTO(
      id: map['id'] as int?,
      phongId: map['phongId'] as int?,
      thietBiId: map['thietBiId'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua:
          DateTime.tryParse(map['ngaySuaChua']?.toString() ?? '') ??
          DateTime.now(),
      hoaDonSuaChua: map['hoaDonSuaChua'] != null
          ? HoaDonSuaChua.fromMap(map['hoaDonSuaChua'])
          : map['hoadonsuachua'] != null
          ? HoaDonSuaChua.fromMap(map['hoadonsuachua'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (phongId != null) 'phongId': phongId,
      if (thietBiId != null) 'thietBiId': thietBiId,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua.toUtc().toIso8601String(),

      if (hoaDonSuaChua != null)
        'hoaDonSuaChua': {
          if (hoaDonSuaChua!.maHoaDonSC != null)
            'maHoaDonSc': hoaDonSuaChua!.maHoaDonSC,
          'trangThai': hoaDonSuaChua!.trangThai,
          'giaTien': hoaDonSuaChua!.giaTien,
          'loaiSua': hoaDonSuaChua!.loaiSua,
          'ngayLapHoaDonSc': hoaDonSuaChua!.ngayLapHoaDonSC
              ?.toUtc()
              .toIso8601String(),
        },
    };
  }

  @override
  String toString() {
    return 'SuaChuaDTO('
        'id: $id, '
        'phongId: $phongId, '
        'thietBiId: $thietBiId, '
        'nguyenNhan: $nguyenNhan, '
        'ngaySuaChua: $ngaySuaChua, '
        'hoaDonSuaChua: $hoaDonSuaChua'
        ')';
  }
}
