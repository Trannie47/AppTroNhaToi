import 'ThanhVienHopDongDTO.dart';

class HopDongDTO {
  final String hopDongID;
  final int phongID;
  final DateTime ngayKy;
  final DateTime ngayHetHan;
  final double tienCoc;
  final double giaPhongThucTe;
  final int
  trangThai; //0: hợp đồng khởi tạo(chưa tới ngày hiệu lực), 1: HD hiệu lực, 2: hết hiệu lực
  final PhongHD phong;
  final String? ghiChu;
  final List<String> dsAnhHopDong;
  final List<ThanhVienHopDongDTO> hopDongNguoiThue;
  HopDongDTO({
    required this.hopDongID,
    required this.phongID,
    required this.ngayKy,
    required this.ngayHetHan,
    required this.tienCoc,
    required this.giaPhongThucTe,
    this.ghiChu,
    required this.trangThai,
    required this.phong,
    required this.dsAnhHopDong,
    required this.hopDongNguoiThue,
  });
  ThanhVienHopDongDTO? get daiDienChinh {
    try {
      return hopDongNguoiThue.firstWhere((tv) => tv.laDaiDien);
    } catch (_) {
      return hopDongNguoiThue.isNotEmpty ? hopDongNguoiThue.first : null;
    }
  }

  int get idnt => daiDienChinh?.idnt ?? 0;
  NguoiThueHD get nguoithue =>
      daiDienChinh?.nguoiThue ??
      NguoiThueHD(hoTen: 'Không rõ', soDienThoai: 'Không rõ');
  factory HopDongDTO.fromMap(Map<String, dynamic> json) {
    return HopDongDTO(
      hopDongID: json['hopDongId'] ?? '',
      phongID: json['phongId'] ?? 0,
      ngayKy: DateTime.parse(json['ngayKy']),
      ngayHetHan: DateTime.parse(json['ngayHetHan']),
      tienCoc: json['tienCoc'] is num
          ? (json['tienCoc'] as num).toDouble()
          : double.tryParse(json['tienCoc']?.toString() ?? '') ?? 0.0,
      giaPhongThucTe: json['giaPhongThucTe'] is num
          ? (json['giaPhongThucTe'] as num).toDouble()
          : double.tryParse(json['giaPhongThucTe']?.toString() ?? '') ?? 0.0,
      ghiChu: json['ghiChu'] as String?,
      trangThai: json['trangThai'] ?? 0,
      dsAnhHopDong: json['anhHopDong'] is List
          ? List<String>.from(json['anhHopDong'])
          : (json['anhHopDong'] != null ? [json['anhHopDong'].toString()] : []),
      phong: PhongHD.fromMap(json['phong'] ?? {}),
      hopDongNguoiThue: json['hopDongNguoiThue'] is List
          ? (json['hopDongNguoiThue'] as List)
                .map(
                  (item) =>
                      ThanhVienHopDongDTO.fromMap(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
  @override
  String toString() {
    return 'HopDongDTO(hopDongID: $hopDongID, phongID: $phongID, ngayKy: $ngayKy, ngayHetHan: $ngayHetHan, tienCoc: $tienCoc, giaPhongThucTe: $giaPhongThucTe, trangThai: $trangThai, phong: ${phong.tenPhong}, ghiChu: $ghiChu, nguoithue: ${nguoithue.hoTen}, dsAnhHopDong: $dsAnhHopDong giaGocCuaPhong: ${phong.giaPhongGoc})';
  }
}

class PhongHD {
  final String tenPhong;
  final double
  giaPhongGoc; // dùng ddeer hiển thị giá gốc của phòng đó lên form Update Hợp đồng
  PhongHD({required this.tenPhong, required this.giaPhongGoc});
  factory PhongHD.fromMap(Map<String, dynamic> json) {
    final loaiPhongMap = json['loaiPhong'] as Map<String, dynamic>?;
    // Parse giá tiền từ chuỗi
    final giaRaw = loaiPhongMap?['giaTien'];
    double giaParsed = 0.0;
    if (giaRaw is num) {
      giaParsed = giaRaw.toDouble();
    } else if (giaRaw is String) {
      giaParsed = double.tryParse(giaRaw) ?? 0.0;
    }
    return PhongHD(
      tenPhong: json['tenPhong'] ?? 'Không rõ',
      giaPhongGoc: giaParsed,
    );
  }
}

class NguoiThueHD {
  final String hoTen;
  final String soDienThoai;
  NguoiThueHD({required this.hoTen, required this.soDienThoai});
  factory NguoiThueHD.fromMap(Map<String, dynamic> json) => NguoiThueHD(
    hoTen: json['hoTen'] ?? 'Không rõ',
    soDienThoai: json['sdt']?.toString() ?? 'Không rõ',
  );
}
