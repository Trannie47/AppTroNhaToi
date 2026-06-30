import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

//SQL
//Select HoaDon.*, PhieuThuHdTh.*, NguoiThue.hoTen as  tenNguoiMua
//FROM HoaDon
//LEFT JOIN PhieuThuHdTh ON PhieuThuHdTh.maHoaDon = HoaDon.maHoaDon
//LEFT JOIN NguoiThue as NT On HoaDon.idnt = NguoiThue.id
class HoaDonTapHoaModel {
  final HoaDonTapHoa hoaDon;

  final PhieuThuHdTh? phieuThu;

  final String? tenNguoiMua;

  HoaDonTapHoaModel({required this.hoaDon, this.phieuThu, this.tenNguoiMua});

  factory HoaDonTapHoaModel.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoaModel(
      hoaDon: map['hoaDon'] is Map
          ? HoaDonTapHoa.fromMap(map['hoaDon'] as Map<String, dynamic>)
          : HoaDonTapHoa.fromMap(map),

      phieuThu: map['phieuThu'] != null
          ? PhieuThuHdTh.fromMap(map['phieuThu'] as Map<String, dynamic>)
          : null,

      tenNguoiMua: map['tenNguoiMua'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hoaDon': hoaDon.toMap(),

      if (phieuThu != null) 'phieuThu': phieuThu!.toMap(),

      'tenNguoiMua': tenNguoiMua,
    };
  }

  @override
  String toString() {
    return 'HoaDonTapHoaModel('
        'hoaDon: ${hoaDon.maHoaDon}, '
        'idnguoiMua : ${hoaDon.idnt ?? 'null'}'
        'tenNguoiMua: ${tenNguoiMua ?? 'null'}, '
        'phieuThu: ${phieuThu?.toString() ?? 'null'}, '
        ')';
  }
}
