import 'package:AppTroNhaToi/core/utils/model_formatter.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';

class ItemNguoiLuanChuyenModel {
  final PhieuLuanChuyen phieuLuanChuyen;
  final bool isNguoiThueChinh;
  final String? hoTen;
  final String? sdt;

  ItemNguoiLuanChuyenModel({
    required this.phieuLuanChuyen,
    required this.isNguoiThueChinh,
    this.hoTen,
    this.sdt,
  });

  factory ItemNguoiLuanChuyenModel.fromMap(Map<String, dynamic> map) {
    return ItemNguoiLuanChuyenModel(
      phieuLuanChuyen: PhieuLuanChuyen.fromMap(map),
      isNguoiThueChinh: map['isNguoiThueChinh'] == true,
      hoTen: strOf(map['hoTen']),
      sdt: strOf(map['sdt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...phieuLuanChuyen.toMap(),
      'isNguoiThueChinh': isNguoiThueChinh,
      'hoTen': hoTen,
      'sdt': sdt,
    };
  }

  @override
  String toString() {
    return 'ItemNguoiLuanChuyen('
        'isNguoiThueChinh: $isNguoiThueChinh, '
        'hoTen: $hoTen, '
        'sdt: $sdt, '
        'phieuLuanChuyen: $phieuLuanChuyen'
        ')';
  }
}
