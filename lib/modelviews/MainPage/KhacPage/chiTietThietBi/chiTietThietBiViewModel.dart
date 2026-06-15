import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ChiTietThietBiViewModel extends ChangeNotifier {

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
  }

  bool get dangSua {

    return thietBi.trangThai?.toLowerCase() == "đang sửa";
  }

  void capNhatTrangThai(String trangThaiMoi) {

    int index = dsThietBi.indexWhere(
          (e) => e.thietBiID == thietBi.thietBiID,
    );

    if (index != -1) {

      dsThietBi[index] = dsThietBi[index].copyWith(
        trangThai: trangThaiMoi,
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

    return thietBi.trangThai ?? "";
  }

  String get tenPhong {

    LapRap? lapRap;

    try {

      lapRap = dsLapRap.firstWhere(
            (e) => e.thietBiID == thietBi.thietBiID,
      );

    } catch (_) {

      return "";
    }

    try {

      return dsPhong
          .firstWhere(
            (e) => e.phongID == lapRap!.phongID,
      )
          .tenPhong;

    } catch (_) {

      return "";
    }
  }

  Phong? get phongHienTai {

    LapRap? lapRap;

    try {

      lapRap = dsLapRap.firstWhere(
            (e) => e.thietBiID == thietBi.thietBiID,
      );

    } catch (_) {

      return null;
    }

    try {

      return dsPhong.firstWhere(
            (e) => e.phongID == lapRap!.phongID,
      );

    } catch (_) {

      return null;
    }
  }

  List<Map<String, dynamic>> lichSuSuaChua = [

    {
      "noiDung": "Không lạnh, không khởi động",
      "ngay": "15/05/2026",
      "trangThai": "Đang sửa",
    },

    {
      "noiDung": "Vệ sinh dàn lạnh",
      "ngay": "15/08/2024",
      "chiPhi": "150,000đ",
    },
  ];

  void xoaLichSu(int index) {

    lichSuSuaChua.removeAt(index);

    notifyListeners();
  }

  @override
  void dispose() {

    super.dispose();
  }
}