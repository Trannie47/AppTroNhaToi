import 'package:AppTroNhaToi/core/utils/model_formatter.dart';

class ThongKeDTO {
  final DoanhThuThongKe doanhThu;
  final DaThuThongKe daThu;
  final CongNoThongKe congNo;
  final ChiPhiThongKe chiPhi;
  final PhongThongKe phong;
  final NguoiThueThongKe nguoiThue;
  final ThietBiThongKe thietBi;
  final List<ChartDoanhThuModel> chart;
  final List<TopPhongModel> topPhong;
  final List<TopCongNoModel> topCongNo;
  final List<TopCongNoModel> topCongNoHoaDonPhong;
  final List<TopCongNoDienNuocModel> topCongNoDienNuoc;
  final List<TopCongNoPhuongTienModel> topCongNoPhuongTien;
  final List<TopHangHoaModel> topHangHoa;
  final List<TopThietBiSuaModel> topThietBiSua;
  final List<HopDongSapHetModel> hopDongSapHet;

  ThongKeDTO({
    required this.doanhThu,
    required this.daThu,
    required this.congNo,
    required this.chiPhi,
    required this.phong,
    required this.nguoiThue,
    required this.thietBi,
    required this.chart,
    required this.topPhong,
    required this.topCongNo,
    required this.topCongNoHoaDonPhong,
    required this.topCongNoDienNuoc,
    required this.topCongNoPhuongTien,
    required this.topHangHoa,
    required this.topThietBiSua,
    required this.hopDongSapHet,
  });

