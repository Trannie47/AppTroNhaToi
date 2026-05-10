import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';

class NguoiThuePhong {
  final NguoiThue nguoiThue;
  final Phong? phong;

  NguoiThuePhong({required this.nguoiThue, required this.phong});

  factory NguoiThuePhong.fromJson(Map<String, dynamic> json) {
    return NguoiThuePhong(
      nguoiThue: NguoiThue.fromMap(json['nguoi_thue']),
      phong: json['phong'] != null ? Phong.fromMap(json['phong']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'nguoi_thue': nguoiThue.toMap(), 'phong': phong?.toMap()};
  }

  NguoiThuePhong copyWith({NguoiThue? nguoiThue, Phong? phong}) {
    return NguoiThuePhong(
      nguoiThue: nguoiThue ?? this.nguoiThue,
      phong: phong ?? this.phong,
    );
  }

  @override
  String toString() {
    return 'NguoiThuePhong('
        'nguoiThue: $nguoiThue, '
        'phong: $phong'
        ')';
  }
}
