class HoaDonGuiXe {

  final int? maHoaDon;

  final String? thangNam;

  final double? soTien;

  final String? bienSo;

  /// 0 = chưa thu
  /// 1 = đã thu
  /// 2 = không còn ở
  /// 3 = đã hủy
  final int? trangThai;

  /// số lượng xe
  final int? soLuongXe;

  HoaDonGuiXe({
    this.maHoaDon,
    this.thangNam,
    this.soTien,
    this.bienSo,
    this.trangThai,
    this.soLuongXe,
  });

  factory HoaDonGuiXe.fromMap(
      Map<String, dynamic> map,
      ) {
    return HoaDonGuiXe(
      maHoaDon:
      map['maHoaDon'] as int?,

      thangNam:
      map['thangNam'] as String?,

      soTien:
      (map['soTien'] as num?)
          ?.toDouble(),

      bienSo:
      map['bienSo'] as String?,

      trangThai:
      map['trangThai'] as int?,

      soLuongXe:
      map['soLuongXe'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {

      if (maHoaDon != null)
        'maHoaDon': maHoaDon,

      'thangNam': thangNam,

      'soTien': soTien,

      'bienSo': bienSo,

      'trangThai': trangThai,

      'soLuongXe': soLuongXe,
    };
  }

  HoaDonGuiXe copyWith({
    int? maHoaDon,
    String? thangNam,
    double? soTien,
    String? bienSo,
    int? trangThai,
    int? soLuongXe,
  }) {
    return HoaDonGuiXe(
      maHoaDon:
      maHoaDon ?? this.maHoaDon,

      thangNam:
      thangNam ?? this.thangNam,

      soTien:
      soTien ?? this.soTien,

      bienSo:
      bienSo ?? this.bienSo,

      trangThai:
      trangThai ?? this.trangThai,

      soLuongXe:
      soLuongXe ?? this.soLuongXe,
    );
  }

  @override
  String toString() {
    return 'HoaDonGuiXe('
        'maHoaDon: $maHoaDon, '
        'thangNam: $thangNam, '
        'soTien: $soTien, '
        'bienSo: $bienSo, '
        'trangThai: $trangThai, '
        'soLuongXe: $soLuongXe'
        ')';
  }
}