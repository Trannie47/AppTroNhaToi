class HoaDonTapHoa {
  final int? maHoaDon;
  final int? idnt; // FK -> nguoithue.IDNT
  final DateTime? ngayBan;
  final double? tongTien;

  HoaDonTapHoa({this.maHoaDon, this.idnt, this.ngayBan, this.tongTien});

  factory HoaDonTapHoa.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoa(
      maHoaDon: map['maHoaDon'] as int?,
      idnt: map['IDNT'] as int?,
      ngayBan: map['ngayBan'] != null
          ? DateTime.tryParse(map['ngayBan'] as String)
          : null,
      tongTien: (map['tongTien'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (maHoaDon != null) 'maHoaDon': maHoaDon,
      'IDNT': idnt,
      'ngayBan': ngayBan?.toIso8601String().split('T').first,
      'tongTien': tongTien,
    };
  }

  HoaDonTapHoa copyWith({
    int? maHoaDon,
    int? idnt,
    DateTime? ngayBan,
    double? tongTien,
  }) {
    return HoaDonTapHoa(
      maHoaDon: maHoaDon ?? this.maHoaDon,
      idnt: idnt ?? this.idnt,
      ngayBan: ngayBan ?? this.ngayBan,
      tongTien: tongTien ?? this.tongTien,
    );
  }

  @override
  String toString() {
    return 'HoaDonTapHoa(maHoaDon: $maHoaDon, idnt: $idnt, '
        'ngayBan: $ngayBan, tongTien: $tongTien)';
  }
}
