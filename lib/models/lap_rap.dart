import 'package:AppTroNhaToi/models/thiet_bi.dart';

class LapRap {
  final int? id;
  final int? phongID;
  final int? thietBiID;
  final DateTime? ngayLap;
  final int? soLuong;
  final ThietBi? thietBi;

  LapRap({
    this.id,
    this.phongID,
    this.thietBiID,
    this.ngayLap,
    this.soLuong,
    this.thietBi,
  });

  factory LapRap.fromMap(Map<String, dynamic> map) {
    return LapRap(
      id: map['id'] as int?,
      phongID: (map['phongId'] ?? map['PhongID']) as int?,
      thietBiID: (map['thietBiId'] ?? map['thietBiID']) as int?,
      ngayLap: map['ngayLap'] != null
          ? DateTime.tryParse(map['ngayLap'] as String)
          : null,
      soLuong: map['soLuong'] as int?,
      thietBi: map['thietBi'] != null
          ? ThietBi.fromMap(map['thietBi'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'PhongID': phongID,
      'thietBiID': thietBiID,
      'ngayLap': ngayLap?.toIso8601String().split('T').first,
      'soLuong': soLuong,
      if (thietBi != null) 'thietBi': thietBi?.toMap(),
    };
  }

  LapRap copyWith({
    int? id,
    int? phongID,
    int? thietBiID,
    DateTime? ngayLap,
    int? soLuong,
    ThietBi? thietBi,
  }) {
    return LapRap(
      id: id ?? this.id,
      phongID: phongID ?? this.phongID,
      thietBiID: thietBiID ?? this.thietBiID,
      ngayLap: ngayLap ?? this.ngayLap,
      soLuong: soLuong ?? this.soLuong,
      thietBi: thietBi ?? this.thietBi,
    );
  }

  @override
  String toString() {
    return 'LapRap(id: $id, phongID: $phongID, thietBiID: $thietBiID, '
        'ngayLap: $ngayLap, soLuong: $soLuong,thietBi: $thietBi)';
  }
}
