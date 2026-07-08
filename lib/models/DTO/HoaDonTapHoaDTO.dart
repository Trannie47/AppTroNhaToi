import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

class HoaDonTapHoaDTO {
  final String? maHoaDon;
  final int? idnt;
  final DateTime ngayBan;
  final double tongTien;
  final List<ChiTietTapHoa> chiTietTapHoa;
  final List<PhieuThuHdTh> phieuThuHdTh;

  HoaDonTapHoaDTO({
    this.maHoaDon,
    this.idnt,
    required this.ngayBan,
    required this.tongTien,
    required this.chiTietTapHoa,
    this.phieuThuHdTh = const [],
  });

  factory HoaDonTapHoaDTO.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoaDTO(
      maHoaDon: map["maHoaDon"] as String?,
      idnt: map["idnt"] as int?,
      ngayBan:
          DateTime.tryParse(map["ngayBan"]?.toString() ?? "") ?? DateTime.now(),
      tongTien: double.tryParse(map["tongTien"]?.toString() ?? "0") ?? 0,
      chiTietTapHoa:
          (map["chiTietTapHoa"] as List<dynamic>?)
              ?.map((e) => ChiTietTapHoa.fromMap(e))
              .toList() ??
          [],
      phieuThuHdTh:
          (map["phieuThuHdTh"] as List<dynamic>?)
              ?.map((e) => PhieuThuHdTh.fromMap(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null && maHoaDon!.isNotEmpty) "maHoaDon": maHoaDon,

      if (idnt != null) "idnt": idnt,

      "ngayBan": ngayBan.toUtc().toIso8601String(),
      "tongTien": tongTien,

      "chiTietTapHoa": chiTietTapHoa
          .map((e) => {"maHangHoa": e.maHangHoa, "soLuong": e.soLuong})
          .toList(),

      "phieuThuHdTh": phieuThuHdTh
          .map(
            (e) => {
              if (e.maPhieuThu != null) "maPhieuThu": e.maPhieuThu,
              "ngayThu": e.ngayThu?.toUtc().toIso8601String(),
              "soTien": e.soTien,
              "nguoiDong": e.nguoiDong,
            },
          )
          .toList(),
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
