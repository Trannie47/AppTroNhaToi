import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:flutter/material.dart';

class LichSuSuaChuaPageViewModel extends ChangeNotifier {
  late Phong phong;
  late ThietBi thietBi;

  final txtSearch = TextEditingController();

  List<LichSuSuaChuaPageModel> dsGoc = [];
  List<LichSuSuaChuaPageModel> lichSuSuaChua = [];

  void init(Phong phongList, ThietBi thietBiList) {
    phong = phongList;
    thietBi = thietBiList;

    loadData();

    txtSearch.addListener(timKiem);
  }

  void loadData() {
    dsGoc = [
      LichSuSuaChuaPageModel(
        suaChua: SuaChua(
          id: 201,
          phongID: phong.phongID,
          nguyenNhan: 'Lỗi nguồn',
          ngaySuaChua: DateTime(2024, 5, 10),
        ),
        hoaDonSuaChua: HoaDonSuaChua(
          maHoaDonSC: 'PSC20260120001',
          trangThai: 2,
          giaTien: 650000,
          loaiSua: 3,
          ngayLapHoaDonSC: DateTime(2024, 5, 11),
          idSuaChua: 201,
        ),
      ),

      LichSuSuaChuaPageModel(
        suaChua: SuaChua(
          id: 202,
          phongID: phong.phongID,
          nguyenNhan: 'Thay ổ cắm',
          ngaySuaChua: DateTime(2024, 4, 2),
        ),
        hoaDonSuaChua: HoaDonSuaChua(
          maHoaDonSC: 'PSC20260120003',
          trangThai: 1,
          giaTien: 200000,
          loaiSua: 0,
          ngayLapHoaDonSC: DateTime(2024, 4, 3),
          idSuaChua: 202,
        ),
      ),

      LichSuSuaChuaPageModel(
        suaChua: SuaChua(
          id: 203,
          phongID: phong.phongID,
          nguyenNhan: 'Bảo trì quạt trần',
          ngaySuaChua: DateTime(2024, 3, 18),
        ),
        hoaDonSuaChua: HoaDonSuaChua(
          maHoaDonSC: 'PSC20260120004',
          trangThai: 2,
          giaTien: 300000,
          loaiSua: 4,
          ngayLapHoaDonSC: DateTime(2024, 3, 19),
          idSuaChua: 203,
        ),
      ),

      LichSuSuaChuaPageModel(
        suaChua: SuaChua(
          id: 204,
          phongID: phong.phongID,
          nguyenNhan: 'Rò rỉ nước',
          ngaySuaChua: DateTime(2023, 12, 5),
        ),
      ),

      LichSuSuaChuaPageModel(
        suaChua: SuaChua(
          id: 205,
          phongID: phong.phongID,
          nguyenNhan: 'Thay đèn',
          ngaySuaChua: DateTime(2023, 10, 20),
        ),
        hoaDonSuaChua: HoaDonSuaChua(
          maHoaDonSC: 'PSC20260120005',
          trangThai: 2,
          giaTien: 120000,
          loaiSua: 3,
          ngayLapHoaDonSC: DateTime(2023, 10, 21),
          idSuaChua: 205,
        ),
      ),
    ];

    lichSuSuaChua = List.from(dsGoc);

    notifyListeners();
  }

  void timKiem() {
    String keyword = txtSearch.text.trim().toLowerCase();

    if (keyword.isEmpty) {
      lichSuSuaChua = List.from(dsGoc);
    } else {
      lichSuSuaChua = dsGoc.where((e) {
        return (e.suaChua.nguyenNhan ?? "").toLowerCase().contains(keyword);
      }).toList();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }
}
