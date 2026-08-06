import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:flutter/material.dart';

class PhongHopDongVM {
  final int phongId;
  final String tenPhong;
  final int sucChua;
  final int soNguoiDangO;
  final int soChoTrong;
  final bool daCoHopDong;
  final int suCoId;

  const PhongHopDongVM({
    required this.phongId,
    required this.tenPhong,
    required this.sucChua,
    required this.soNguoiDangO,
    required this.soChoTrong,
    required this.daCoHopDong,
    required this.suCoId,
  });
}

class LuanChuyenViewModel extends ChangeNotifier {
  final SuCoProvider _provider;
  final int suCoId;

  LuanChuyenViewModel(
      this._provider,
      this.suCoId,
      ) {
    loadData(suCoId);
  }

  final txtGhiChu = TextEditingController();

  DateTime ngayLuanChuyen = DateTime.now();

  String tenSuCo = "";

  String tenPhong = "";

  String ngayBatDauText = "";

  String trangThaiText = "";

  final List<PhongHopDongVM> dsPhong = [];
  final List<HopDongLuanChuyenVM> dsHopDong = [];

  String get ngayLuanChuyenText {
    final d = ngayLuanChuyen.day.toString().padLeft(2, '0');
    final m = ngayLuanChuyen.month.toString().padLeft(2, '0');
    final y = ngayLuanChuyen.year;

    return "$d/$m/$y";
  }

  void chonPhongMoi(
      int index,
      PhongHopDongVM phong,
      ) {
    dsHopDong[index] = dsHopDong[index].copyWith(
      phongMoiId: phong.phongId,
      phongMoiText: phong.tenPhong,

      sucChua: phong.sucChua,
      soNguoiDangO: phong.soNguoiDangO,
      soChoTrong: phong.soChoTrong,
    );

    notifyListeners();
  }

  Future<void> loadData(int suCoId) async {
    final data = await _provider.getLuanChuyen(suCoId);

    debugPrint("===== DATA =====");
    debugPrint(data.toString());

    if (data.isEmpty) {
      return;
    }

    final suCo = data["suCo"];
    debugPrint("suCo = $suCo");

    final hopDong = data["hopDong"];
    debugPrint("hopDong = ${hopDong.length}");

    final phongChuyen = data["phongChuyen"];
    debugPrint("phong = ${phongChuyen.length}");



    dsPhong.clear();
    dsHopDong.clear();

    for (final p in phongChuyen) {
      dsPhong.add(
          PhongHopDongVM(
            phongId: p["phongId"],
            tenPhong: p["tenPhong"],
            sucChua: p["sucChua"],
            soNguoiDangO: p["soNguoiDangO"],
            soChoTrong: p["soChoTrong"],
            daCoHopDong: p["daCoHopDong"],
            suCoId: suCoId,
          )
      );
    }

    for (final hd in hopDong) {
      debugPrint("Đang thêm ${hd["hopDongId"]}");
      dsHopDong.add(
        HopDongLuanChuyenVM(
          maHopDong: hd["hopDongId"],
          tenNguoiDaiDien:
          hd["hopDongNguoiThue"].isNotEmpty
              ? hd["hopDongNguoiThue"][0]["nguoithue"]["hoTen"]
              : "",

          soThanhVien: hd["hopDongNguoiThue"].length,

          dsThanhVien: hd["hopDongNguoiThue"]
              .map<String>(
                (e) => e["nguoithue"]["hoTen"] as String,
          )
              .toList(),

          dsPhongHopDong: [
            PhongHopDongVM(
              phongId: hd["phongId"],
              tenPhong: suCo["phong"]["tenPhong"],
              sucChua: suCo["phong"]["loaiPhong"]["soNguoiToiDa"],
              soNguoiDangO: hd["hopDongNguoiThue"].length,
              soChoTrong: suCo["phong"]["loaiPhong"]["soNguoiToiDa"] -
                  hd["hopDongNguoiThue"].length,
              daCoHopDong: true,
              suCoId: suCoId,
            ),
          ],

          phongCuText: suCo["phong"]["tenPhong"],

          phongMoiId: null,
          phongMoiText: "",

          sucChua:
          suCo["phong"]["loaiPhong"]["soNguoiToiDa"],

          soNguoiDangO:
          hd["hopDongNguoiThue"].length,

          soChoTrong:
          suCo["phong"]["loaiPhong"]["soNguoiToiDa"] -
              hd["hopDongNguoiThue"].length,

         trangThaiText: "Đang thuê",
        ),
      );
      debugPrint("dsHopDong = ${dsHopDong.length}");
    }

    tenSuCo = suCo["tenSuCo"] ?? "";

    tenPhong = suCo["phong"]["tenPhong"] ?? "";

    ngayBatDauText =
        suCo["ngayBatDau"] ?? "";

    trangThaiText =
        suCo["trangThaiThongBao"].toString();

    notifyListeners();
  }

  Future<void> chonNgay(
      BuildContext context,
      ) async {
    final value = await showDatePicker(
      context: context,
      initialDate: ngayLuanChuyen,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (value == null) return;

    ngayLuanChuyen = value;

    notifyListeners();
  }

  bool validate() {
    for (final item in dsHopDong) {
      if (item.phongMoiText.isEmpty) {
        return false;
      }
    }

    return true;
  }

  Future<void> luu() async {
    if (!validate()) return;

    for (final item in dsHopDong) {
      try {
        await _provider.luuLuanChuyen({
          "suCoId": suCoId,
          "hopDongId": item.maHopDong,
          "phongMoiId": item.phongMoiId,
          "ngayLuanChuyen": ngayLuanChuyen.toIso8601String(),
          "trangThaiLuanChuyen": 0,
          "ghiChu": txtGhiChu.text,
        });

        debugPrint("Lưu thành công");
      } catch (e) {
        debugPrint("Lỗi lưu: $e");
      }
    }
  }

  @override
  void dispose() {
    txtGhiChu.dispose();
    super.dispose();
  }
}

class HopDongLuanChuyenVM {
  final String maHopDong;
  final String tenNguoiDaiDien;
  final int soThanhVien;
  final List<String> dsThanhVien;
  final List<PhongHopDongVM> dsPhongHopDong;
  final String phongCuText;
  final int? phongMoiId;
  final String phongMoiText;
  final int sucChua;
  final int soNguoiDangO;
  final int soChoTrong;
  final String trangThaiText;

  const HopDongLuanChuyenVM({
    required this.maHopDong,
    required this.tenNguoiDaiDien,
    required this.soThanhVien,
    required this.dsThanhVien,
    required this.dsPhongHopDong,

    required this.phongCuText,
    required this.phongMoiId,
    required this.phongMoiText,
    required this.sucChua,
    required this.soNguoiDangO,
    required this.soChoTrong,
    required this.trangThaiText,
  });

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
      dsPhongHopDong:
      dsPhongHopDong ?? this.dsPhongHopDong,
      phongCuText: phongCuText ?? this.phongCuText,
      phongMoiId: phongMoiId ?? this.phongMoiId,
      phongMoiText: phongMoiText ?? this.phongMoiText,
      sucChua: sucChua ?? this.sucChua,
      soNguoiDangO: soNguoiDangO ?? this.soNguoiDangO,
      soChoTrong: soChoTrong ?? this.soChoTrong,
      trangThaiText: trangThaiText ?? this.trangThaiText,
    );
  }
  bool get coNhieuHopDong {
    return dsPhongHopDong.length > 1;
  }
  bool laPhongHopDong(int phongId) {
    return dsPhongHopDong.any(
          (e) => e.phongId == phongId,
    );
  }
}