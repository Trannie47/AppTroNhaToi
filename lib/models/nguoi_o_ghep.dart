import 'package:AppTroNhaToi/core/utils/model_formatter.dart';

class NguoiOGhep {
  final String cccd;
  final String? hoTen;
  final String? sdt;
  final String? quanHeVoiDaiDien;
  final String hopDongId;
  final bool isDelete;

  NguoiOGhep({
    required this.cccd,
    this.hoTen,
    this.sdt,
    this.quanHeVoiDaiDien,
    required this.hopDongId,
    this.isDelete = false,
  });

  factory NguoiOGhep.fromMap(Map<String, dynamic> map) {
    return NguoiOGhep(
      cccd: strOf(map['cccd']) ?? '',
      hoTen: strOf(map['hoTen']),
      sdt: strOf(map['sdt'] ?? map['SDT']),
      quanHeVoiDaiDien: strOf(map['quanHeVoiDaiDien']),
      hopDongId: strOf(map['hopDongId'] ?? map['HopDongID']) ?? '',
      isDelete: map['isDelete'] == true || map['isDelete'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cccd': cccd,
      'hoTen': hoTen,
      'sdt': sdt,
      'quanHeVoiDaiDien': quanHeVoiDaiDien,
      'hopDongId': hopDongId,
      'isDelete': isDelete,
    };
  }

  @override
  String toString() {
    return 'NguoiOGhep(cccd: $cccd, hoTen: $hoTen, sdt: $sdt, '
        'quanHeVoiDaiDien: $quanHeVoiDaiDien, hopDongId: $hopDongId)';
  }
}
