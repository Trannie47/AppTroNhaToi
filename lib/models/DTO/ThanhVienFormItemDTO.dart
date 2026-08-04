import 'NguoiThueAvailableDTO.dart';

class ThanhVienFormItemDTO {
  final NguoiThueAvailableDTO nguoiThue;
  final String quanHe;

  const ThanhVienFormItemDTO({
    required this.nguoiThue,
    required this.quanHe,
  });

  int get idnt => nguoiThue.idnt;

  Map<String, dynamic> toJson({bool laDaiDien = false}) {
    return {
      'idnt': idnt,
      'laDaiDien': laDaiDien,
      'quanHeVoiDaiDien': laDaiDien ? null : quanHe,
    };
  }
}
