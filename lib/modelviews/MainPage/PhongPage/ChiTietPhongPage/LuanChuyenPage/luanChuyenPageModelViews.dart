import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';
import 'package:flutter/material.dart';

class LuanChuyenPageViewModel extends ChangeNotifier {
  // LuanChuyenViewModel(this._provider, this.suCoId) {
  //   loadData(suCoId);
  // }

  // final SuCoProvider _provider;
  // final int suCoId;

  // final txtGhiChu = TextEditingController();

  // DateTime ngayLuanChuyen = DateTime.now();

  // String tenSuCo = "";
  // String tenPhong = "";
  // String ngayBatDauText = "";
  // String trangThaiText = "";

  // final List<PhongHopDongVM> dsPhong = [];
  // final List<HopDongLuanChuyenVM> dsHopDong = [];

  // String get ngayLuanChuyenText {
  //   final d = ngayLuanChuyen.day.toString().padLeft(2, '0');
  //   final m = ngayLuanChuyen.month.toString().padLeft(2, '0');
  //   final y = ngayLuanChuyen.year;
  //   return "$d/$m/$y";
  // }

  // void chonPhongMoi(int index, PhongHopDongVM phong) {
  //   dsHopDong[index] = dsHopDong[index].copyWith(
  //     phongMoiId: phong.phongId,
  //     phongMoiText: phong.tenPhong,
  //     sucChua: phong.sucChua,
  //     soNguoiDangO: phong.soNguoiDangO,
  //     soChoTrong: phong.soChoTrong,
  //   );

  //   notifyListeners();
  // }

  // Future<void> loadData(int suCoId) async {
  //   final data = await _provider.getLuanChuyen(suCoId);

  //   if (data.isEmpty) return;

  //   final suCo = data["suCo"];
  //   final List<dynamic> hopDong = data["hopDong"];
  //   final List<dynamic> phongChuyen = data["phongChuyen"];

  //   final phong = suCo["phong"];
  //   final loaiPhong = phong["loaiPhong"];
  //   final int sucChuaPhong = loaiPhong["soNguoiToiDa"];

  //   dsPhong
  //     ..clear()
  //     ..addAll(
  //       phongChuyen.map(
  //         (p) => PhongHopDongVM(
  //           phongId: p["phongId"],
  //           tenPhong: p["tenPhong"],
  //           sucChua: p["sucChua"],
  //           soNguoiDangO: p["soNguoiDangO"],
  //           soChoTrong: p["soChoTrong"],
  //           daCoHopDong: p["daCoHopDong"],
  //           suCoId: suCoId,
  //         ),
  //       ),
  //     );

  //   dsHopDong
  //     ..clear()
  //     ..addAll(
  //       hopDong.map((hd) {
  //         final List<dynamic> nguoiThue = hd["hopDongNguoiThue"];
  //         final soNguoiDangO = nguoiThue.length;

  //         return HopDongLuanChuyenVM(
  //           maHopDong: hd["hopDongId"],
  //           tenNguoiDaiDien: nguoiThue.isNotEmpty
  //               ? nguoiThue[0]["nguoithue"]["hoTen"]
  //               : "",
  //           soThanhVien: nguoiThue.length,
  //           dsThanhVien: nguoiThue
  //               .map<String>((e) => e["nguoithue"]["hoTen"] as String)
  //               .toList(),
  //           dsPhongHopDong: [
  //             PhongHopDongVM(
  //               phongId: hd["phongId"],
  //               tenPhong: phong["tenPhong"],
  //               sucChua: sucChuaPhong,
  //               soNguoiDangO: soNguoiDangO,
  //               soChoTrong: sucChuaPhong - soNguoiDangO,
  //               daCoHopDong: true,
  //               suCoId: suCoId,
  //             ),
  //           ],
  //           phongCuText: phong["tenPhong"],
  //           phongMoiId: null,
  //           phongMoiText: "",
  //           sucChua: sucChuaPhong,
  //           soNguoiDangO: soNguoiDangO,
  //           soChoTrong: sucChuaPhong - soNguoiDangO,
  //           trangThaiText: "Đang thuê",
  //         );
  //       }),
  //     );

  //   tenSuCo = suCo["tenSuCo"] ?? "";
  //   tenPhong = phong["tenPhong"] ?? "";
  //   ngayBatDauText = suCo["ngayBatDau"] ?? "";
  //   trangThaiText = suCo["trangThaiThongBao"].toString();

  //   notifyListeners();
  // }

  // Future<void> chonNgay(BuildContext context) async {
  //   final value = await showDatePicker(
  //     context: context,
  //     initialDate: ngayLuanChuyen,
  //     firstDate: DateTime(2024),
  //     lastDate: DateTime(2100),
  //   );

  //   if (value == null) return;

  //   ngayLuanChuyen = value;
  //   notifyListeners();
  // }

  // bool validate() {
  //   return dsHopDong.every((item) => (item.phongMoiText ?? "").isNotEmpty);
  // }

  // Future<void> luu() async {
  //   if (!validate()) return;

  //   for (final item in dsHopDong) {
  //     try {
  //       await _provider.luuLuanChuyen({
  //         "suCoId": suCoId,
  //         "hopDongId": item.maHopDong,
  //         "phongMoiId": item.phongMoiId,
  //         "ngayLuanChuyen": ngayLuanChuyen.toIso8601String(),
  //         "trangThaiLuanChuyen": 0,
  //         "ghiChu": txtGhiChu.text,
  //       });
  //     } catch (e) {
  //       debugPrint("Lỗi lưu luân chuyển hợp đồng ${item.maHopDong}: $e");
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   txtGhiChu.dispose();
  //   super.dispose();
  // }
}
