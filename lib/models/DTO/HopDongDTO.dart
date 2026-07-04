class HopDongDTO {
  final String hopDongID;
  final int idnt;
  final int phongID;
  final DateTime ngayKy;
  final DateTime ngayHetHan;
  final double tienCoc;
  final double giaPhongThucTe;
  final int trangThai;
  final PhongHD phong;
  final NguoiThueHD nguoithue;
  HopDongDTO({
    required this.hopDongID,
    required this.idnt,
    required this.phongID,
    required this.ngayKy,
    required this.ngayHetHan,
    required this.tienCoc,
    required this.giaPhongThucTe,
    required this.trangThai,
    required this.phong,
    required this.nguoithue,
});
  factory HopDongDTO.fromMap(Map<String,dynamic> json){
    return HopDongDTO(
      hopDongID: json['hopDongId'] ?? '',
      idnt: json['idnt'] ?? 0,
      phongID: json['phongId'] ?? 0,
      ngayKy: DateTime.parse(json['ngayKy']),
      ngayHetHan: DateTime.parse(json['ngayHetHan']),
        tienCoc: json['tienCoc'] is num
            ? (json['tienCoc'] as num).toDouble()
            : double.tryParse(json['tienCoc']?.toString() ?? '') ?? 0.0,
      giaPhongThucTe: json['giaPhongThucTe'] is num
          ? (json['giaPhongThucTe'] as num).toDouble()
          : double.tryParse(json['giaPhongThucTe']?.toString() ?? '') ?? 0.0,
      trangThai: json['trangThai'] ?? 0,
      phong: PhongHD.fromMap(json['phong'] ?? {}),
      nguoithue: NguoiThueHD.fromMap(json['nguoithue'] ?? {}),
    );
  }
}
class PhongHD{
  final String tenPhong;
  PhongHD({required this.tenPhong});
  factory PhongHD.fromMap(Map<String,dynamic> json) =>
      PhongHD(tenPhong: json['tenPhong']?? 'Không rõ');
}
class NguoiThueHD{
  final String hoTen;
  NguoiThueHD({required this.hoTen});
  factory NguoiThueHD.fromMap(Map<String,dynamic> json)=>
      NguoiThueHD(hoTen: json['hoTen']?? 'Không rõ');
}