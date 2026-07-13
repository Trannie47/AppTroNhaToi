import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';

class LichSuSuaChuaPageModel {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;
  final String? tenPhong;

  LichSuSuaChuaPageModel({
    required this.suaChua,
    this.hoaDonSuaChua,
    this.tenPhong,
  });

  factory LichSuSuaChuaPageModel.fromMap(Map<String, dynamic> map) {
    return LichSuSuaChuaPageModel(
      suaChua: SuaChua.fromMap(map),
      hoaDonSuaChua: map['hoadonsuachua'] != null
          ? HoaDonSuaChua.fromMap(map['hoadonsuachua'] as Map<String, dynamic>)
          : null,
      tenPhong: map['tenPhong']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final data = suaChua.toMap();

    data['hoadonsuachua'] = hoaDonSuaChua?.toMap();
    data['tenPhong'] = tenPhong;

    return data;
  }

  LichSuSuaChuaPageModel copyWith({
    SuaChua? suaChua,
    HoaDonSuaChua? hoaDonSuaChua,
    String? tenPhong,
  }) {
    return LichSuSuaChuaPageModel(
      suaChua: suaChua ?? this.suaChua,
      hoaDonSuaChua: hoaDonSuaChua ?? this.hoaDonSuaChua,
      tenPhong: tenPhong ?? this.tenPhong,
    );
  }

  @override
  String toString() {
    return 'LichSuSuaChuaPageModel('
        'suaChua: $suaChua, '
        'hoaDonSuaChua: $hoaDonSuaChua, '
        'tenPhong: $tenPhong'
        ')';
  }
}
