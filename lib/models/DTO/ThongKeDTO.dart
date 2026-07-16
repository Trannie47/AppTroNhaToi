class ThongKeDTO {
  final DoanhThuThongKe doanhThu;
  final DaThuThongKe daThu;
  final CongNoThongKe congNo;
  final ChiPhiThongKe chiPhi;
  final PhongThongKe phong;
  final NguoiThueThongKe nguoiThue;
  final ThietBiThongKe thietBi;
  final List<ChartDoanhThu> chart;
  final List<dynamic> hopDongSapHet;

  ThongKeDTO({
    required this.doanhThu,
    required this.daThu,
    required this.congNo,
    required this.chiPhi,
    required this.phong,
    required this.nguoiThue,
    required this.thietBi,
    required this.chart,
    required this.hopDongSapHet,
  });

  factory ThongKeDTO.fromMap(Map<String, dynamic> map) {
    return ThongKeDTO(
      doanhThu: DoanhThuThongKe.fromMap(map['doanhThu']),
      daThu: DaThuThongKe.fromMap(map['daThu']),
      congNo: CongNoThongKe.fromMap(map['congNo']),
      chiPhi: ChiPhiThongKe.fromMap(map['chiPhi']),
      phong: PhongThongKe.fromMap(map['phong']),
      nguoiThue: NguoiThueThongKe.fromMap(map['nguoiThue']),
      thietBi: ThietBiThongKe.fromMap(map['thietBi']),
      chart: (map['chart'] as List<dynamic>)
          .map((e) => ChartDoanhThu.fromMap(e))
          .toList(),
      hopDongSapHet: List<dynamic>.from(map['hopDongSapHet'] ?? []),
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
      'hopDongSapHet': hopDongSapHet,
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
    List<ChartDoanhThu>? chart,
    List<dynamic>? hopDongSapHet,
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
      doanhThuPhong: (map['doanhThuPhong'] as num).toDouble(),
      doanhThuGuiXe: (map['doanhThuGuiXe'] as num).toDouble(),
      doanhThuTapHoa: (map['doanhThuTapHoa'] as num).toDouble(),
      tongDoanhThu: (map['tongDoanhThu'] as num).toDouble(),
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
  final double tongDaThu;

  DaThuThongKe({
    required this.daThuPhong,
    required this.daThuTapHoa,
    required this.tongDaThu,
  });

  factory DaThuThongKe.fromMap(Map<String, dynamic> map) {
    return DaThuThongKe(
      daThuPhong: (map['daThuPhong'] as num).toDouble(),
      daThuTapHoa: (map['daThuTapHoa'] as num).toDouble(),
      tongDaThu: (map['tongDaThu'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'daThuPhong': daThuPhong,
    'daThuTapHoa': daThuTapHoa,
    'tongDaThu': tongDaThu,
  };
}

class CongNoThongKe {
  final double tongCongNo;

  CongNoThongKe({required this.tongCongNo});

  factory CongNoThongKe.fromMap(Map<String, dynamic> map) {
    return CongNoThongKe(tongCongNo: (map['tongCongNo'] as num).toDouble());
  }

  Map<String, dynamic> toMap() => {'tongCongNo': tongCongNo};
}

class ChiPhiThongKe {
  final double tongChiPhi;

  ChiPhiThongKe({required this.tongChiPhi});

  factory ChiPhiThongKe.fromMap(Map<String, dynamic> map) {
    return ChiPhiThongKe(tongChiPhi: (map['tongChiPhi'] as num).toDouble());
  }

  Map<String, dynamic> toMap() => {'tongChiPhi': tongChiPhi};
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
      tongPhong: map['tongPhong'],
      phongDangThue: map['phongDangThue'],
      phongTrong: map['phongTrong'],
      tiLeLapDay: (map['tiLeLapDay'] as num).toDouble(),
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
      tongNguoiThue: map['tongNguoiThue'],
      nguoiDangThue: map['nguoiDangThue'],
      nguoiDaDonDi: map['nguoiDaDonDi'],
      hopDongSapHet: map['hopDongSapHet'],
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
      tongThietBi: map['tongThietBi'],
      thietBiHoatDong: map['thietBiHoatDong'],
      thietBiDangSua: map['thietBiDangSua'],
      thietBiHong: map['thietBiHong'],
      tongLapRap: map['tongLapRap'],
      tongSuaChua: map['tongSuaChua'],
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

class ChartDoanhThu {
  final int thang;
  final double doanhThu;

  ChartDoanhThu({required this.thang, required this.doanhThu});

  factory ChartDoanhThu.fromMap(Map<String, dynamic> map) {
    return ChartDoanhThu(
      thang: map['thang'],
      doanhThu: (map['doanhThu'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {'thang': thang, 'doanhThu': doanhThu};
}
