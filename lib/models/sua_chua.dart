class SuaChua {
  final int? id;
  final int? phongID;
  final int? thietBiID;
  final String? nguyenNhan;
  final DateTime? ngaySuaChua;
  final bool isDelete;

  SuaChua({
    this.id,
    this.phongID,
    this.thietBiID,
    this.nguyenNhan,
    this.ngaySuaChua,
    this.isDelete = false,
  });

  factory SuaChua.fromMap(Map<String, dynamic> map) {
    return SuaChua(
      id: map['id'] as int?,
      phongID: map['PhongID'] as int?,
      thietBiID: map['thietBiID'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua: map['ngaySuaChua'] != null
          ? DateTime.tryParse(map['ngaySuaChua'].toString())
          : null,
      isDelete: map['isDelete'] == true || map['isDelete'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'PhongID': phongID,
      'thietBiID': thietBiID,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua?.toIso8601String().split('T').first,
      'isDelete': isDelete,
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
      isDelete: isDelete ?? this.isDelete,
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
        'isDelete: $isDelete'
        ')';
  }
}
