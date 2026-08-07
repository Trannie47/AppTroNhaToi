import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';

class LapRap {
  final int? id;
  final int? phongID;
  final int? thietBiID;
  final DateTime? ngayLap;
  final String? ghiChu;
  final ThietBi? thietBi;
  final Phong? phong;

  LapRap({
    this.id,
    this.phongID,
    this.thietBiID,
    this.ngayLap,
    this.ghiChu,
    this.thietBi,
    this.phong,
  });

  factory LapRap.fromMap(Map<String, dynamic> map) {
    return LapRap(
      id: map['id'] as int?,
      phongID: (map['phongId'] ?? map['PhongID']) as int?,
      thietBiID: (map['thietBiId'] ?? map['thietBiID']) as int?,
      ngayLap: map['ngayLap'] != null
          ? DateTime.tryParse(map['ngayLap'] as String)
          : null,
      ghiChu: map['ghiChu'] as String?,
      thietBi: (map['thietbi'] ?? map['thietBi']) != null
          ? ThietBi.fromMap(
              (map['thietbi'] ?? map['thietBi']) as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'phongId': phongID,
      'thietBiId': thietBiID,
      'ngayLap': ngayLap?.toIso8601String().split('T').first,
      'ghiChu': ghiChu,
    };
  }

  LapRap copyWith({
    int? id,
    int? phongID,
    int? thietBiID,
    DateTime? ngayLap,
    String? ghiChu,
    ThietBi? thietBi,
  }) {
    return LapRap(
      id: id ?? this.id,
      phongID: phongID ?? this.phongID,
      thietBiID: thietBiID ?? this.thietBiID,
      ngayLap: ngayLap ?? this.ngayLap,
      ghiChu: ghiChu ?? this.ghiChu,
      thietBi: thietBi ?? this.thietBi,
    );
  }

  @override
  String toString() {
    return 'LapRap(id: $id, phongID: $phongID, thietBiID: $thietBiID, '
        'ngayLap: $ngayLap, ghiChu: $ghiChu, thietBi: $thietBi)';
  }
}
