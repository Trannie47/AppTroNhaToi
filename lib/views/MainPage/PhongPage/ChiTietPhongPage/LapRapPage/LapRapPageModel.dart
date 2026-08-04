import 'package:AppTroNhaToi/models/lap_rap.dart';

class LapRapPageModel {
  final LapRap lapRap;
  final int trangThai; // 0: bình thường, 1: đang sửa, 2: hỏng

  LapRapPageModel({required this.lapRap, this.trangThai = 0});

  factory LapRapPageModel.fromMap(Map<String, dynamic> map) {
    return LapRapPageModel(
      lapRap: LapRap.fromMap(map),
      trangThai: map['trangThai'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {...lapRap.toMap(), 'trangThai': trangThai};
  }

  @override
  String toString() {
    return 'LapRapPageModel('
        'lapRap: $lapRap, '
        'trangThai: $trangThai'
        ')';
  }
}
