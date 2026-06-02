import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

class ChiTietNguoiThuePageViewModel extends ChangeNotifier {
  late final NguoiThue nguoiThue;
  late final List<Phong> dsPhong;

  List<PhuongTien> dsXe = [];
  List<HoaDonGuiXe> dsHoaDon = [];

  ChiTietNguoiThuePageViewModel({
    required this.nguoiThue,
    required this.dsPhong,
  });

  
}