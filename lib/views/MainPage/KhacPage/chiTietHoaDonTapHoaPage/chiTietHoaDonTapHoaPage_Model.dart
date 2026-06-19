import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';

// Yêu Cầu mỗi chi tiết tạp hoá đều có 1 hàng hoá
//
//From ChiTietTapHoa AS chiTietTapHoa
//JOIN HangHoa AS HangHoa
//WHERE chiTietTapHoa.MaHoaDon = $MaHoaDon

//$MaHoaDon tham soos Truyền vào

class chiTietHoaDonTapHoaPageModel {
  final ChiTietTapHoa chiTietTapHoa; //Chính
  final HangHoa hangHoa;

  chiTietHoaDonTapHoaPageModel({
    required this.chiTietTapHoa,
    required this.hangHoa,
  });

  factory chiTietHoaDonTapHoaPageModel.fromMap(Map<String, dynamic> map) {
    return chiTietHoaDonTapHoaPageModel(
      chiTietTapHoa: map['chiTietTapHoa'] is Map
          ? ChiTietTapHoa.fromMap(map['chiTietTapHoa'] as Map<String, dynamic>)
          : ChiTietTapHoa.fromMap(map),
      hangHoa: map['hangHoa'] != null
          ? HangHoa.fromMap(map['hangHoa'] as Map<String, dynamic>)
          : HangHoa.fromMap(map),
    );
  }

  Map<String, dynamic> toMap() {
    return {'chiTietTapHoa': chiTietTapHoa.toMap(), 'hangHoa': hangHoa.toMap()};
  }
}
