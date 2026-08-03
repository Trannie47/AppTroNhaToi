import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/chi_tiet_luan_chuyen.dart';

class ThuCongNoDTO {
  final int? suCoId;
  final int? phongId;
  final String? tenSuCo;
  final String? ghiChu;
  final DateTime? ngayBatDau;
  final DateTime? ngayHoanThanh;
  final int? trangThaiThongBao;
  final double? chiPhi;

  final List<ChiTietLuanChuyen> chiTietLuanChuyen;

  ThuCongNoDTO({
    this.suCoId,
    this.phongId,
    this.tenSuCo,
    this.ghiChu,
    this.ngayBatDau,
    this.ngayHoanThanh,
    this.trangThaiThongBao,
    this.chiPhi,
    this.chiTietLuanChuyen = const [],
  });

  factory ThuCongNoDTO.fromMap(Map<String, dynamic> map) {
    return ThuCongNoDTO(
      suCoId: map['suCoId'] != null ? intOf(map['suCoId']) : null,
      phongId: map['phongId'] != null ? intOf(map['phongId']) : null,
      tenSuCo: strOf(map['tenSuCo']),
      ghiChu: strOf(map['ghiChu']),
      ngayBatDau: dateOf(map['ngayBatDau']),
      ngayHoanThanh: dateOf(map['ngayHoanThanh']),
      trangThaiThongBao: map['trangThaiThongBao'] != null
          ? intOf(map['trangThaiThongBao'])
          : null,
      chiPhi: map['chiPhi'] != null ? numOf(map['chiPhi']) : null,
      chiTietLuanChuyen:
          (map['chiTietLuanChuyen'] as List<dynamic>?)
              ?.map((e) => ChiTietLuanChuyen.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (suCoId != null) 'suCoId': suCoId,

      if (phongId != null) 'phongId': phongId,

      'tenSuCo': tenSuCo,

      'ghiChu': ghiChu,

      'ngayBatDau': ngayBatDau?.toUtc().toIso8601String(),

      'ngayHoanThanh': ngayHoanThanh?.toUtc().toIso8601String(),

      'trangThaiThongBao': trangThaiThongBao,

      'chiPhi': chiPhi,

      'chiTietLuanChuyen': chiTietLuanChuyen.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'ThuCongNoDTO('
        'suCoId: $suCoId, '
        'phongId: $phongId, '
        'tenSuCo: $tenSuCo, '
        'ghiChu: $ghiChu, '
        'ngayBatDau: $ngayBatDau, '
        'ngayHoanThanh: $ngayHoanThanh, '
        'trangThaiThongBao: $trangThaiThongBao, '
        'chiPhi: $chiPhi, '
        'chiTietLuanChuyen: $chiTietLuanChuyen'
        ')';
  }
}
