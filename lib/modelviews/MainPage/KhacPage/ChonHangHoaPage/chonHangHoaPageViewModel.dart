import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:flutter/material.dart';

class ChonHangHoaPageModelView extends ChangeNotifier {
  final TextEditingController txtSearch = TextEditingController();

  List<HangHoa> dsHangHoa = [];
  List<HangHoa> dsHangHoaHienThi = [];

  ChonHangHoaPageModelView() {
    init();
  }

  void init() {
    _loadFakeData();

    txtSearch.addListener(() {
      timKiem(txtSearch.text);
    });
  }

  void _loadFakeData() {
    dsHangHoa = [
      HangHoa(
        maHangHoa: 1,
        tenHangHoa: "Mì Hảo Hảo",
        giaNhap: 3000,
        giaBan: 5000,
        donViTinh: "gói",
      ),
      HangHoa(
        maHangHoa: 2,
        tenHangHoa: "Coca Cola",
        giaNhap: 8000,
        giaBan: 12000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 3,
        tenHangHoa: "Nước suối",
        giaNhap: 4000,
        giaBan: 7000,
        donViTinh: "chai",
      ),
      HangHoa(
        maHangHoa: 4,
        tenHangHoa: "Sữa Vinamilk",
        giaNhap: 28000,
        giaBan: 35000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 5,
        tenHangHoa: "Bánh Oreo",
        giaNhap: 12000,
        giaBan: 18000,
        donViTinh: "hộp",
      ),
      HangHoa(
        maHangHoa: 6,
        tenHangHoa: "Trứng gà",
        giaNhap: 25000,
        giaBan: 30000,
        donViTinh: "vỉ",
      ),
      HangHoa(
        maHangHoa: 7,
        tenHangHoa: "Trứng gà",
        giaNhap: 25000,
        giaBan: 30000,
        donViTinh: "vỉ",
      ),
      HangHoa(
        maHangHoa: 7,
        tenHangHoa: "Socola",
        giaNhap: 25000,
        giaBan: 30000,
        donViTinh: "vỉ",
      ),
    ];

    dsHangHoaHienThi = List.from(dsHangHoa);

    notifyListeners();
  }

  void timKiem(String keyword) {
    keyword = keyword.trim().toLowerCase();

    if (keyword.isEmpty) {
      dsHangHoaHienThi = List.from(dsHangHoa);
    } else {
      dsHangHoaHienThi = dsHangHoa.where((e) {
        return (e.tenHangHoa ?? "").toLowerCase().contains(keyword);
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
