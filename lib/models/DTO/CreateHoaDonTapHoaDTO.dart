import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

class CreateHoaDonTapHoaRequest {
  final HoaDonTapHoa hoaDon;
  final List<ChiTietTapHoa> chiTiet;
  final PhieuThuHdTh? phieuThu;

  CreateHoaDonTapHoaRequest({
    required this.hoaDon,
    required this.chiTiet,
    this.phieuThu,
  });

  Map<String, dynamic> toMap() {
    return {
      'hoaDon': hoaDon.toMap(),
      'chiTiet': chiTiet.map((e) => e.toMap()).toList(),
      'phieuThu': phieuThu?.toMap(),
    };
  }
}
