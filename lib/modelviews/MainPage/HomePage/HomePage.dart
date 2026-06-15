import 'package:AppTroNhaToi/models/cong_no.dart';
import 'package:AppTroNhaToi/models/thong_bao.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/FormPhong/FormPhong.dart';
import 'package:flutter/material.dart';

class HomePageModelView extends ChangeNotifier {
  double roomCount = 0;
  double emptyRoomCount = 0;
  double occupiedRoomCount = 0;

  bool isLoading = true;

  List<ThongBao> issues = [];

  List<CongNo> debts = [];

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    roomCount = 0;
    emptyRoomCount = 0;
    occupiedRoomCount = roomCount - emptyRoomCount;

    issues = [
      ThongBao(
        title: "3 hóa đơn chưa thu tiền",
        subtitle: "P101 · P104 · P202",
        date: DateTime.now(),
      ),
      ThongBao(
        title: "2 phòng chưa ghi điện nước",
        subtitle: "P101 · P203",
        date: DateTime.parse("2026-05-13 18:00:00"),
      ),
      ThongBao(
        title: "HĐ phòng 203 Hết Hạn",
        subtitle: "Hoàng Văn Bình ",
        date: DateTime.parse("2026-04-03 18:00:00"),
      ),
    ];

    debts = [
      CongNo(
        name: "Nguyễn Văn A",
        room: "Phòng 102 · 3 lần mua",
        amount: 350000,
      ),
      CongNo(
        name: "Trần Thị Lan",
        room: "Phòng 201 · 2 lần mua",
        amount: 120000,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  void navigateToFormRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormPhong()),
    );
  }
}
