import 'package:AppTroNhaToi/models/lap_rap.dart';

class ThietBiPhongPageModel {
  final LapRap lapRap;

  /// Số lượng đang sửa chữa (chưa có hóa đơn hoặc hóa đơn trangThai = 0)
  final int soLuongDangSua;

  /// Số lượng hỏng (hóa đơn sửa chữa có trangThai = 3)
  final int soLuongHong;

  ThietBiPhongPageModel({
    required this.lapRap,
    this.soLuongDangSua = 0,
    this.soLuongHong = 0,
  });

  factory ThietBiPhongPageModel.fromMap(Map<String, dynamic> map) {
    return ThietBiPhongPageModel(
      lapRap: LapRap.fromMap(map),
      soLuongDangSua: (map['soLuongDangSua'] as num?)?.toInt() ?? 0,
      soLuongHong: (map['soLuongHong'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...lapRap.toMap(),
      'soLuongDangSua': soLuongDangSua,
      'soLuongHong': soLuongHong,
    };
  }

  ThietBiPhongPageModel copyWith({
    LapRap? lapRap,
    int? soLuongDangSua,
    int? soLuongHong,
  }) {
    return ThietBiPhongPageModel(
      lapRap: lapRap ?? this.lapRap,
      soLuongDangSua: soLuongDangSua ?? this.soLuongDangSua,
      soLuongHong: soLuongHong ?? this.soLuongHong,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThietBiPhongPageModel &&
          lapRap.thietBiID == other.lapRap.thietBiID;

  @override
  int get hashCode => lapRap.thietBiID.hashCode;

  @override
  String toString() {
    return 'ChiTietThietBiPhongPageModel('
        'lapRap: $lapRap, '
        'soLuongDangSua: $soLuongDangSua, '
        'soLuongHong: $soLuongHong'
        ')';
  }
}
