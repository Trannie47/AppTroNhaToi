class PhieuThuDienNuoc {
  final int? phieuThuDienNuocId;
  final int phongId;
  final String thangNam;
  final int lanGhi;
  final DateTime? ngayThu;
  final double soTien;
  final String? ghiChu;
  final bool isDelete;

  PhieuThuDienNuoc({
    this.phieuThuDienNuocId,
    required this.phongId,
    required this.thangNam,
    required this.lanGhi,
    this.ngayThu,
    required this.soTien,
    this.ghiChu,
    this.isDelete = false,
  });

  factory PhieuThuDienNuoc.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return PhieuThuDienNuoc(
      phieuThuDienNuocId: parseInt(map['phieuThuDienNuocId']),
      phongId: parseInt(map['phongId']),
      thangNam: map['thangNam']?.toString() ?? '',
      lanGhi: parseInt(map['lanGhi']),
      ngayThu: map['ngayThu'] != null
          ? DateTime.tryParse(map['ngayThu'].toString())
          : null,
      soTien: parseDouble(map['soTien']),
      ghiChu: map['ghiChu'] as String?,
      isDelete: map['isDelete'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (phieuThuDienNuocId != null) 'phieuThuDienNuocId': phieuThuDienNuocId,
      'phongId': phongId,
      'thangNam': thangNam,
      'lanGhi': lanGhi,
      if (ngayThu != null) 'ngayThu': ngayThu?.toIso8601String(),
      'soTien': soTien,
      'ghiChu': ghiChu,
      'isDelete': isDelete,
    };
  }

  @override
  String toString() {
    return 'PhieuThuDienNuoc(phieuThuDienNuocId: $phieuThuDienNuocId, phongId: $phongId, '
        'thangNam: $thangNam, lanGhi: $lanGhi, soTien: $soTien, ghiChu: $ghiChu)';
  }
}