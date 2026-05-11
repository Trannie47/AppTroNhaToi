import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
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
      phong: Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
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
      phong: Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
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
      phong: Phong(phongID: 2, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
    ),
    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 3,
        hoTen: "Lê Văn D",
        cccd: "123456789966",
        sdt: "0325896345",
        queQuan: "Hà Tĩnh",
        ghiChu: "",
        ngaySinh: DateTime(2004, 8, 16),
      ),
      phong: Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 1),
    ),
  ];

  final TextEditingController searchController = TextEditingController();
  // lôi
  // Chuyển đến tran ChitietNGuoiThuePage
  void toChiTietNguoiThue(NguoiThuePhong nt) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChiTietNguoiThuePage(nguoiThue: nt.nguoiThue, phong: nt.phong!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int tong = danhSachNguoiThue.length;

    int thueChinh = danhSachNguoiThue
        .where(
          (e) =>
              e.nguoiThue.ghiChu == null || e.nguoiThue.ghiChu!.trim().isEmpty,
        )
        .length;

    int oGhep = tong - thueChinh;

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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1C1C1E),
                    ),
                  ),

                  Container(
                    height: 36,

                    decoration: BoxDecoration(
                      color: const Color(0xff2D7A3A),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Material(
                      color: Colors.transparent,

                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),

                        onTap: () {},

                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),

                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 16),

                              SizedBox(width: 4),

                              Text(
                                "Thêm",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(14),
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

            const SizedBox(height: 18),

            /// THỐNG KÊ
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  _itemThongKe(
                    title: "$tong",
                    subTitle: "Tổng (chính + ghép)",
                    color: const Color(0xff222222),
                  ),

                  _divider(),

                  _itemThongKe(
                    title: "$thueChinh",
                    subTitle: "Thuê chính",
                    color: const Color(0xff2D7A3A),
                  ),

                  _divider(),

                  _itemThongKe(
                    title: "$oGhep",
                    subTitle: "Ở ghép",
                    color: const Color(0xff222222),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            //lỗi
            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                itemCount: danhSachNguoiThue.length,

                itemBuilder: (context, index) {
                  return ItemNguoiThue(
                    nguoiThue: danhSachNguoiThue[index].nguoiThue,
                    phong: danhSachNguoiThue[index].phong,
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

  Widget _divider() {
    return Container(width: 1, height: 65, color: const Color(0xffEEEEEE));
  }

  Widget _itemThongKe({
    required String title,
    required String subTitle,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),

        child: Column(
          children: [
            Text(
              title,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subTitle,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 10,
                color: Color(0xff999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
