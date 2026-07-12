import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';

class LichSuSuaChuaPageModel {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;

  LichSuSuaChuaPageModel({required this.suaChua, this.hoaDonSuaChua});

  factory LichSuSuaChuaPageModel.fromMap(Map<String, dynamic> map) {
    return LichSuSuaChuaPageModel(
      suaChua: SuaChua.fromMap(map),

      hoaDonSuaChua: map['hoadonsuachua'] != null
          ? HoaDonSuaChua.fromMap(map['hoadonsuachua'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final data = suaChua.toMap();

    data['hoadonsuachua'] = hoaDonSuaChua?.toMap();

    return data;
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
        'hoaDonSuaChua: $hoaDonSuaChua'
        ')';
  }
}
