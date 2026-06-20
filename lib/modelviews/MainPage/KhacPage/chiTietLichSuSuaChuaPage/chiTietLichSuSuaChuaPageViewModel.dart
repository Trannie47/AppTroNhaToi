import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';

class ChiTietLichSuSuaChuaPageViewModel extends ChangeNotifier {
  late SuaChua suaChua;
  HoaDonSuaChua? hoaDonSuaChua;
  late Phong phong;
  late ThietBi thietBi;

  void init(
    SuaChua suaChuaData,
    HoaDonSuaChua? hoaDonSuaChuaData,
    Phong phongData,
    ThietBi thietBiData,
  ) {
    suaChua = suaChuaData;
    hoaDonSuaChua = hoaDonSuaChuaData;
    phong = phongData;
    thietBi = thietBiData;
  }

  String get tenPhong {
    return phong.tenPhong;
  }

  String get tenThietBi {
    return thietBi.tenThietBi ?? "";
  }

  bool get daLapHoaDon {
    return hoaDonSuaChua != null;
  }

  bool get dangSua {
    return hoaDonSuaChua?.trangThai != 2;
  }

  Color get mauTrangThai {
    return dangSua ? Colors.red : Colors.green;
  }

  String get trangThaiText {
    if (hoaDonSuaChua == null) {
      return "Đang sửa";
    }

    switch (hoaDonSuaChua!.trangThai) {
      case 0:
        return "Chờ thanh toán";
      case 1:
        return "Đã thanh toán";
      case 2:
        return "Hoàn thành";
      default:
        return "Đang sửa";
    }
  }

  String get loaiSuaText {
    if (hoaDonSuaChua == null) {
      return "";
    }

    switch (hoaDonSuaChua!.loaiSua) {
      case 0:
        return "Sửa chữa";
      case 1:
        return "Bảo trì";
      case 2:
        return "Vệ sinh";
      case 3:
        return "Thay thế";
      case 4:
        return "Khác";
      default:
        return "";
    }
  }

  void xoaChiTiet() {
    // TODO: xử lý xóa
    notifyListeners();
  }

  void capNhatThongTin() {
    // TODO: xử lý cập nhật
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
