import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_o_ghep.dart';

class ItemHopDong {
  final HopDong hopDong;
  final String? tenDaiDien;
  final List<NguoiOGhep> dsNguoiOGhep;

  ItemHopDong({
    required this.hopDong,
    this.tenDaiDien,
    this.dsNguoiOGhep = const [],
  });

  /// Getter tiện dùng, forward từ HopDong để đỡ phải gọi item.hopDong.xxx
  String? get hopDongId => hopDong.hopDongID;
  int? get phongId => hopDong.phongID;
  int? get trangThai => hopDong.trangThai;

  factory ItemHopDong.fromMap(Map<String, dynamic> map) {
    return ItemHopDong(
      hopDong: HopDong.fromMap(map),
      tenDaiDien: map['nguoiDaiDien'] != null
          ? map['nguoiDaiDien']['hoTen'] as String?
          : null,
      dsNguoiOGhep: map['nguoiOGhep'] != null
          ? List<Map<String, dynamic>>.from(
              map['nguoiOGhep'],
            ).map((e) => NguoiOGhep.fromMap(e)).toList()
          : const [],
    );
  }

  Map<String, dynamic> toMap() => hopDong.toMap();
}
