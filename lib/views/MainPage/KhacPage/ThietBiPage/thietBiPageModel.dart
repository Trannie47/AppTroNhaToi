import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';

class ThietBiPageModel {
  final ThietBi thietBi;
  final int soLuongMua;
  final int soLuongLapDat;

  const ThietBiPageModel({
    required this.thietBi,
    required this.soLuongMua,
    required this.soLuongLapDat,
  });

  factory ThietBiPageModel.fromMap(Map<String, dynamic> map) {
    return ThietBiPageModel(
      thietBi: ThietBi.fromMap(map),
      soLuongMua: intOf(map['soLuongMua']),
      soLuongLapDat: intOf(map['soLuongLapDat']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...thietBi.toMap(),
      'soLuongMua': soLuongMua,
      'soLuongLapDat': soLuongLapDat,
    };
  }

  ThietBiPageModel copyWith({
    ThietBi? thietBi,
    int? soLuongMua,
    int? soLuongLapDat,
  }) {
    return ThietBiPageModel(
      thietBi: thietBi ?? this.thietBi,
      soLuongMua: soLuongMua ?? this.soLuongMua,
      soLuongLapDat: soLuongLapDat ?? this.soLuongLapDat,
    );
  }

  // Số lượng chưa lắp đặt
  //int get soLuongConLai => soLuongMua - soLuongLapDat;
  int get soLuongConLai => (soLuongMua - soLuongLapDat) < 0 ? 0 : (soLuongMua - soLuongLapDat);

  // Bổ sung thêm 2 hàm này để DropdownButtonFormField trong chỗ thêm thiết bị vào phòng để nó so sánh Object chuẩn xác
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThietBiPageModel &&
        other.thietBi.thietBiID == thietBi.thietBiID;
  }

  @override
  int get hashCode => thietBi.thietBiID.hashCode;

  @override
  String toString() {
    return 'ThietBiPageModel('
        'thietBi: $thietBi, '
        'soLuongMua: $soLuongMua, '
        'soLuongLapDat: $soLuongLapDat'
        ')';
  }
}
