class SuaChua {
  final int? id;
  final int? phongID;
  final String? nguyenNhan;
  final DateTime? ngaySuaChua;

  SuaChua({this.id, this.phongID, this.nguyenNhan, this.ngaySuaChua});

  factory SuaChua.fromMap(Map<String, dynamic> map) {
    return SuaChua(
      id: map['id'] as int?,
      phongID: map['PhongID'] as int?,
      nguyenNhan: map['nguyenNhan'] as String?,
      ngaySuaChua: map['ngaySuaChua'] != null
          ? DateTime.tryParse(map['ngaySuaChua'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'PhongID': phongID,
      'nguyenNhan': nguyenNhan,
      'ngaySuaChua': ngaySuaChua?.toIso8601String().split('T').first,
    };
  }

  SuaChua copyWith({
    int? id,
    int? phongID,
    String? nguyenNhan,
    DateTime? ngaySuaChua,
  }) {
    return SuaChua(
      id: id ?? this.id,
      phongID: phongID ?? this.phongID,
      nguyenNhan: nguyenNhan ?? this.nguyenNhan,
      ngaySuaChua: ngaySuaChua ?? this.ngaySuaChua,
    );
  }

  @override
  String toString() {
    return 'SuaChua(id: $id, phongID: $phongID, '
        'nguyenNhan: $nguyenNhan, ngaySuaChua: $ngaySuaChua)';
  }
}
