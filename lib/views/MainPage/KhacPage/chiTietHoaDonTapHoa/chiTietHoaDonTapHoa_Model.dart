import 'package:AppTroNhaToi/models/chi_tiet_tap_hoa.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';

// Yêu Cầu mỗi chi tiết tạp hoá đều có 1 hàng hoá
//
//From ChiTietTapHoa AS chiTietTapHoa
//JOIN HangHoa AS HangHoa
//WHERE chiTietTapHoa.MaHoaDon = $MaHoaDon

//$MaHoaDon tham soos Truyền vào

class chiTietHoaDonTapHoaModel {
  final ChiTietTapHoa chiTietTapHoa; //Chính
  final HangHoa hangHoa;

  chiTietHoaDonTapHoaModel({
    required this.chiTietTapHoa,
    required this.hangHoa,
  });
}
