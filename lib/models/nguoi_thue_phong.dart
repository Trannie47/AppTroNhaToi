import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';

class NguoiThuePhong {

  final NguoiThue nguoiThue;

  final List<Phong> phong;

  /// CONSTRUCTOR
  NguoiThuePhong({
    required this.nguoiThue,
    required this.phong,
  });

  factory NguoiThuePhong.fromJson(
      Map<String, dynamic> json,
      ) {
    return NguoiThuePhong(
      nguoiThue: NguoiThue.fromMap(
        json['nguoi_thue'],
      ),

      // phong:
      // (json['phong'] as List<dynamic>)
      //     .map(
      //       (e) => Phong.fromMap(e),
      // )
      //     .toList(),

      phong:
      json['phong'] != null
          ? [
        Phong.fromMap(
          json['phong'],
        ),
      ]
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nguoi_thue': nguoiThue.toMap(),

      'phong':
      phong
          .map((e) => e.toMap())
          .toList(),
    };
  }

  /// COPY WITH dùng để tạo object mới nhưng giữ dữ liệu cũ
  NguoiThuePhong copyWith({
    NguoiThue? nguoiThue,
    List<Phong>? phong,
  }) {
    return NguoiThuePhong(
      nguoiThue:
      nguoiThue ?? this.nguoiThue,

      phong:
      phong ?? this.phong,
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