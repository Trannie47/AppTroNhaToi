class HoaDonSuaChua {
  final String? maHoaDonSC;
  final int?
  trangThai; //mặc định là 0 // 0: Đang sửa chữa, 1: Đã hoàn thành , 2: Đã thanh toán, 3: Đã hủy
  final double? giaTien;
  final int?
  loaiSua; //mặc định là 0  //0: Sửa chữa nhỏ, 1: Sửa chữa lớn, 2: Bảo trì định kỳ, 3: Thay thế linh kiện, 4: Vệ sinh thiết bị, 5: Khắc phục sự cố điện, 6: Khắc phục sự cố nước, 7: Sửa chữa khẩn cấp, 8: Nâng cấp thiết bị, 9: Khác
  final DateTime? ngayLapHoaDonSC;
  final int? idSuaChua; // FK -> suachua.id

  HoaDonSuaChua({
    this.maHoaDonSC,
    this.trangThai = 0,
    this.giaTien,
    this.loaiSua = 0,
    this.ngayLapHoaDonSC,
    this.idSuaChua,
  });

  factory HoaDonSuaChua.fromMap(Map<String, dynamic> map) {
    return HoaDonSuaChua(
      maHoaDonSC: map['maHoaDonSC'] as String?,
      trangThai: map['TrangThai'] as int,
      giaTien: (map['giaTien'] as num?)?.toDouble(),
      loaiSua: map['loaiSua'] as int,
      ngayLapHoaDonSC: map['ngayLapHoaDonSC'] != null
          ? DateTime.tryParse(map['ngayLapHoaDonSC'] as String)
          : null,
      idSuaChua: map['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDonSC != null) 'maHoaDonSC': maHoaDonSC,
      'TrangThai': trangThai,
      'giaTien': giaTien,
      'loaiSua': loaiSua,
      'ngayLapHoaDonSC': ngayLapHoaDonSC?.toIso8601String().split('T').first,
      'idSuaChua': idSuaChua,
    };
  }

  HoaDonSuaChua copyWith({
    String? maHoaDonSC,
    int? trangThai,
    double? giaTien,
    int? loaiSua,
    DateTime? ngayLapHoaDonSC,
    int? id,
  }) {
    return HoaDonSuaChua(
      maHoaDonSC: maHoaDonSC ?? this.maHoaDonSC,
      trangThai: trangThai ?? this.trangThai,
      giaTien: giaTien ?? this.giaTien,
      loaiSua: loaiSua ?? this.loaiSua,
      ngayLapHoaDonSC: ngayLapHoaDonSC ?? this.ngayLapHoaDonSC,
      idSuaChua: id ?? this.idSuaChua,
    );
  }

  // 0: Đang sửa chữa, 1: Đã hoàn thành , 2: Đã thanh toán, 3: Đã hủy
  String get trangThaiText {
    switch (trangThai) {
      case 0:
        return "Đang sửa chữa";
      case 1:
        return "Đã hoàn thành";
      case 2:
        return "Đã thanh toán";
      case 3:
        return "Đã hủy";
      default:
        return "";
    }
  }

  // 0: Sửa chữa nhỏ, 1: Sửa chữa lớn, 2: Bảo trì định kỳ, 3: Thay thế linh kiện, 4: Vệ sinh thiết bị, 5: Khắc phục sự cố điện, 6: Khắc phục sự cố nước, 7: Sửa chữa khẩn cấp, 8: Nâng cấp thiết bị, 9: Khác
  String get loaiSuaText {
    switch (loaiSua) {
      case 0:
        return "Sửa chữa nhỏ";
      case 1:
        return "Sửa chữa lớn";
      case 2:
        return "Bảo trì định kỳ";
      case 3:
        return "Thay thế linh kiện";
      case 4:
        return "Vệ sinh thiết bị";
      case 5:
        return "Khắc phục sự cố điện";
      case 6:
        return "Khắc phục sự cố nước";
      case 7:
        return "Sửa chữa khẩn cấp";
      case 8:
        return "Nâng cấp thiết bị";
      case 9:
        return "Khác";
      default:
        return "";
    }
  }

  @override
  String toString() {
    return 'HoaDonSuaChua(maHoaDonSC: $maHoaDonSC, trangThai: $trangThai, '
        'giaTien: $giaTien, loaiSua: $loaiSua, '
        'ngayLapHoaDonSC: $ngayLapHoaDonSC, id: $idSuaChua)';
  }
}