  factory ThongKeDTO.fromMap(Map<String, dynamic> map) {
    return ThongKeDTO(
      doanhThu: DoanhThuThongKe.fromMap(map['doanhThu'] ?? const {}),
      daThu: DaThuThongKe.fromMap(map['daThu'] ?? const {}),
      congNo: CongNoThongKe.fromMap(map['congNo'] ?? const {}),
      chiPhi: ChiPhiThongKe.fromMap(map['chiPhi'] ?? const {}),
      phong: PhongThongKe.fromMap(map['phong'] ?? const {}),
      nguoiThue: NguoiThueThongKe.fromMap(map['nguoiThue'] ?? const {}),
      thietBi: ThietBiThongKe.fromMap(map['thietBi'] ?? const {}),
      chart: ((map['chart'] as List?) ?? [])
          .map((e) => ChartDoanhThuModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topPhong: ((map['topPhong'] as List?) ?? [])
          .map((e) => TopPhongModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topCongNo: ((map['topCongNo'] as List?) ?? [])
          .map((e) => TopCongNoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topCongNoHoaDonPhong: ((map['topCongNoHoaDonPhong'] as List?) ?? [])
          .map((e) => TopCongNoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topCongNoDienNuoc: ((map['topCongNoDienNuoc'] as List?) ?? [])
          .map((e) => TopCongNoDienNuocModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topCongNoPhuongTien: ((map['topCongNoPhuongTien'] as List?) ?? [])
          .map(
            (e) => TopCongNoPhuongTienModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
      topHangHoa: ((map['topHangHoa'] as List?) ?? [])
          .map((e) => TopHangHoaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      topThietBiSua: ((map['topThietBiSua'] as List?) ?? [])
          .map((e) => TopThietBiSuaModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      hopDongSapHet: ((map['hopDongSapHet'] as List?) ?? [])
          .map((e) => HopDongSapHetModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doanhThu': doanhThu.toMap(),
      'daThu': daThu.toMap(),
      'congNo': congNo.toMap(),
      'chiPhi': chiPhi.toMap(),
      'phong': phong.toMap(),
      'nguoiThue': nguoiThue.toMap(),
      'thietBi': thietBi.toMap(),
      'chart': chart.map((e) => e.toMap()).toList(),
      'topPhong': topPhong.map((e) => e.toMap()).toList(),
      'topCongNo': topCongNo.map((e) => e.toMap()).toList(),
      'topCongNoHoaDonPhong': topCongNoHoaDonPhong
          .map((e) => e.toMap())
          .toList(),
      'topCongNoDienNuoc': topCongNoDienNuoc.map((e) => e.toMap()).toList(),
      'topCongNoPhuongTien': topCongNoPhuongTien.map((e) => e.toMap()).toList(),
      'topHangHoa': topHangHoa.map((e) => e.toMap()).toList(),
      'topThietBiSua': topThietBiSua.map((e) => e.toMap()).toList(),
      'hopDongSapHet': hopDongSapHet.map((e) => e.toMap()).toList(),
    };
  }

  ThongKeDTO copyWith({
    DoanhThuThongKe? doanhThu,
    DaThuThongKe? daThu,
    CongNoThongKe? congNo,
    ChiPhiThongKe? chiPhi,
    PhongThongKe? phong,
    NguoiThueThongKe? nguoiThue,
    ThietBiThongKe? thietBi,
    List<ChartDoanhThuModel>? chart,
    List<TopPhongModel>? topPhong,
    List<TopCongNoModel>? topCongNo,
    List<TopCongNoModel>? topCongNoHoaDonPhong,
    List<TopCongNoDienNuocModel>? topCongNoDienNuoc,
    List<TopCongNoPhuongTienModel>? topCongNoPhuongTien,
    List<TopHangHoaModel>? topHangHoa,
    List<TopThietBiSuaModel>? topThietBiSua,
    List<HopDongSapHetModel>? hopDongSapHet,
  }) {
    return ThongKeDTO(
      doanhThu: doanhThu ?? this.doanhThu,
      daThu: daThu ?? this.daThu,
      congNo: congNo ?? this.congNo,
      chiPhi: chiPhi ?? this.chiPhi,
      phong: phong ?? this.phong,
      nguoiThue: nguoiThue ?? this.nguoiThue,
      thietBi: thietBi ?? this.thietBi,
      chart: chart ?? this.chart,
      topPhong: topPhong ?? this.topPhong,
      topCongNo: topCongNo ?? this.topCongNo,
      topCongNoHoaDonPhong: topCongNoHoaDonPhong ?? this.topCongNoHoaDonPhong,
      topCongNoDienNuoc: topCongNoDienNuoc ?? this.topCongNoDienNuoc,
      topCongNoPhuongTien: topCongNoPhuongTien ?? this.topCongNoPhuongTien,
      topHangHoa: topHangHoa ?? this.topHangHoa,
      topThietBiSua: topThietBiSua ?? this.topThietBiSua,
      hopDongSapHet: hopDongSapHet ?? this.hopDongSapHet,
    );
  }
}

class DoanhThuThongKe {
  final double doanhThuPhong;
  final double doanhThuGuiXe;
  final double doanhThuTapHoa;
  final double tongDoanhThu;

  DoanhThuThongKe({
    required this.doanhThuPhong,
    required this.doanhThuGuiXe,
    required this.doanhThuTapHoa,
    required this.tongDoanhThu,
  });

  factory DoanhThuThongKe.fromMap(Map<String, dynamic> map) {
    return DoanhThuThongKe(
      doanhThuPhong: numOf(map['doanhThuPhong']),
      doanhThuGuiXe: numOf(map['doanhThuGuiXe']),
      doanhThuTapHoa: numOf(map['doanhThuTapHoa']),
      tongDoanhThu: numOf(map['tongDoanhThu']),
    );
  }

  Map<String, dynamic> toMap() => {
    'doanhThuPhong': doanhThuPhong,
    'doanhThuGuiXe': doanhThuGuiXe,
    'doanhThuTapHoa': doanhThuTapHoa,
    'tongDoanhThu': tongDoanhThu,
  };
}

class DaThuThongKe {
  final double daThuPhong;
  final double daThuTapHoa;
  final double daThuGuiXe;
  final double tongDaThu;

  DaThuThongKe({
    required this.daThuPhong,
    required this.daThuTapHoa,
    required this.daThuGuiXe,
    required this.tongDaThu,
  });

  factory DaThuThongKe.fromMap(Map<String, dynamic> map) {
    return DaThuThongKe(
      daThuPhong: numOf(map['daThuPhong']),
      daThuTapHoa: numOf(map['daThuTapHoa']),
      daThuGuiXe: numOf(map['daThuGuiXe']),
      tongDaThu: numOf(map['tongDaThu']),
    );
  }

  Map<String, dynamic> toMap() => {
    'daThuPhong': daThuPhong,
    'daThuTapHoa': daThuTapHoa,
    'daThuGuiXe': daThuGuiXe,
    'tongDaThu': tongDaThu,
  };
}

class CongNoThongKe {
  final double tongCongNo;

  CongNoThongKe({required this.tongCongNo});

  factory CongNoThongKe.fromMap(Map<String, dynamic> map) {
    return CongNoThongKe(tongCongNo: numOf(map['tongCongNo']));
  }

  Map<String, dynamic> toMap() => {'tongCongNo': tongCongNo};
}

class ChiPhiThongKe {
  final double tongChiPhi;
  final double tongTienSuaChua;
  final double tongTienMuaThietBi;
  final double tongTienLuanChuyen;

  const ChiPhiThongKe({
    required this.tongChiPhi,
    required this.tongTienSuaChua,
    required this.tongTienMuaThietBi,
    required this.tongTienLuanChuyen,
  });

  factory ChiPhiThongKe.fromMap(Map<String, dynamic> map) {
    return ChiPhiThongKe(
      tongChiPhi: numOf(map['tongChiPhi']),
      tongTienSuaChua: numOf(map['tongTienSuaChua']),
      tongTienMuaThietBi: numOf(map['tongTienMuaThietBi']),
      tongTienLuanChuyen: numOf(map['tongTienLuanChuyen']),
    );
  }

  Map<String, dynamic> toMap() => {
    'tongChiPhi': tongChiPhi,
    'tongTienSuaChua': tongTienSuaChua,
    'tongTienMuaThietBi': tongTienMuaThietBi,
    'tongTienLuanChuyen': tongTienLuanChuyen,
  };

  ChiPhiThongKe copyWith({
    double? tongChiPhi,
    double? tongTienSuaChua,
    double? tongTienMuaThietBi,
    double? tongTienLuanChuyen,
  }) {
    return ChiPhiThongKe(
      tongChiPhi: tongChiPhi ?? this.tongChiPhi,
      tongTienSuaChua: tongTienSuaChua ?? this.tongTienSuaChua,
      tongTienMuaThietBi: tongTienMuaThietBi ?? this.tongTienMuaThietBi,
      tongTienLuanChuyen: tongTienLuanChuyen ?? this.tongTienLuanChuyen,
    );
  }

  /// Tỷ lệ (0 -> 1)
  double get tyLeSuaChua => tongChiPhi == 0 ? 0 : tongTienSuaChua / tongChiPhi;

  double get tyLeMuaThietBi =>
      tongChiPhi == 0 ? 0 : tongTienMuaThietBi / tongChiPhi;

  double get tyLeLuanChuyen =>
      tongChiPhi == 0 ? 0 : tongTienLuanChuyen / tongChiPhi;

  /// Phần trăm (0 -> 100)
  double get phanTramSuaChua => tyLeSuaChua * 100;

  double get phanTramMuaThietBi => tyLeMuaThietBi * 100;

  double get phanTramLuanChuyen => tyLeLuanChuyen * 100;
}

class PhongThongKe {
  final int tongPhong;
  final int phongDangThue;
  final int phongTrong;
  final double tiLeLapDay;

  PhongThongKe({
    required this.tongPhong,
    required this.phongDangThue,
    required this.phongTrong,
    required this.tiLeLapDay,
  });

  factory PhongThongKe.fromMap(Map<String, dynamic> map) {
    return PhongThongKe(
      tongPhong: intOf(map['tongPhong']),
      phongDangThue: intOf(map['phongDangThue']),
      phongTrong: intOf(map['phongTrong']),
      tiLeLapDay: numOf(map['tiLeLapDay']),
    );
  }

  Map<String, dynamic> toMap() => {
    'tongPhong': tongPhong,
    'phongDangThue': phongDangThue,
    'phongTrong': phongTrong,
    'tiLeLapDay': tiLeLapDay,
  };
}

class NguoiThueThongKe {
  final int tongNguoiThue;
  final int nguoiDangThue;
  final int nguoiDaDonDi;
  final int hopDongSapHet;

  NguoiThueThongKe({
    required this.tongNguoiThue,
    required this.nguoiDangThue,
    required this.nguoiDaDonDi,
    required this.hopDongSapHet,
  });

  factory NguoiThueThongKe.fromMap(Map<String, dynamic> map) {
    return NguoiThueThongKe(
      tongNguoiThue: intOf(map['tongNguoiThue']),
      nguoiDangThue: intOf(map['nguoiDangThue']),
      nguoiDaDonDi: intOf(map['nguoiDaDonDi']),
      hopDongSapHet: intOf(map['hopDongSapHet']),
    );
  }

  Map<String, dynamic> toMap() => {
    'tongNguoiThue': tongNguoiThue,
    'nguoiDangThue': nguoiDangThue,
    'nguoiDaDonDi': nguoiDaDonDi,
    'hopDongSapHet': hopDongSapHet,
  };
}

class ThietBiThongKe {
  final int tongThietBi;
  final int thietBiHoatDong;
  final int thietBiDangSua;
  final int thietBiHong;
  final int tongLapRap;
  final int tongSuaChua;

  ThietBiThongKe({
    required this.tongThietBi,
    required this.thietBiHoatDong,
    required this.thietBiDangSua,
    required this.thietBiHong,
    required this.tongLapRap,
    required this.tongSuaChua,
  });

  factory ThietBiThongKe.fromMap(Map<String, dynamic> map) {
    return ThietBiThongKe(
      tongThietBi: intOf(map['tongThietBi']),
      thietBiHoatDong: intOf(map['thietBiHoatDong']),
      thietBiDangSua: intOf(map['thietBiDangSua']),
      thietBiHong: intOf(map['thietBiHong']),
      tongLapRap: intOf(map['tongLapRap']),
      tongSuaChua: intOf(map['tongSuaChua']),
    );
  }

  Map<String, dynamic> toMap() => {
    'tongThietBi': tongThietBi,
    'thietBiHoatDong': thietBiHoatDong,
    'thietBiDangSua': thietBiDangSua,
    'thietBiHong': thietBiHong,
    'tongLapRap': tongLapRap,
    'tongSuaChua': tongSuaChua,
  };
}

/// ==========================================
/// CHART DOANH THU (12 THÁNG)
/// ==========================================
class ChartDoanhThuModel {
  final int thang;
  final double doanhThu;

  ChartDoanhThuModel({required this.thang, required this.doanhThu});

  factory ChartDoanhThuModel.fromMap(Map<String, dynamic> map) {
    return ChartDoanhThuModel(
      thang: intOf(map['thang']),
      doanhThu: numOf(map['doanhThu']),
    );
  }

  Map<String, dynamic> toMap() => {'thang': thang, 'doanhThu': doanhThu};

  ChartDoanhThuModel copyWith({int? thang, double? doanhThu}) {
    return ChartDoanhThuModel(
      thang: thang ?? this.thang,
      doanhThu: doanhThu ?? this.doanhThu,
    );
  }
}

/// ==========================================
/// TOP PHÒNG DOANH THU CAO
/// ==========================================
class TopPhongModel {
  final int phongId;
  final String? tenPhong;
  final double tongDoanhThu;
  final double tongDaThu;
  final double tongCongNo;

  TopPhongModel({
    required this.phongId,
    required this.tenPhong,
    required this.tongDoanhThu,
    required this.tongDaThu,
    required this.tongCongNo,
  });

  factory TopPhongModel.fromMap(Map<String, dynamic> map) {
    return TopPhongModel(
      phongId: intOf(map['phongId']),
      tenPhong: strOf(map['tenPhong']),
      tongDoanhThu: numOf(map['tongDoanhThu']),
      tongDaThu: numOf(map['tongDaThu']),
      tongCongNo: numOf(map['tongCongNo']),
    );
  }

  Map<String, dynamic> toMap() => {
    'phongId': phongId,
    'tenPhong': tenPhong,
    'tongDoanhThu': tongDoanhThu,
    'tongDaThu': tongDaThu,
    'tongCongNo': tongCongNo,
  };

  TopPhongModel copyWith({
    int? phongId,
    String? tenPhong,
    double? tongDoanhThu,
    double? tongDaThu,
    double? tongCongNo,
  }) {
    return TopPhongModel(
      phongId: phongId ?? this.phongId,
      tenPhong: tenPhong ?? this.tenPhong,
      tongDoanhThu: tongDoanhThu ?? this.tongDoanhThu,
      tongDaThu: tongDaThu ?? this.tongDaThu,
      tongCongNo: tongCongNo ?? this.tongCongNo,
    );
  }
}

/// ==========================================
/// TOP NGƯỜI THUÊ CÒN NỢ (tổng hợp, theo người)
/// Dùng chung cho "topCongNo" (tổng) và "topCongNoHoaDonPhong"
/// (nợ riêng phần hóa đơn phòng) vì 2 API trả cùng shape theo idnt.
/// ==========================================
class TopCongNoModel {
  final int idnt;
  final String? hoTen;
  final double tongTien;
  final double tongDaThu;
  final double tongCongNo;

  TopCongNoModel({
    required this.idnt,
    required this.hoTen,
    required this.tongTien,
    required this.tongDaThu,
    required this.tongCongNo,
  });

  factory TopCongNoModel.fromMap(Map<String, dynamic> map) {
    return TopCongNoModel(
      idnt: intOf(map['idnt']),
      hoTen: strOf(map['hoTen']),
      tongTien: numOf(map['tongTien']),
      tongDaThu: numOf(map['tongDaThu']),
      tongCongNo: numOf(map['tongCongNo']),
    );
  }

  Map<String, dynamic> toMap() => {
    'idnt': idnt,
    'hoTen': hoTen,
    'tongTien': tongTien,
    'tongDaThu': tongDaThu,
    'tongCongNo': tongCongNo,
  };

  TopCongNoModel copyWith({
    int? idnt,
    String? hoTen,
    double? tongTien,
    double? tongDaThu,
    double? tongCongNo,
  }) {
    return TopCongNoModel(
      idnt: idnt ?? this.idnt,
      hoTen: hoTen ?? this.hoTen,
      tongTien: tongTien ?? this.tongTien,
      tongDaThu: tongDaThu ?? this.tongDaThu,
      tongCongNo: tongCongNo ?? this.tongCongNo,
    );
  }
}

/// ==========================================
/// TOP CÔNG NỢ ĐIỆN NƯỚC (theo phòng)
/// ==========================================
class TopCongNoDienNuocModel {
  final int phongId;
  final String? tenPhong;
  final double tongTien;
  final double tongDaThu;
  final double tongCongNo;

  TopCongNoDienNuocModel({
    required this.phongId,
    required this.tenPhong,
    required this.tongTien,
    required this.tongDaThu,
    required this.tongCongNo,
  });

  factory TopCongNoDienNuocModel.fromMap(Map<String, dynamic> map) {
    return TopCongNoDienNuocModel(
      phongId: intOf(map['phongId']),
      tenPhong: strOf(map['tenPhong']),
      tongTien: numOf(map['tongTien']),
      tongDaThu: numOf(map['tongDaThu']),
      tongCongNo: numOf(map['tongCongNo']),
    );
  }

  Map<String, dynamic> toMap() => {
    'phongId': phongId,
    'tenPhong': tenPhong,
    'tongTien': tongTien,
    'tongDaThu': tongDaThu,
    'tongCongNo': tongCongNo,
  };

  TopCongNoDienNuocModel copyWith({
    int? phongId,
    String? tenPhong,
    double? tongTien,
    double? tongDaThu,
    double? tongCongNo,
  }) {
    return TopCongNoDienNuocModel(
      phongId: phongId ?? this.phongId,
      tenPhong: tenPhong ?? this.tenPhong,
      tongTien: tongTien ?? this.tongTien,
      tongDaThu: tongDaThu ?? this.tongDaThu,
      tongCongNo: tongCongNo ?? this.tongCongNo,
    );
  }
}

/// ==========================================
/// TOP CÔNG NỢ PHƯƠNG TIỆN / GỬI XE (theo phòng)
/// LƯU Ý: mảng ví dụ đang trống nên chưa rõ 100% shape thật.
/// Tạm để giống TopCongNoDienNuocModel (phongId/tenPhong) vì gửi xe
/// cũng gắn theo phòng. Đối chiếu lại backend và sửa field nếu khác.
/// ==========================================
class TopCongNoPhuongTienModel {
  final int phongId;
  final String? tenPhong;
  final double tongTien;
  final double tongDaThu;
  final double tongCongNo;

  TopCongNoPhuongTienModel({
    required this.phongId,
    required this.tenPhong,
    required this.tongTien,
    required this.tongDaThu,
    required this.tongCongNo,
  });

  factory TopCongNoPhuongTienModel.fromMap(Map<String, dynamic> map) {
    return TopCongNoPhuongTienModel(
      phongId: intOf(map['phongId']),
      tenPhong: strOf(map['tenPhong']),
      tongTien: numOf(map['tongTien']),
      tongDaThu: numOf(map['tongDaThu']),
      tongCongNo: numOf(map['tongCongNo']),
    );
  }

  Map<String, dynamic> toMap() => {
    'phongId': phongId,
    'tenPhong': tenPhong,
    'tongTien': tongTien,
    'tongDaThu': tongDaThu,
    'tongCongNo': tongCongNo,
  };

  TopCongNoPhuongTienModel copyWith({
    int? phongId,
    String? tenPhong,
    double? tongTien,
    double? tongDaThu,
    double? tongCongNo,
  }) {
    return TopCongNoPhuongTienModel(
      phongId: phongId ?? this.phongId,
      tenPhong: tenPhong ?? this.tenPhong,
      tongTien: tongTien ?? this.tongTien,
      tongDaThu: tongDaThu ?? this.tongDaThu,
      tongCongNo: tongCongNo ?? this.tongCongNo,
    );
  }
}

/// ==========================================
/// TOP HÀNG HÓA BÁN CHẠY
/// ==========================================
class TopHangHoaModel {
  final int maHangHoa;
  final String? tenHangHoa;
  final String? donViTinh;
  final double tongSoLuong;

  TopHangHoaModel({
    required this.maHangHoa,
    required this.tenHangHoa,
    required this.donViTinh,
    required this.tongSoLuong,
  });

  factory TopHangHoaModel.fromMap(Map<String, dynamic> map) {
    return TopHangHoaModel(
      maHangHoa: intOf(map['maHangHoa']),
      tenHangHoa: strOf(map['tenHangHoa']),
      donViTinh: strOf(map['donViTinh']),
      tongSoLuong: numOf(map['tongSoLuong']),
    );
  }

  Map<String, dynamic> toMap() => {
    'maHangHoa': maHangHoa,
    'tenHangHoa': tenHangHoa,
    'donViTinh': donViTinh,
    'tongSoLuong': tongSoLuong,
  };

  TopHangHoaModel copyWith({
    int? maHangHoa,
    String? tenHangHoa,
    String? donViTinh,
    double? tongSoLuong,
  }) {
    return TopHangHoaModel(
      maHangHoa: maHangHoa ?? this.maHangHoa,
      tenHangHoa: tenHangHoa ?? this.tenHangHoa,
      donViTinh: donViTinh ?? this.donViTinh,
      tongSoLuong: tongSoLuong ?? this.tongSoLuong,
    );
  }
}

/// ==========================================
/// TOP THIẾT BỊ SỬA NHIỀU NHẤT
/// ==========================================
class TopThietBiSuaModel {
  final int thietBiId;
  final String? tenThietBi;
  final String? loai;
  final int soLanSua;

  TopThietBiSuaModel({
    required this.thietBiId,
    required this.tenThietBi,
    required this.loai,
    required this.soLanSua,
  });

  factory TopThietBiSuaModel.fromMap(Map<String, dynamic> map) {
    return TopThietBiSuaModel(
      thietBiId: intOf(map['thietBiId']),
      tenThietBi: strOf(map['tenThietBi']),
      loai: strOf(map['loai']),
      soLanSua: intOf(map['soLanSua']),
    );
  }

  Map<String, dynamic> toMap() => {
    'thietBiId': thietBiId,
    'tenThietBi': tenThietBi,
    'loai': loai,
    'soLanSua': soLanSua,
  };

  TopThietBiSuaModel copyWith({
    int? thietBiId,
    String? tenThietBi,
    String? loai,
    int? soLanSua,
  }) {
    return TopThietBiSuaModel(
      thietBiId: thietBiId ?? this.thietBiId,
      tenThietBi: tenThietBi ?? this.tenThietBi,
      loai: loai ?? this.loai,
      soLanSua: soLanSua ?? this.soLanSua,
    );
  }
}

/// ==========================================
/// PHÒNG (rút gọn, dùng lồng trong HĐ sắp hết hạn)
/// ==========================================
class PhongMiniModel {
  final int phongId;
  final String? tenPhong;

  PhongMiniModel({required this.phongId, required this.tenPhong});

  factory PhongMiniModel.fromMap(Map<String, dynamic> map) {
    return PhongMiniModel(
      phongId: intOf(map['phongId']),
      tenPhong: strOf(map['tenPhong']),
    );
  }

  Map<String, dynamic> toMap() => {'phongId': phongId, 'tenPhong': tenPhong};
}

/// ==========================================
/// NGƯỜI THUÊ (rút gọn, dùng lồng trong HĐ sắp hết hạn)
/// ==========================================
class NguoiThueMiniModel {
  final int idnt;
  final String? hoTen;
  final String? sdt;

  NguoiThueMiniModel({
    required this.idnt,
    required this.hoTen,
    required this.sdt,
  });

  factory NguoiThueMiniModel.fromMap(Map<String, dynamic> map) {
    return NguoiThueMiniModel(
      idnt: intOf(map['idnt']),
      hoTen: strOf(map['hoTen']),
      sdt: strOf(map['sdt']),
    );
  }

  Map<String, dynamic> toMap() => {'idnt': idnt, 'hoTen': hoTen, 'sdt': sdt};
}

/// ==========================================
/// HỢP ĐỒNG SẮP HẾT HẠN
/// LƯU Ý: backend trả nguyên record HopDong (include phong, nguoithue)
/// nên các field gốc của HopDong (idnt, phongId, ngayBatDau, ngayHetHan,
/// trangThai, ...) có thể nhiều/khác so với schema thật của bạn.
/// Hãy đối chiếu lại với model Prisma `HopDong` và bổ sung/sửa field
/// bên dưới cho khớp 100% nếu cần — mình để sẵn `raw` để không mất dữ liệu.
/// ==========================================
class HopDongSapHetModel {
  final int? idnt;
  final int? phongId;
  final DateTime? ngayBatDau;
  final DateTime? ngayHetHan;
  final int? trangThai;
  final PhongMiniModel? phong;
  final NguoiThueMiniModel? nguoithue;

  /// Giữ lại toàn bộ map gốc, phòng khi HopDong có field khác chưa khai báo
  final Map<String, dynamic> raw;

  HopDongSapHetModel({
    required this.idnt,
    required this.phongId,
    required this.ngayBatDau,
    required this.ngayHetHan,
    required this.trangThai,
    required this.phong,
    required this.nguoithue,
    required this.raw,
  });

  factory HopDongSapHetModel.fromMap(Map<String, dynamic> map) {
    return HopDongSapHetModel(
      idnt: map['idnt'] == null ? null : intOf(map['idnt']),
      phongId: map['phongId'] == null ? null : intOf(map['phongId']),
      ngayBatDau: dateOf(map['ngayBatDau']),
      ngayHetHan: dateOf(map['ngayHetHan']),
      trangThai: map['trangThai'] == null ? null : intOf(map['trangThai']),
      phong: map['phong'] == null
          ? null
          : PhongMiniModel.fromMap(map['phong'] as Map<String, dynamic>),
      nguoithue: map['nguoithue'] == null
          ? null
          : NguoiThueMiniModel.fromMap(
              map['nguoithue'] as Map<String, dynamic>,
            ),
      raw: map,
    );
  }

  Map<String, dynamic> toMap() => raw;
}
