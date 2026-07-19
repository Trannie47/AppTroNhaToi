import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ChiTietLichSuMuaThietBiPageViewModel extends ChangeNotifier {
  late LichSuMuaThietBi lichSuMua;

  late ThietBi thietBi;

  void init(LichSuMuaThietBi lichSuMuaData, ThietBi thietBiData) {
    lichSuMua = lichSuMuaData;
    thietBi = thietBiData;
  }

  String get tenThietBi {
    return thietBi.tenThietBi ?? "";
  }

  int get soLuong {
    return lichSuMua.soLuong ?? 0;
  }

  double get donGia {
    return lichSuMua.donGia ?? 0;
  }

  DateTime? get ngayMua {
    return lichSuMua.ngayMua;
  }

  String get ghiChu {
    return lichSuMua.ghiChu ?? "";
  }

  bool get duocCapNhat {
    if (ngayMua == null) return false;

    final now = DateTime.now();

    return ngayMua!.year == now.year && ngayMua!.month == now.month;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
