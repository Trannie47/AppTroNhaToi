import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

class HoaDonTapHoaDTO {
  final String? maHoaDon;
  final int? idnt;
  final DateTime ngayBan;
  final double? tongTien;
  final List<ChiTietTapHoa> chiTietTapHoa;
  final PhieuThuHdTh? phieuThuHdTh;

  HoaDonTapHoaDTO({
    this.idnt,
    required this.ngayBan,
    required this.tongTien,
    required this.chiTietTapHoa,
    this.phieuThuHdTh,
    this.maHoaDon,
  });

  factory HoaDonTapHoaDTO.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoaDTO(
      maHoaDon: map["maHoaDon"] as String?,
      idnt: map["idnt"] as int?,
      ngayBan: DateTime.parse(map["ngayBan"].toString()),
      tongTien: map['tongTien'] == null
          ? null
          : double.tryParse(map['tongTien'].toString()),
      chiTietTapHoa:
          (map["chiTietTapHoa"] as List<dynamic>?)
              ?.map((e) => ChiTietTapHoa.fromMap(e))
              .toList() ??
          [],
      phieuThuHdTh: map["phieuThuHdTh"] != null
          ? PhieuThuHdTh.fromMap(map["phieuThuHdTh"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null && maHoaDon!.isNotEmpty) "maHoaDon": maHoaDon,

      "idnt": idnt,
      "ngayBan": ngayBan.toUtc().toIso8601String(),
      "tongTien": tongTien,

      "chiTietTapHoa": chiTietTapHoa.map((e) {
        return {"maHangHoa": e.maHangHoa, "soLuong": e.soLuong};
      }).toList(),

      if (phieuThuHdTh != null)
        "phieuThuHdTh": {
          "ngayThu": phieuThuHdTh!.ngayThu?.toUtc().toIso8601String(),
          "soTien": phieuThuHdTh!.soTien,
          "nguoiDong": phieuThuHdTh!.nguoiDong,
        },
    };
  }

  @override
  String toString() {
    return 'HoaDonTapHoaDTO('
        'maHoaDon: $maHoaDon, '
        'idnt: $idnt, '
        'ngayBan: $ngayBan, '
        'tongTien: $tongTien, '
        'chiTietTapHoa: $chiTietTapHoa, '
        'phieuThuHdTh: $phieuThuHdTh'
        ')';
  }
}
