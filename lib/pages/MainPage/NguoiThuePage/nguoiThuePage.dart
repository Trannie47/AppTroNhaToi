import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/danhsachnguoithuepage/DanhSachNguoiThuePage.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/danhsachphongthuepage/DanhSachPhongThuePage.dart';
import 'package:AppTroNhaToi/widget/itemNguoiThue.dart';
import 'package:flutter/material.dart';

import 'ChiTietNguoiThuePage/chiTietNguoiThuePage.dart';

class NguoiThuePage extends StatefulWidget {
  const NguoiThuePage({super.key});

  @override
  State<NguoiThuePage> createState() => _NguoiThuePageState();
}

class _NguoiThuePageState extends State<NguoiThuePage> {
  // nút edit
  final TextEditingController searchController = TextEditingController();

  //Dữ liệu khởi tao
  bool isLoading = true;
  late List<NguoiThue> danhSachNguoiThue;

  //hàm
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final danhSachNguoiThueTam = [
      NguoiThue(
        idnt: 1,
        hoTen: "Nguyễn Văn An",
        cccd: "079001234567",
        sdt: "0901234567",
        ngaySinh: DateTime(1990, 5, 20),
        queQuan: "Hà Nội",
        gioiTinh: true,
        ghiChu: "",
      ),

      NguoiThue(
        idnt: 2,
        hoTen: "Trần Văn Bảo",
        cccd: "079001234890",
        sdt: "0912345678",
        ngaySinh: DateTime(1992, 8, 15),
        queQuan: "Hồ Chí Minh",
        gioiTinh: false,
        ghiChu: "Ở ghép",
      ),

      NguoiThue(
        idnt: 3,
        hoTen: "Nguyễn Văn B",
        cccd: "079001234567",
        ngaySinh: DateTime(1995, 3, 10),
        queQuan: "Đà Nẵng",
        gioiTinh: true,
        ghiChu: "",
      ),
    ];
    setState(() {
      danhSachNguoiThue = danhSachNguoiThueTam;
      isLoading = false;
    });
  }

  /// CHI TIẾT NGƯỜI THUÊ
  void toChiTietNguoiThue(NguoiThue nt) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChiTietNguoiThuePage(nguoiThue: nt);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Người thuê",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1C1C1E),
                    ),
                  ),

                  Row(
                    children: [
                      /// ADD
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) {
                                return const NguoiThueForm();
                              },
                            ),
                          );
                        },

                        child: Image.asset(
                          "assets/images/add.png",
                          width: 40,
                          height: 40,
                        ),
                      ),

                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),

              child: Container(
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),

                  borderRadius: BorderRadius.circular(12),
                ),

                alignment: Alignment.center,

                child: TextField(
                  controller: searchController,

                  textAlignVertical: TextAlignVertical.center,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    isDense: true,

                    contentPadding: const EdgeInsets.symmetric(vertical: 10),

                    hintText: "Tìm tên, SDT, CCCD...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,

                      fontSize: 13,
                    ),

                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  itemCount: danhSachNguoiThue.length,

                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        toChiTietNguoiThue(danhSachNguoiThue[index]);
                      },
                      child: ItemNguoiThue(nguoiThue: danhSachNguoiThue[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
