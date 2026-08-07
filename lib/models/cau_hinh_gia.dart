class CauHinhGia {
  final int? id;
  final double giaDien;
  final double giaNuoc;
  final double giaXeMay;
  final double giaXeHoi;
  final double giaXeDap;
  final DateTime? updatedAt;

  CauHinhGia({
    this.id,
    required this.giaDien,
    required this.giaNuoc,
    this.giaXeMay = 0,
    this.giaXeHoi = 0,
    this.giaXeDap = 0,
    this.updatedAt,
  });

  factory CauHinhGia.fromMap(Map<String, dynamic> map) {
    return CauHinhGia(
      id: map['id'] as int?,
      giaDien: (map['giaDien'] as num?)?.toDouble() ?? 0.0,
      giaNuoc: (map['giaNuoc'] as num?)?.toDouble() ?? 0.0,
      giaXeMay: (map['giaXeMay'] as num?)?.toDouble() ?? 0.0,
      giaXeHoi: (map['giaXeHoi'] as num?)?.toDouble() ?? 0.0,
      giaXeDap: (map['giaXeDap'] as num?)?.toDouble() ?? 0.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'giaDien': giaDien,
      'giaNuoc': giaNuoc,
      'giaXeMay': giaXeMay,
      'giaXeHoi': giaXeHoi,
      'giaXeDap': giaXeDap,
    };
  }
}