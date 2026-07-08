import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';

//SQL
//Select HoaDon.*, PhieuThuHdTh.*, NguoiThue.hoTen as  tenNguoiMua
//FROM HoaDon
//LEFT JOIN PhieuThuHdTh ON PhieuThuHdTh.maHoaDon = HoaDon.maHoaDon
//LEFT JOIN NguoiThue as NT On HoaDon.idnt = NguoiThue.id
class HoaDonTapHoaModel {
  final HoaDonTapHoa hoaDon;

  /// Tổng số tiền đã thu
  final double daThu;

  /// Tổng tiền hóa đơn
  final double tongTien;

  final String? tenNguoiMua;

  HoaDonTapHoaModel({
    required this.hoaDon,
    required this.daThu,
    required this.tongTien,
    this.tenNguoiMua,
  });

  factory HoaDonTapHoaModel.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoaModel(
      hoaDon: HoaDonTapHoa.fromMap(map['hoaDon'] as Map<String, dynamic>),
      daThu: (map['daThu'] as num?)?.toDouble() ?? 0,
      tongTien: (map['tongtien'] as num?)?.toDouble() ?? 0,
      tenNguoiMua: map['tenNguoiMua'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hoaDon': hoaDon.toMap(),
      'daThu': daThu,
      'tongtien': tongTien,
      'tenNguoiMua': tenNguoiMua,
    };
  }

  @override
  String toString() {
    return 'HoaDonTapHoaModel('
        'hoaDon: ${hoaDon.maHoaDon}, '
        'idNguoiMua: ${hoaDon.idnt}, '
        'tenNguoiMua: $tenNguoiMua, '
        'daThu: $daThu, '
        'tongTien: $tongTien'
        ')';
  }
}
