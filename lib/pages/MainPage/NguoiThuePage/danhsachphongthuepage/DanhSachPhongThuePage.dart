import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/ChiTietNguoiThuePage/chiTietNguoiThuePage.dart';
import 'package:AppTroNhaToi/widget/itemPhong.dart';
import 'package:flutter/material.dart';

class DanhSachPhongThuePage extends StatefulWidget {
  final List<Phong> phong;

  final NguoiThue nguoiThue;

  const DanhSachPhongThuePage({
    super.key,
    required this.phong,
    required this.nguoiThue,
  });

  @override
  State<DanhSachPhongThuePage> createState() => _DanhSachPhongThuePageState();
}

class _DanhSachPhongThuePageState extends State<DanhSachPhongThuePage> {
  final TextEditingController searchController = TextEditingController();

  final List<LoaiPhong> dsLoaiPhong = [
    LoaiPhong(
      maLoaiPhong: 1,
      tenLoaiPhong: "Tiêu chuẩn",
      dienTich: 18,
      soNguoiToiDa: 2,
      giaTien: 3200000,
      isMayLanh: true,
    ),
  ];

  /// ĐI CHI TIẾT NGƯỜI THUÊ
  void toChiTietNguoiThue(Phong phong) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChiTietNguoiThuePage(
            nguoiThue: widget.nguoiThue,

            dsPhong:widget.phong,
          );
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
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),

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
                      "Danh sách phòng thuê",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.w800,

                        color: Color(0xff1C1C1E),
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
                height: 42,

                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: TextField(
                  controller: searchController,

                  textAlignVertical: TextAlignVertical.center,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Tìm kiếm phòng...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,

                      fontSize: 13,
                    ),

                    prefixIcon: Icon(
                      Icons.search,

                      color: Colors.grey.shade500,

                      size: 20,
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                itemCount: widget.phong.length,

                itemBuilder: (context, index) {
                  return ItemPhong(
                    phong: widget.phong[index],

                    loaiPhong: dsLoaiPhong.first,

                    onTap: () {
                      toChiTietNguoiThue(widget.phong[index]);
                    },
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
