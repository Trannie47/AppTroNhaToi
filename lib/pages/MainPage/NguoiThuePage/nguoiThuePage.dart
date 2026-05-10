import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:flutter/material.dart';

class NguoiThuePage extends StatefulWidget {
  const NguoiThuePage({super.key});

  @override
  State<NguoiThuePage> createState() => _NguoiThuePageState();
}

class _NguoiThuePageState extends State<NguoiThuePage> {
  final List<NguoiThue> danhSachNguoiThue = [
    NguoiThue(
      idnt: 1,
      hoTen: "Nguyễn Văn A",
      cccd: "079203001234",
      sdt: "0909123456",
      queQuan: "TP.HCM",
      ghiChu: "Đã cọc phòng",
      ngaySinh: DateTime(2003, 5, 12),
    ),
    NguoiThue(
      idnt: 2,
      hoTen: "Trần Thị B",
      cccd: "079203004567",
      sdt: "0988111222",
      queQuan: "Cần Thơ",
      ghiChu: "Thuê dài hạn",
      ngaySinh: DateTime(2002, 8, 20),
    ),
  ];

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text("Danh sách người thuê"),
        centerTitle: true,
        backgroundColor: const Color(0xff2D7A3A),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2D7A3A),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: danhSachNguoiThue.isEmpty
          ? const Center(
              child: Text(
                "Chưa có người thuê",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: danhSachNguoiThue.length,
              itemBuilder: (context, index) {
                final nt = danhSachNguoiThue[index];

                return Container();
              },
            ),
    );
  }
}
