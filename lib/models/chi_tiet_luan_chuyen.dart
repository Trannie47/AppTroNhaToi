import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';

class ChiTietLuanChuyen {
  final int? chiTietLuanChuyenID;
  final int? suCoId;
  final String? hopDongId;
  final int? phongMoiId;
  final DateTime? ngayLuanChuyen;
  final int?
  trangThaiLuanChuyen; // 0 = Chưa chuyển, 1 = Đang chuyển, 2 = Đã hoàn tất
  final String? ghiChu;
  final Phong? phongMoi;
  final HopDong? hopDong;

  ChiTietLuanChuyen({
    this.chiTietLuanChuyenID,
    this.suCoId,
    this.hopDongId,
    this.phongMoiId,
    this.ngayLuanChuyen,
    this.trangThaiLuanChuyen,
    this.ghiChu,
    this.phongMoi,
    this.hopDong,
  });

  factory ChiTietLuanChuyen.fromMap(Map<String, dynamic> map) {
    return ChiTietLuanChuyen(
      chiTietLuanChuyenID: map['chiTietLuanChuyenID'] != null
          ? intOf(map['chiTietLuanChuyenID'])
          : null,
      suCoId: map['suCoId'] != null ? intOf(map['suCoId']) : null,
      hopDongId: strOf(map['hopDongId']),
      phongMoiId: map['phongMoiId'] != null ? intOf(map['phongMoiId']) : null,
      ngayLuanChuyen: dateOf(map['ngayLuanChuyen']),
      trangThaiLuanChuyen: map['trangThaiLuanChuyen'] != null
          ? intOf(map['trangThaiLuanChuyen'])
          : null,
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
      'suCoId': suCoId,
      'hopDongId': hopDongId,
      'phongMoiId': phongMoiId,
      if (ngayLuanChuyen != null)
        'ngayLuanChuyen': ngayLuanChuyen!.toIso8601String().split('T').first,
      'trangThaiLuanChuyen': trangThaiLuanChuyen,
      'ghiChu': ghiChu,
    };
  }

  ChiTietLuanChuyen copyWith({
    int? chiTietLuanChuyenID,
    int? suCoId,
    String? hopDongId,
    int? phongMoiId,
    DateTime? ngayLuanChuyen,
    int? trangThaiLuanChuyen,
    String? ghiChu,
    Phong? phongMoi,
    HopDong? hopDong,
  }) {
    return ChiTietLuanChuyen(
      chiTietLuanChuyenID: chiTietLuanChuyenID ?? this.chiTietLuanChuyenID,
      suCoId: suCoId ?? this.suCoId,
      hopDongId: hopDongId ?? this.hopDongId,
      phongMoiId: phongMoiId ?? this.phongMoiId,
      ngayLuanChuyen: ngayLuanChuyen ?? this.ngayLuanChuyen,
      trangThaiLuanChuyen: trangThaiLuanChuyen ?? this.trangThaiLuanChuyen,
      ghiChu: ghiChu ?? this.ghiChu,
      phongMoi: phongMoi ?? this.phongMoi,
      hopDong: hopDong ?? this.hopDong,
    );
  }

  @override
  String toString() {
    return 'ChiTietLuanChuyen('
        'chiTietLuanChuyenID: $chiTietLuanChuyenID, '
        'suCoId: $suCoId, '
        'hopDongId: $hopDongId, '
        'phongMoiId: $phongMoiId, '
        'ngayLuanChuyen: $ngayLuanChuyen, '
        'trangThaiLuanChuyen: $trangThaiLuanChuyen, '
        'ghiChu: $ghiChu, '
        'phongMoi: $phongMoi, '
        'hopDong: $hopDong'
        ')';
  }
}
