import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';

class SuaChua {
  final int? id;
  final int? thietBiID;
  final int? lapRapID;
  final String? nguyenNhan;
  final DateTime? ngaySuaChua;

  SuaChua({
    this.id,
    this.thietBiID,
    this.lapRapID,
    this.nguyenNhan,
    this.ngaySuaChua,
  });

  factory SuaChua.fromMap(Map<String, dynamic> map) {
    return SuaChua(
      id: map['id'] as int?,
      thietBiID: (map['thietBiId'] ?? map['thietBiID']) as int?,
      lapRapID: (map['lapRapId'] ?? map['LapRapID']) as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua: map['ngaySuaChua'] != null
          ? DateTime.tryParse(map['ngaySuaChua'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'thietBiId': thietBiID,
      'lapRapId': lapRapID,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua?.toIso8601String().split('T').first,
    };
  }

  SuaChua copyWith({
    int? id,
    int? thietBiID,
    int? lapRapID,
    String? nguyenNhan,
    DateTime? ngaySuaChua,
  }) {
    return SuaChua(
      id: id ?? this.id,
      thietBiID: thietBiID ?? this.thietBiID,
      lapRapID: lapRapID ?? this.lapRapID,
      nguyenNhan: nguyenNhan ?? this.nguyenNhan,
      ngaySuaChua: ngaySuaChua ?? this.ngaySuaChua,
    );
  }

  @override
  String toString() {
    return 'SuaChua(id: $id, thietBiID: $thietBiID, lapRapID: $lapRapID, '
        'nguyenNhan: $nguyenNhan, ngaySuaChua: $ngaySuaChua, '
        ')';
  }
}
