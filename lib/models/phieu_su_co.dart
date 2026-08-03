import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/chi_tiet_luan_chuyen.dart';

class PhieuSuCo {
  final int? suCoId;
  final int? phongId;
  final String? tenSuCo;
  final String? ghiChu;
  final DateTime? ngayBatDau;
  final DateTime? ngayHoanThanh;
  final int? trangThaiThongBao;
  final double? chiPhi;
  final Phong? phong;
  final List<ChiTietLuanChuyen>? chiTietLuanChuyen;

  PhieuSuCo({
    this.suCoId,
    this.phongId,
    this.tenSuCo,
    this.ghiChu,
    this.ngayBatDau,
    this.ngayHoanThanh,
    this.trangThaiThongBao,
    this.chiPhi,
    this.phong,
    this.chiTietLuanChuyen,
  });

  factory PhieuSuCo.fromMap(Map<String, dynamic> map) {
    return PhieuSuCo(
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
      phong: map['phong'] != null
          ? Phong.fromMap(map['phong'] as Map<String, dynamic>)
          : null,
      chiTietLuanChuyen: map['chiTietLuanChuyen'] != null
          ? (map['chiTietLuanChuyen'] as List)
                .map(
                  (e) => ChiTietLuanChuyen.fromMap(e as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (suCoId != null) 'suCoId': suCoId,
      'phongId': phongId,
      'tenSuCo': tenSuCo,
      'ghiChu': ghiChu,
      if (ngayBatDau != null)
        'ngayBatDau': ngayBatDau!.toIso8601String().split('T').first,
      if (ngayHoanThanh != null)
        'ngayHoanThanh': ngayHoanThanh!.toIso8601String().split('T').first,
      'trangThaiThongBao': trangThaiThongBao,
      'chiPhi': chiPhi,
    };
  }

  PhieuSuCo copyWith({
    int? suCoId,
    int? phongId,
    String? tenSuCo,
    String? ghiChu,
    DateTime? ngayBatDau,
    DateTime? ngayHoanThanh,
    int? trangThaiThongBao,
    double? chiPhi,
    Phong? phong,
    List<ChiTietLuanChuyen>? chiTietLuanChuyen,
  }) {
    return PhieuSuCo(
      suCoId: suCoId ?? this.suCoId,
      phongId: phongId ?? this.phongId,
      tenSuCo: tenSuCo ?? this.tenSuCo,
      ghiChu: ghiChu ?? this.ghiChu,
      ngayBatDau: ngayBatDau ?? this.ngayBatDau,
      ngayHoanThanh: ngayHoanThanh ?? this.ngayHoanThanh,
      trangThaiThongBao: trangThaiThongBao ?? this.trangThaiThongBao,
      chiPhi: chiPhi ?? this.chiPhi,
      phong: phong ?? this.phong,
      chiTietLuanChuyen: chiTietLuanChuyen ?? this.chiTietLuanChuyen,
    );
  }

  @override
  String toString() {
    return 'PhieuSuCo('
        'suCoId: $suCoId, '
        'phongId: $phongId, '
        'tenSuCo: $tenSuCo, '
        'ghiChu: $ghiChu, '
        'ngayBatDau: $ngayBatDau, '
        'ngayHoanThanh: $ngayHoanThanh, '
        'trangThaiThongBao: $trangThaiThongBao, '
        'chiPhi: $chiPhi, '
        'phong: $phong, '
        'chiTietLuanChuyen: $chiTietLuanChuyen'
        ')';
  }
}
