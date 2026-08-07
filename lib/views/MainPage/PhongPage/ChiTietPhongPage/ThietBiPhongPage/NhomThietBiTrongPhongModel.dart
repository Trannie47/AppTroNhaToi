import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';

class NhomThietBiTrongPhong {
  final int thietBiId;
  final ThietBi? thietBi;
  final List<ThietBiPhongPageModel> danhSach;

  NhomThietBiTrongPhong({
    required this.thietBiId,
    required this.thietBi,
    required this.danhSach,
  });

  int get soLuong => danhSach.length;

  int get soLuongDangSua =>
      danhSach.fold(0, (tong, e) => tong + e.soLuongDangSua);

  int get soLuongHong => danhSach.fold(0, (tong, e) => tong + e.soLuongHong);

  DateTime? get ngayLapGanNhat {
    final ngays = danhSach
        .map((e) => e.lapRap.ngayLap)
        .whereType<DateTime>()
        .toList();
    if (ngays.isEmpty) return null;
    ngays.sort();
    return ngays.last;
  }

  List<int> get danhSachId =>
      danhSach.map((e) => e.lapRap.id).whereType<int>().toList();
}

List<NhomThietBiTrongPhong> gomNhomTheoThietBi(List<ThietBiPhongPageModel> ds) {
  final Map<int, List<ThietBiPhongPageModel>> map = {};
  for (final item in ds) {
    final tbId = item.lapRap.thietBiID;
    if (tbId == null) continue;
    map.putIfAbsent(tbId, () => []).add(item);
  }
  return map.entries.map((e) {
    final thietBi = e.value
        .map((item) => item.lapRap.thietBi)
        .firstWhere((tb) => tb != null, orElse: () => null);

    return NhomThietBiTrongPhong(
      thietBiId: e.key,
      thietBi: thietBi,
      danhSach: e.value,
    );
  }).toList();
}
