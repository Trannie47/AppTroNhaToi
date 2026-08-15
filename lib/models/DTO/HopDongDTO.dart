import 'NguoiOGhepDTO.dart';

class HopDongDTO {
  final String hopDongID;
  final int phongID;
  final DateTime ngayKy;
  final DateTime ngayHetHan;
  final double tienCoc;
  final double giaPhongThucTe;
  final int
  trangThai; //0: hợp đồng khởi tạo(chưa tới ngày hiệu lực), 1: HD hiệu lực, 2: hết hiệu lực
  final bool? hinhThucO; // false: ở ghép, true: ở một mình
  final PhongHD phong;
  final String? ghiChu;
  final List<String> dsAnhHopDong;
  final int idntDaiDien;
  final NguoiThueHD nguoiDaiDien;
  final List<NguoiOGhepDTO> nguoiOGhep;
  HopDongDTO({
    required this.hopDongID,
    required this.phongID,
    required this.ngayKy,
    required this.ngayHetHan,
    required this.tienCoc,
    required this.giaPhongThucTe,
    this.ghiChu,
    required this.trangThai,
    this.hinhThucO = false,
    required this.phong,
    required this.dsAnhHopDong,
    required this.idntDaiDien,
    required this.nguoiDaiDien,
    required this.nguoiOGhep,
  });

  // Giữ tên cũ để các chỗ hiển thị (danh sách hợp đồng, chi tiết...) không
  // phải đổi tên biến, chỉ đổi nguồn dữ liệu bên trong.
  int get idnt => idntDaiDien;
  NguoiThueHD get nguoithue => nguoiDaiDien;

  // Danh sách người ở ghép còn hiệu lực (đã lọc isDelete)
  List<NguoiOGhepDTO> get nguoiOGhepConHieuLuc =>
      nguoiOGhep.where((ng) => !ng.isDelete).toList();

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
      hinhThucO: json['hinhThucO'] == null
          ? false
          : (json['hinhThucO'] is bool
                ? json['hinhThucO'] as bool
                : (json['hinhThucO'].toString() == 'true' ||
                      json['hinhThucO'].toString() == '1')),
      dsAnhHopDong: json['anhHopDong'] is List
          ? List<String>.from(json['anhHopDong'])
          : (json['anhHopDong'] != null ? [json['anhHopDong'].toString()] : []),
      phong: PhongHD.fromMap(json['phong'] ?? {}),
      idntDaiDien: json['idntDaiDien'] ?? 0,
      nguoiDaiDien: json['nguoiDaiDien'] != null
          ? NguoiThueHD.fromMap(json['nguoiDaiDien'] as Map<String, dynamic>)
          : NguoiThueHD(hoTen: 'Không rõ', soDienThoai: 'Không rõ'),
      nguoiOGhep: json['nguoiOGhep'] is List
          ? (json['nguoiOGhep'] as List)
                .map(
                  (item) => NguoiOGhepDTO.fromMap(item as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
  @override
  String toString() {
    return 'HopDongDTO(hopDongID: $hopDongID, phongID: $phongID, ngayKy: $ngayKy, ngayHetHan: $ngayHetHan, tienCoc: $tienCoc, giaPhongThucTe: $giaPhongThucTe, trangThai: $trangThai, hinhThucO: $hinhThucO, phong: ${phong.tenPhong}, ghiChu: $ghiChu, nguoiDaiDien: ${nguoiDaiDien.hoTen}, dsAnhHopDong: $dsAnhHopDong giaGocCuaPhong: ${phong.giaPhongGoc})';
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
