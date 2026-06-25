class HoaDonTapHoa {
  final String? maHoaDon; //13 ký tự 'TH'+YYYYMMDD + STT
  final int? idnt; // FK -> nguoithue.IDNT
  final DateTime? ngayBan;
  final double? tongTien;

  HoaDonTapHoa({this.maHoaDon, this.idnt, this.ngayBan, this.tongTien});

  factory HoaDonTapHoa.fromMap(Map<String, dynamic> map) {
    return HoaDonTapHoa(
      maHoaDon: map['maHoaDon'] as String?,
      idnt: map['tongTien'] != null
          ? .tryParse(map['tongTien'].toString())
          : null,

      ngayBan: map['ngayBan'] != null
          ? DateTime.tryParse(map['ngayBan'] as String)
          : null,
      tongTien: map['tongTien'] != null
          ? double.tryParse(map['tongTien'].toString())
          : null,
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
    String? maHoaDon,
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
