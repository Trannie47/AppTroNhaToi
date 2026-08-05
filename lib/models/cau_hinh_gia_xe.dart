class CauHinhGiaXe {
  final int? id;
  final int loaiXe; // 0: Xe máy, 1: Ô tô, 2: Xe đạp
  final String? tenLoaiXe;
  final double giaMacDinh;
  final DateTime? updatedAt;

  CauHinhGiaXe({
    this.id,
    required this.loaiXe,
    this.tenLoaiXe,
    required this.giaMacDinh,
    this.updatedAt,
  });

  factory CauHinhGiaXe.fromMap(Map<String, dynamic> map) {
    return CauHinhGiaXe(
      id: map['id'] as int?,
      loaiXe: map['loaiXe'] as int? ?? 0,
      tenLoaiXe: map['tenLoaiXe'] as String?,
      giaMacDinh: map['giaMacDinh'] is num
          ? (map['giaMacDinh'] as num).toDouble()
          : double.tryParse(map['giaMacDinh']?.toString() ?? '') ?? 0.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loaiXe': loaiXe,
      if (tenLoaiXe != null) 'tenLoaiXe': tenLoaiXe,
      'giaMacDinh': giaMacDinh,
    };
  }

  @override
  String toString() {
    return 'CauHinhGiaXe(loaiXe: $loaiXe, tenLoaiXe: $tenLoaiXe, giaMacDinh: $giaMacDinh)';
  }
}
