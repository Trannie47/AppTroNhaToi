import 'package:AppTroNhaToi/core/utils/model_formatter.dart';

class ThuCongNoDTO {
  final int? idnt;
  final double soTien;
  final DateTime? ngayThu;

  ThuCongNoDTO({this.idnt, required this.soTien, this.ngayThu});

  factory ThuCongNoDTO.fromMap(Map<String, dynamic> map) {
    return ThuCongNoDTO(
      idnt: intOf(map['idnt']),
      soTien: numOf(map['soTien']),
      ngayThu: dateOf(map['ngayThu']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idnt != null) 'idnt': idnt,
      'soTien': soTien,
      'ngayThu': ngayThu?.toIso8601String().split('T').first,
    };
  }

  ThuCongNoDTO copyWith({int? idnt, double? soTien, DateTime? ngayThu}) {
    return ThuCongNoDTO(
      idnt: idnt ?? this.idnt,
      soTien: soTien ?? this.soTien,
      ngayThu: ngayThu ?? this.ngayThu,
    );
  }

  @override
  String toString() {
    return 'ThuCongNoDTO('
        'idnt: $idnt, '
        'soTien: $soTien, '
        'ngayThu: $ngayThu'
        ')';
  }
}
