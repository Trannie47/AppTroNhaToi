import 'HopDongDTO.dart';

class ThanhVienHopDongDTO {
  final int? id;
  final String? hopDongId;
  final int idnt;
  final bool laDaiDien;
  final String? quanHeVoiDaiDien;
  final NguoiThueHD? nguoiThue;

  const ThanhVienHopDongDTO({
    required this.idnt,
    required this.laDaiDien,
    this.quanHeVoiDaiDien,
    this.id,
    this.hopDongId,
    this.nguoiThue,
  });

  factory ThanhVienHopDongDTO.fromMap(Map<String, dynamic> json) {
    return ThanhVienHopDongDTO(
      id: json['id'] as int?,
      hopDongId: json['hopDongId'] as String?,
      idnt: json['idnt'] ?? 0,
      laDaiDien: json['laDaiDien'] ?? false,
      quanHeVoiDaiDien: json['quanHeVoiDaiDien'] as String?,
      nguoiThue: json['nguoithue'] != null
          ? NguoiThueHD.fromMap(json['nguoithue'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (hopDongId != null) 'hopDongId': hopDongId,
    'idnt': idnt,
    'laDaiDien': laDaiDien,
    'quanHeVoiDaiDien': quanHeVoiDaiDien,
  };
}