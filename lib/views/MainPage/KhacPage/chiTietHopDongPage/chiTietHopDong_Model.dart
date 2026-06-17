import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';

//SQL
//Select HoaDon.*, PhieuThuHdTh.*, NguoiThue.hoTen as  tenNguoiMua
//FROM hopDong AS HD1
//LEFT JOIN hopDong AS HD2 ON HD1.PhongID = HD2.PhongId AND HD1.hopDongID <> HD2.hopDongID AND HD.trangThai = 1
//JOIN NguoiThue as NT On HD2.idnt = NguoiThue.id
class chiTietHopDongModel {
  final HopDong hopDong;
  final NguoiThue nguoiThue;

  chiTietHopDongModel({required this.hopDong, required this.nguoiThue});
}
