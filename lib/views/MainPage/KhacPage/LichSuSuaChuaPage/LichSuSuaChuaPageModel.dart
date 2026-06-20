import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';

class LichSuSuaChuaPageModel {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;

  LichSuSuaChuaPageModel({required this.suaChua, this.hoaDonSuaChua});

  factory LichSuSuaChuaPageModel.fromMap(Map<String, dynamic> map) {
    return LichSuSuaChuaPageModel(
      suaChua: SuaChua.fromMap(map['suaChua'] as Map<String, dynamic>),
      hoaDonSuaChua: map['hoaDonSuaChua'] != null
          ? HoaDonSuaChua.fromMap(map['hoaDonSuaChua'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'suaChua': suaChua.toMap(),
      'hoaDonSuaChua': hoaDonSuaChua?.toMap(),
    };
  }

  LichSuSuaChuaPageModel copyWith({
    SuaChua? suaChua,
    HoaDonSuaChua? hoaDonSuaChua,
  }) {
    return LichSuSuaChuaPageModel(
      suaChua: suaChua ?? this.suaChua,
      hoaDonSuaChua: hoaDonSuaChua ?? this.hoaDonSuaChua,
    );
  }

  @override
  String toString() {
    return 'LichSuSuaChuaPageModel('
        'suaChua: $suaChua, '
        'hoaDonSuaChua: $hoaDonSuaChua)';
  }
}
