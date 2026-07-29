import 'package:AppTroNhaToi/models/lap_rap.dart';

class LapRapPageModel {
  final LapRap lapRap;

  /// Số lượng đang sửa chữa (chưa có hóa đơn hoặc hóa đơn trangThai = 0)
  final int soLuongDangSua;

  /// Số lượng hỏng (hóa đơn sửa chữa có trangThai = 3)
  final int soLuongHong;

  LapRapPageModel({
    required this.lapRap,
    this.soLuongDangSua = 0,
    this.soLuongHong = 0,
  });

  factory LapRapPageModel.fromMap(Map<String, dynamic> map) {
    return LapRapPageModel(
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

  LapRapPageModel copyWith({
    LapRap? lapRap,
    int? soLuongDangSua,
    int? soLuongHong,
  }) {
    return LapRapPageModel(
      lapRap: lapRap ?? this.lapRap,
      soLuongDangSua: soLuongDangSua ?? this.soLuongDangSua,
      soLuongHong: soLuongHong ?? this.soLuongHong,
    );
  }

  @override
  String toString() {
    return 'ChiTietThietBiPhongPageModel('
        'lapRap: $lapRap, '
        'soLuongDangSua: $soLuongDangSua, '
        'soLuongHong: $soLuongHong'
        ')';
  }
}
