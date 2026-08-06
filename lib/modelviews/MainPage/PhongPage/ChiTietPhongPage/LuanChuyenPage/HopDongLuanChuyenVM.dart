import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';

class HopDongLuanChuyenVM {
  final String? maHopDong;
  final String? tenNguoiDaiDien;
  final int? soThanhVien;
  final List<String>? dsThanhVien;
  final List<PhongHopDongVM>? dsPhongHopDong;
  final String? phongCuText;
  final int? phongMoiId;
  final String? phongMoiText;
  final int? sucChua;
  final int? soNguoiDangO;
  final int? soChoTrong;
  final String? trangThaiText;

  HopDongLuanChuyenVM({
    this.maHopDong,
    this.tenNguoiDaiDien,
    this.soThanhVien,
    this.dsThanhVien,
    this.dsPhongHopDong,
    this.phongCuText,
    this.phongMoiId,
    this.phongMoiText,
    this.sucChua,
    this.soNguoiDangO,
    this.soChoTrong,
    this.trangThaiText,
  });

  factory HopDongLuanChuyenVM.fromMap(Map<String, dynamic> map) {
    return HopDongLuanChuyenVM(
      maHopDong: (map['maHopDong'] ?? map['hopDongId']) as String?,
      tenNguoiDaiDien: map['tenNguoiDaiDien'] as String?,
      soThanhVien: map['soThanhVien'] as int?,
      dsThanhVien: map['dsThanhVien'] != null
          ? List<String>.from(map['dsThanhVien'] as List)
          : null,
      dsPhongHopDong: map['dsPhongHopDong'] != null
          ? (map['dsPhongHopDong'] as List)
                .map((e) => PhongHopDongVM.fromMap(e as Map<String, dynamic>))
                .toList()
          : null,
      phongCuText: map['phongCuText'] as String?,
      phongMoiId: map['phongMoiId'] as int?,
      phongMoiText: map['phongMoiText'] as String?,
      sucChua: map['sucChua'] as int?,
      soNguoiDangO: map['soNguoiDangO'] as int?,
      soChoTrong: map['soChoTrong'] as int?,
      trangThaiText: map['trangThaiText'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maHopDong': maHopDong,
      'tenNguoiDaiDien': tenNguoiDaiDien,
      'soThanhVien': soThanhVien,
      'dsThanhVien': dsThanhVien,
      'dsPhongHopDong': dsPhongHopDong?.map((e) => e.toMap()).toList(),
      'phongCuText': phongCuText,
      'phongMoiId': phongMoiId,
      'phongMoiText': phongMoiText,
      'sucChua': sucChua,
      'soNguoiDangO': soNguoiDangO,
      'soChoTrong': soChoTrong,
      'trangThaiText': trangThaiText,
    };
  }

  HopDongLuanChuyenVM copyWith({
    String? maHopDong,
    String? tenNguoiDaiDien,
    int? soThanhVien,
    List<String>? dsThanhVien,
    List<PhongHopDongVM>? dsPhongHopDong,
    String? phongCuText,
    int? phongMoiId,
    String? phongMoiText,
    int? sucChua,
    int? soNguoiDangO,
    int? soChoTrong,
    String? trangThaiText,
  }) {
    return HopDongLuanChuyenVM(
      maHopDong: maHopDong ?? this.maHopDong,
      tenNguoiDaiDien: tenNguoiDaiDien ?? this.tenNguoiDaiDien,
      soThanhVien: soThanhVien ?? this.soThanhVien,
      dsThanhVien: dsThanhVien ?? this.dsThanhVien,
      dsPhongHopDong: dsPhongHopDong ?? this.dsPhongHopDong,
      phongCuText: phongCuText ?? this.phongCuText,
      phongMoiId: phongMoiId ?? this.phongMoiId,
      phongMoiText: phongMoiText ?? this.phongMoiText,
      sucChua: sucChua ?? this.sucChua,
      soNguoiDangO: soNguoiDangO ?? this.soNguoiDangO,
      soChoTrong: soChoTrong ?? this.soChoTrong,
      trangThaiText: trangThaiText ?? this.trangThaiText,
    );
  }

  bool get coNhieuHopDong => (dsPhongHopDong?.length ?? 0) > 1;

  bool laPhongHopDong(int phongId) =>
      dsPhongHopDong?.any((e) => e.phongId == phongId) ?? false;

  @override
  String toString() {
    return 'HopDongLuanChuyenVM(maHopDong: $maHopDong, '
        'tenNguoiDaiDien: $tenNguoiDaiDien, soThanhVien: $soThanhVien, '
        'dsThanhVien: $dsThanhVien, dsPhongHopDong: $dsPhongHopDong, '
        'phongCuText: $phongCuText, phongMoiId: $phongMoiId, '
        'phongMoiText: $phongMoiText, sucChua: $sucChua, '
        'soNguoiDangO: $soNguoiDangO, soChoTrong: $soChoTrong, '
        'trangThaiText: $trangThaiText)';
  }
}
