import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class ChiTietThietBiPageViewModel extends ChangeNotifier {
  late List<Phong> dsPhong;
  late List<LapRap> dsLapRap;
  late ThietBi thietBi;

  late List<ThietBi> dsThietBi;

  void init(
    ThietBi tb,
    List<Phong> phongList,
    List<LapRap> lapRapList,
    List<ThietBi> thietBiList,
  ) {
    thietBi = tb;
    dsPhong = phongList;
    dsLapRap = lapRapList;
    dsThietBi = thietBiList;
    // load fake repair history for this device
    _loadFakeLichSuSuaChua();
  }

  List<LichSuSuaChuaPageModel> lichSuSuaChua = [];
  bool get dangSua {
    return thietBi.trangThaiText.toLowerCase() == "đang sửa";
  }

  void capNhatTrangThai(String trangThaiMoi) {
    int index = dsThietBi.indexWhere((e) => e.thietBiID == thietBi.thietBiID);

    if (index != -1) {
      dsThietBi[index] = dsThietBi[index].copyWith(
        trangThai: trangThaiMoi == "Tốt" ? 0 : 1,
      );

      thietBi = dsThietBi[index];
    }

    notifyListeners();
  }

  String get tenThietBi {
    return thietBi.tenThietBi ?? "";
  }

  String get loai {
    return thietBi.loai ?? "";
  }

  double get giaTri {
    return thietBi.giaTri ?? 0;
  }

  DateTime? get ngayMua {
    return thietBi.ngayMua;
  }

  String get trangThai {
    return thietBi.trangThaiText;
  }

  String get tenPhong {
    LapRap? lapRap;

    try {
      lapRap = dsLapRap.firstWhere((e) => e.thietBiID == thietBi.thietBiID);
    } catch (_) {
      return "";
    }

    try {
      return dsPhong.firstWhere((e) => e.phongID == lapRap!.phongID).tenPhong;
    } catch (_) {
      return "";
    }
  }

  Phong? get phongHienTai {
    LapRap? lapRap;

    try {
      lapRap = dsLapRap.firstWhere((e) => e.thietBiID == thietBi.thietBiID);
    } catch (_) {
      return null;
    }

    try {
      return dsPhong.firstWhere((e) => e.phongID == lapRap!.phongID);
    } catch (_) {
      return null;
    }
  }

  void xoaLichSu(int index) {
    lichSuSuaChua.removeAt(index);

    notifyListeners();
  }

  void themLichSuSuaChua(SuaChua suaChua) {
    // add a new history item without an invoice
    lichSuSuaChua.insert(
      0,
      LichSuSuaChuaPageModel(suaChua: suaChua, hoaDonSuaChua: null),
    );

    notifyListeners();
  }

  void _loadFakeLichSuSuaChua() {
    // create some sample repair records for the current device
    final s1 = SuaChua(
      id: 101,
      phongID: dsPhong.isNotEmpty ? dsPhong.first.phongID : 0,
      nguyenNhan: 'Lỗi nguồn',
      ngaySuaChua: DateTime(2024, 1, 15),
    );
    final hd1 = HoaDonSuaChua(
      maHoaDonSC: 5001,
      trangThai: 2,
      giaTien: 750000,
      loaiSua: 3,
      ngayLapHoaDonSC: DateTime(2024, 1, 16),
      idSuaChua: 101,
    );

    final s2 = SuaChua(
      id: 102,
      phongID: dsPhong.isNotEmpty ? dsPhong.first.phongID : 0,
      nguyenNhan: 'Thay linh kiện',
      ngaySuaChua: DateTime(2023, 11, 5),
    );
    final hd2 = HoaDonSuaChua(
      maHoaDonSC: 5002,
      trangThai: 1,
      giaTien: 450000,
      loaiSua: 1,
      ngayLapHoaDonSC: DateTime(2023, 11, 6),
      idSuaChua: 102,
    );

    final s3 = SuaChua(
      id: 103,
      phongID: dsPhong.isNotEmpty ? dsPhong.first.phongID : 0,
      nguyenNhan: 'Bảo trì định kỳ',
      ngaySuaChua: DateTime(2023, 6, 20),
    );

    lichSuSuaChua = [
      LichSuSuaChuaPageModel(suaChua: s1, hoaDonSuaChua: hd1),
      LichSuSuaChuaPageModel(suaChua: s2, hoaDonSuaChua: hd2),
      LichSuSuaChuaPageModel(suaChua: s3, hoaDonSuaChua: null),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
