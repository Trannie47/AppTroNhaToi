import 'package:AppTroNhaToi/core/utils/model_formatter.dart';

class ThongBao {
  final int? id;
  final String tieuDe;
  final String noiDung;
  final String? loai;
  final String? hopDongId;
  final int? soNgayCon;
  final bool? daDoc;
  final DateTime? taoLuc;

  ThongBao({
    this.id,
    required this.tieuDe,
    required this.noiDung,
    this.loai,
    this.hopDongId,
    this.soNgayCon,
    this.daDoc,
    this.taoLuc,
  });

  factory ThongBao.fromMap(Map<String, dynamic> map) {
    return ThongBao(
      id: map['id'] != null ? intOf(map['id']) : null,
      tieuDe: strOf(map['tieuDe']) ?? '',
      noiDung: strOf(map['noiDung']) ?? '',
      loai: strOf(map['loai']),
      hopDongId: strOf(map['hopDongId']),
      soNgayCon: map['soNgayCon'] != null ? intOf(map['soNgayCon']) : null,
      daDoc: map['daDoc'] as bool?,
      taoLuc: dateOf(map['taoLuc']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'loai': loai,
      'hopDongId': hopDongId,
      'soNgayCon': soNgayCon,
      'daDoc': daDoc,
      'taoLuc': taoLuc?.toIso8601String(),
    };
  }

  ThongBao copyWith({
    int? id,
    String? tieuDe,
    String? noiDung,
    String? loai,
    String? hopDongId,
    int? soNgayCon,
    bool? daDoc,
    DateTime? taoLuc,
  }) {
    return ThongBao(
      id: id ?? this.id,
      tieuDe: tieuDe ?? this.tieuDe,
      noiDung: noiDung ?? this.noiDung,
      loai: loai ?? this.loai,
      hopDongId: hopDongId ?? this.hopDongId,
      soNgayCon: soNgayCon ?? this.soNgayCon,
      daDoc: daDoc ?? this.daDoc,
      taoLuc: taoLuc ?? this.taoLuc,
    );
  }

  @override
  String toString() {
    return 'ThongBao('
        'id: $id, '
        'tieuDe: $tieuDe, '
        'noiDung: $noiDung, '
        'loai: $loai, '
        'hopDongId: $hopDongId, '
        'soNgayCon: $soNgayCon, '
        'daDoc: $daDoc, '
        'taoLuc: $taoLuc'
        ')';
  }
}
