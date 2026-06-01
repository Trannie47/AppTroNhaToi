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
  final List<NguoiThuePhong> danhSachNguoiThue = [
    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 1,
        hoTen: "Nguyễn Văn An",
        cccd: "079203001234",
        sdt: "0909123456",
        queQuan: "TP.HCM",
        ghiChu: "",
        ngaySinh: DateTime(2003, 5, 12),
      ),

      //phongid 0	Trống  1	Đang thuê  2	Đang sửa
      //         maLoaiPhong	1	Tiêu chuẩn  2	VIP  3	Studio
      phong: [
        Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),

        Phong(phongID: 2, tenPhong: "P102", trangThai: 2, maLoaiPhong: 2),
        Phong(phongID: 5, tenPhong: "P105", trangThai: 0, maLoaiPhong: 3),
        Phong(phongID: 4, tenPhong: "P104", trangThai: 3, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 2,
        hoTen: "Trần Thị B",
        cccd: "079203001235",
        sdt: "0909234567",
        queQuan: "Hà Nội",
        ghiChu: "Ở ghép",
        ngaySinh: DateTime(2000, 8, 20),
      ),

      phong: [
        Phong(phongID: 1, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 3,
        hoTen: "Lê Văn C",
        cccd: "079203001236",
        sdt: "0909345678",
        queQuan: "Đà Nẵng",
        ghiChu: "",
        ngaySinh: DateTime(2001, 3, 15),
      ),

      phong: [
        Phong(phongID: 2, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 4,
        hoTen: "Lê Văn D",
        cccd: "123456789966",
        sdt: "0325896345",
        queQuan: "Hà Tĩnh",
        ghiChu: "",
        ngaySinh: DateTime(2004, 8, 16),
      ),

      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 1),
      ],
    ),
  ];

  final TextEditingController searchController = TextEditingController();
  void toChiTietNguoiThue(NguoiThuePhong nt) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            ChiTietNguoiThuePage(nguoiThue: nt.nguoiThue, dsPhong: nt.phong),
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

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                itemCount: danhSachNguoiThue.length,

                itemBuilder: (context, index) {
                  return ItemNguoiThue(
                    nguoiThue: danhSachNguoiThue[index].nguoiThue,

                    phong: danhSachNguoiThue[index].phong.first,

                    onTap: () => toChiTietNguoiThue(danhSachNguoiThue[index]),
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
