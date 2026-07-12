class SuaChua {
  final int? id;
  final int? phongID;
  final int? thietBiID;
  final String? nguyenNhan;
  final DateTime? ngaySuaChua;

  SuaChua({
    this.id,
    this.phongID,
    this.thietBiID,
    this.nguyenNhan,
    this.ngaySuaChua,
  });

  factory SuaChua.fromMap(Map<String, dynamic> map) {
    return SuaChua(
      id: map['id'] as int?,
      phongID: map['phongId'] as int?,
      thietBiID: map['thietBiId'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua: map['ngaySuaChua'] != null
          ? DateTime.tryParse(map['ngaySuaChua'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'phongId': phongID,
      'thietBiId': thietBiID,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua?.toIso8601String().split('T').first,
    };
  }

  SuaChua copyWith({
    int? id,
    int? phongID,
    int? thietBiID,
    String? nguyenNhan,
    DateTime? ngaySuaChua,
    bool? isDelete,
  }) {
    return SuaChua(
      id: id ?? this.id,
      phongID: phongID ?? this.phongID,
      thietBiID: thietBiID ?? this.thietBiID,
      nguyenNhan: nguyenNhan ?? this.nguyenNhan,
      ngaySuaChua: ngaySuaChua ?? this.ngaySuaChua,
    );
  }

  @override
  String toString() {
    return 'SuaChua('
        'id: $id, '
        'phongID: $phongID, '
        'thietBiID: $thietBiID, '
        'nguyenNhan: $nguyenNhan, '
        'ngaySuaChua: $ngaySuaChua, '
        ')';
  }
}
