class CauHinhGia {
  final int? id;
  final double giaDien;
  final double giaNuoc;
  final DateTime? updatedAt;

  CauHinhGia({
    this.id,
    required this.giaDien,
    required this.giaNuoc,
    this.updatedAt,
  });

  factory CauHinhGia.fromMap(Map<String, dynamic> map) {
    return CauHinhGia(
      id: map['id'] as int?,
      giaDien: (map['giaDien'] as num?)?.toDouble() ?? 0.0,
      giaNuoc: (map['giaNuoc'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'giaDien': giaDien,
      'giaNuoc': giaNuoc,
    };
  }
}