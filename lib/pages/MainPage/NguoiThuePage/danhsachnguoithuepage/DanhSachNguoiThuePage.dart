import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/widget/itemNguoiThue.dart';
import 'package:flutter/material.dart';

class DanhSachNguoiThuePage extends StatefulWidget {
  const DanhSachNguoiThuePage({super.key});

  @override
  State<DanhSachNguoiThuePage> createState() => _DanhSachNguoiThuePageState();
}

class _DanhSachNguoiThuePageState extends State<DanhSachNguoiThuePage> {
  final TextEditingController searchController = TextEditingController();

  final List<NguoiThuePhong> danhSachNguoiThue = [
    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 1,
        hoTen: "Nguyễn Văn An",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),

      phong: [
        Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 2,
        hoTen: "Trần Văn Bảo",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),

      phong: [
        Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 3,
        hoTen: "Nguyễn Văn B",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),

      phong: [
        Phong(phongID: 2, tenPhong: "P102", trangThai: 1, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 4,
        hoTen: "Trần Văn C",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),

      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 2, maLoaiPhong: 1),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 5,
        hoTen: "Nguyễn Văn D",
        cccd: "079001234567",
        sdt: "0901 234 567",
        ghiChu: "",
      ),

      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 2),
      ],
    ),

    NguoiThuePhong(
      nguoiThue: NguoiThue(
        idnt: 6,
        hoTen: "Trần Văn E",
        cccd: "079001234890",
        sdt: "0912 345 678",
        ghiChu: "Ở ghép",
      ),

      phong: [
        Phong(phongID: 3, tenPhong: "P103", trangThai: 1, maLoaiPhong: 1),
      ],
    ),
  ];

  /// THÊM NGƯỜI THUÊ
  void toThemNguoiThue() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const ThemNguoiThuePage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// TỔNG
    int tong = danhSachNguoiThue.length;

    /// THUÊ CHÍNH
    int thueChinh = danhSachNguoiThue
        .where(
          (e) =>
              e.nguoiThue.ghiChu == null || e.nguoiThue.ghiChu!.trim().isEmpty,
        )
        .length;

    /// Ở GHÉP
    int oGhep = tong - thueChinh;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),

              child: Row(
                children: [
                  /// BACK
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(
                      width: 34,
                      height: 34,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TITLE
                  const Expanded(
                    child: Text(
                      "Danh sách người thuê",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  /// ADD
                  GestureDetector(
                    onTap: toThemNguoiThue,

                    child: SizedBox(
                      width: 40,
                      height: 40,

                      child: Image.asset(
                        "assets/images/add.png",
                        fit: BoxFit.contain,
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
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: TextField(
                  controller: searchController,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Tìm tên, SDT, CCCD...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),

                    contentPadding: const EdgeInsets.only(top: 10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// THỐNG KÊ
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),

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
                    color: const Color(0xff2D8B47),
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

            const SizedBox(height: 14),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                itemCount: danhSachNguoiThue.length,

                itemBuilder: (context, index) {
                  return ItemNguoiThue(
                    nguoiThue: danhSachNguoiThue[index].nguoiThue,

                    phong: danhSachNguoiThue[index].phong.first,
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

  //end
}
