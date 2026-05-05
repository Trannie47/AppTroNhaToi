class DienNuoc {
  final int? idDienNuoc;
  final int? phongID;
  final String? thangNam;
  final int? chiSoDien;
  final int? chiSoNuoc;

  DienNuoc({
    this.idDienNuoc,
    this.phongID,
    this.thangNam,
    this.chiSoDien,
    this.chiSoNuoc,
  });

  factory DienNuoc.fromMap(Map<String, dynamic> map) {
    return DienNuoc(
      idDienNuoc: map['idDienNuoc'] as int?,
      phongID: map['PhongID'] as int?,
      thangNam: map['thangNam'] as String?,
      chiSoDien: map['chiSoDien'] as int?,
      chiSoNuoc: map['chiSoNuoc'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idDienNuoc != null) 'idDienNuoc': idDienNuoc,
      'PhongID': phongID,
      'thangNam': thangNam,
      'chiSoDien': chiSoDien,
      'chiSoNuoc': chiSoNuoc,
    };
  }

  DienNuoc copyWith({
    int? idDienNuoc,
    int? phongID,
    String? thangNam,
    int? chiSoDien,
    int? chiSoNuoc,
  }) {
    return DienNuoc(
      idDienNuoc: idDienNuoc ?? this.idDienNuoc,
      phongID: phongID ?? this.phongID,
      thangNam: thangNam ?? this.thangNam,
      chiSoDien: chiSoDien ?? this.chiSoDien,
      chiSoNuoc: chiSoNuoc ?? this.chiSoNuoc,
    );
  }

  @override
  String toString() {
    return 'DienNuoc(idDienNuoc: $idDienNuoc, phongID: $phongID, '
        'thangNam: $thangNam, chiSoDien: $chiSoDien, chiSoNuoc: $chiSoNuoc)';
  }
}
