import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';

class PhieuLuanChuyen {
  final int? chiTietLuanChuyenID;
  final String? hopDongId;
  final int? phongMoiId;
  final DateTime? tuNgay;
  final DateTime? denNgay;
  final String? lyDoLuanChuyen;
  final double? chiPhi;
  final String? ghiChu;
  final Phong? phongMoi;
  final HopDong? hopDong;

  PhieuLuanChuyen({
    this.chiTietLuanChuyenID,
    this.hopDongId,
    this.phongMoiId,
    this.tuNgay,
    this.denNgay,
    this.lyDoLuanChuyen,
    this.chiPhi,
    this.ghiChu,
    this.phongMoi,
    this.hopDong,
  });

  factory PhieuLuanChuyen.fromMap(Map<String, dynamic> map) {
    return PhieuLuanChuyen(
      chiTietLuanChuyenID: map['chiTietLuanChuyenID'] != null
          ? intOf(map['chiTietLuanChuyenID'])
          : null,
      hopDongId: strOf(map['hopDongId']),
      phongMoiId: map['phongMoiId'] != null ? intOf(map['phongMoiId']) : null,
      tuNgay: dateOf(map['tuNgay']),
      denNgay: dateOf(map['denNgay']),
      lyDoLuanChuyen: strOf(map['lyDoLuanChuyen']),
      chiPhi: map['chiPhi'] != null ? numOf(map['chiPhi']) : null,
      ghiChu: strOf(map['ghiChu']),
      phongMoi: map['phongMoi'] != null
          ? Phong.fromMap(map['phongMoi'] as Map<String, dynamic>)
          : null,
      hopDong: map['hopDong'] != null
          ? HopDong.fromMap(map['hopDong'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Payload gửi lên API tạo/sửa — chỉ gồm field vô hướng (scalar),
  /// không gửi kèm các object quan hệ (phongMoi, hopDong).
  Map<String, dynamic> toMap() {
    return {
      if (chiTietLuanChuyenID != null)
        'chiTietLuanChuyenID': chiTietLuanChuyenID,
      'hopDongId': hopDongId,
      'phongMoiId': phongMoiId,
      if (tuNgay != null) 'tuNgay': tuNgay!.toIso8601String().split('T').first,
      if (denNgay != null)
        'denNgay': denNgay!.toIso8601String().split('T').first,
      'lyDoLuanChuyen': lyDoLuanChuyen,
      'chiPhi': chiPhi,
      'ghiChu': ghiChu,
    };
  }

  PhieuLuanChuyen copyWith({
    int? chiTietLuanChuyenID,
    String? hopDongId,
    int? phongMoiId,
    DateTime? tuNgay,
    DateTime? denNgay,
    String? lyDoLuanChuyen,
    double? chiPhi,
    String? ghiChu,
    Phong? phongMoi,
    HopDong? hopDong,
  }) {
    return PhieuLuanChuyen(
      chiTietLuanChuyenID: chiTietLuanChuyenID ?? this.chiTietLuanChuyenID,
      hopDongId: hopDongId ?? this.hopDongId,
      phongMoiId: phongMoiId ?? this.phongMoiId,
      tuNgay: tuNgay ?? this.tuNgay,
      denNgay: denNgay ?? this.denNgay,
      lyDoLuanChuyen: lyDoLuanChuyen ?? this.lyDoLuanChuyen,
      chiPhi: chiPhi ?? this.chiPhi,
      ghiChu: ghiChu ?? this.ghiChu,
      phongMoi: phongMoi ?? this.phongMoi,
      hopDong: hopDong ?? this.hopDong,
    );
  }

  @override
  String toString() {
    return 'ChiTietLuanChuyen('
        'chiTietLuanChuyenID: $chiTietLuanChuyenID, '
        'hopDongId: $hopDongId, '
        'phongMoiId: $phongMoiId, '
        'tuNgay: $tuNgay, '
        'denNgay: $denNgay, '
        'lyDoLuanChuyen: $lyDoLuanChuyen, '
        'chiPhi: $chiPhi, '
        'ghiChu: $ghiChu, '
        'phongMoi: $phongMoi, '
        'hopDong: $hopDong'
        ')';
  }
}
