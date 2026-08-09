import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';

class SuaChuaDTO {
  final int? id;
  final int? lapRapId;
  final int? thietBiId;
  final String? nguyenNhan;
  final DateTime ngaySuaChua;
  final int? trangThaiThongBao;
  final HoaDonSuaChua? hoaDonSuaChua;

  SuaChuaDTO({
    this.id,
    this.lapRapId,
    this.thietBiId,
    this.nguyenNhan,
    required this.ngaySuaChua,
    this.trangThaiThongBao,
    this.hoaDonSuaChua,
  });

  factory SuaChuaDTO.fromMap(Map<String, dynamic> map) {
    return SuaChuaDTO(
      id: map['id'] as int?,
      lapRapId: map['lapRapId'] as int?,
      thietBiId: map['thietBiId'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua:
          DateTime.tryParse(map['ngaySuaChua']?.toString() ?? '') ??
          DateTime.now(),
      trangThaiThongBao: map['trangThaiThongBao'] as int?,
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
      if (lapRapId != null) 'lapRapId': lapRapId,
      if (thietBiId != null) 'thietBiId': thietBiId,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua.toUtc().toIso8601String(),
      if (trangThaiThongBao != null) 'trangThaiThongBao': trangThaiThongBao,

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
        'lapRapId: $lapRapId, '
        'thietBiId: $thietBiId, '
        'nguyenNhan: $nguyenNhan, '
        'ngaySuaChua: $ngaySuaChua, '
        'trangThaiThongBao: $trangThaiThongBao, '
        'hoaDonSuaChua: $hoaDonSuaChua'
        ')';
  }
}
