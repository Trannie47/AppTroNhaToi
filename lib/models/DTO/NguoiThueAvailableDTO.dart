class NguoiThueAvailableDTO {
  final int idnt;
  final String hoTen;
  final DateTime? ngaySinh;
  final int? trangThai;
  final int? tuoi;
  final bool? coTheLamDaiDien;
  final bool? coTheLamThanhVien;

  const NguoiThueAvailableDTO({
    required this.idnt,
    required this.hoTen,
    this.ngaySinh,
    this.trangThai,
    this.tuoi,
    this.coTheLamDaiDien,
    this.coTheLamThanhVien,
  });

  factory NguoiThueAvailableDTO.fromJson(Map<String, dynamic> json) {
    return NguoiThueAvailableDTO(
      idnt: json['idnt'] as int,
      hoTen: json['hoTen']?.toString() ?? '',
      ngaySinh: json['ngaySinh'] == null
          ? null
          : DateTime.tryParse(json['ngaySinh'].toString()),
      trangThai: json['trangThai'] is num
          ? (json['trangThai'] as num).toInt()
          : int.tryParse('${json['trangThai']}'),
      tuoi: json['tuoi'] is num
          ? (json['tuoi'] as num).toInt()
          : int.tryParse('${json['tuoi']}'),
      coTheLamDaiDien: json['coTheLamDaiDien'] as bool?,
      coTheLamThanhVien: json['coTheLamThanhVien'] as bool?,
    );
  }
}
