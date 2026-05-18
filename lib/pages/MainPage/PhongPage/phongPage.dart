import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/HomePage/FormPhong/FormPhong.dart';
import 'package:AppTroNhaToi/widget/itemPhong.dart';
import 'package:flutter/material.dart';

class PhongPage extends StatefulWidget {
  const PhongPage({super.key});

  @override
  State<PhongPage> createState() => _PhongPageState();
}

class _PhongPageState extends State<PhongPage> {
  bool isLoading = true;

  List<LoaiPhong> dsLoaiPhong = [];

  List<Phong> dsPhong = [];

  List<Phong> dsPhongFilter = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    dsLoaiPhong = [
      LoaiPhong(
        maLoaiPhong: 1,

        tenLoaiPhong: "Tiêu chuẩn",

        dienTich: 18,

        giaTien: 3200000,

        soNguoiToiDa: 2,

        isMayLanh: true,
      ),

      LoaiPhong(
        maLoaiPhong: 2,

        tenLoaiPhong: "VIP",

        dienTich: 25,

        giaTien: 4500000,

        soNguoiToiDa: 2,

        isMayLanh: true,
      ),
    ];

    dsPhong = [
      Phong(phongID: 1, tenPhong: "P101", trangThai: 1, maLoaiPhong: 1),

      Phong(phongID: 2, tenPhong: "P102", trangThai: 2, maLoaiPhong: 2),

      Phong(phongID: 3, tenPhong: "P301", maLoaiPhong: 1, trangThai: 0),

      Phong(phongID: 4, tenPhong: "P401", maLoaiPhong: 1, trangThai: 2),
    ];
    dsPhongFilter = dsPhong;
    setState(() {
      isLoading = false;
    });
  }

  LoaiPhong getLoaiPhong(num idLoaiPhong) {
    return dsLoaiPhong.firstWhere((e) => e.maLoaiPhong == idLoaiPhong);
  }

  //Gọi form thêm phòng
  void toThemPhong() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPhong()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,

        surfaceTintColor: Colors.white,

        elevation: 0,

        toolbarHeight: 90,

        automaticallyImplyLeading: false,

        titleSpacing: 16,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              "Phòng trọ",

              style: TextStyle(
                color: Colors.black,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            ElevatedButton.icon(
              onPressed: toThemPhong,

              icon: const Icon(Icons.add, color: Colors.white, size: 13),

              label: const Text(
                "Thêm phòng",

                style: TextStyle(color: Colors.white, fontSize: 13),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2D7A3A),

                elevation: 0,

                padding: const EdgeInsets.symmetric(
                  horizontal: 10.25,
                  vertical: 14,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),

              child: Column(
                children: [
                  /// SEARCH
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 36,

                            padding: const EdgeInsets.symmetric(horizontal: 14),

                            decoration: BoxDecoration(
                              color: const Color(0xffECECEC),

                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey.shade500),

                                const SizedBox(width: 8),

                                Text(
                                  "Tìm kiếm phòng...",

                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          /// FILTER
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,

                            child: Row(
                              spacing: 0.1,
                              children: [
                                _itemFilter(
                                  fillter: -1,
                                  text: "Tất cả (${dsPhong.length})",

                                  bgColor: const Color(0xffECECEC),

                                  textColor: Colors.black87,
                                ),

                                const SizedBox(width: 10),

                                _itemFilter(
                                  fillter: 0,
                                  text:
                                      "Còn trống (${dsPhong.where((e) => e.trangThai == 0).length})",

                                  bgColor: const Color(0xffEAF3EB),

                                  textColor: const Color(0xff2D7A3A),
                                ),

                                const SizedBox(width: 10),

                                _itemFilter(
                                  fillter: 1,
                                  text:
                                      "Đang thuê (${dsPhong.where((e) => e.trangThai == 1).length})",

                                  bgColor: const Color(0xffFFF1E1),

                                  textColor: const Color(0xffFF8A00),
                                ),

                                const SizedBox(width: 10),

                                _itemFilter(
                                  fillter: 2,
                                  text:
                                      "Đang sửa (${dsPhong.where((e) => e.trangThai == 2).length})",

                                  bgColor: const Color(0xffFFEAEA),

                                  textColor: Colors.red,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// THỐNG KÊ
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: Row(
                              children: [
                                _itemThongKe(
                                  title: "${dsPhong.length}",
                                  subTitle: "Tổng phòng",
                                  color: const Color(0xff222222),
                                ),

                                _itemThongKe(
                                  title:
                                      "${dsPhong.where((e) => e.trangThai == 0).length}",
                                  subTitle: "Còn trống",
                                  color: const Color(0xff2D7A3A),
                                ),

                                _itemThongKe(
                                  title:
                                      "${dsPhong.where((e) => e.trangThai == 1).length}",
                                  subTitle: "Đang thuê",
                                  color: const Color(0xffFF8A00),
                                ),

                                _itemThongKe(
                                  title:
                                      "${dsPhong.where((e) => e.trangThai == 2).length}",
                                  subTitle: "Đang sửa",
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// LIST
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListView.builder(
                        itemCount: dsPhongFilter.length,

                        itemBuilder: (context, index) {
                          final phong = dsPhongFilter[index];

                          final loaiPhong = getLoaiPhong(phong.maLoaiPhong);

                          return ItemPhong(
                            phong: phong,

                            loaiPhong: loaiPhong,

                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _itemFilter({
    required String text,

    required Color bgColor,

    required Color textColor,

    required int fillter,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (fillter == -1) {
            dsPhongFilter = dsPhong;
          } else {
            dsPhongFilter = dsPhong
                .where((e) => e.trangThai == fillter)
                .toList();
          }
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5.5),

        decoration: BoxDecoration(
          color: bgColor,

          borderRadius: BorderRadius.circular(30),
        ),

        child: Text(
          text,

          style: TextStyle(
            fontSize: 12,

            fontWeight: FontWeight.w600,

            color: textColor,
          ),
        ),
      ),
    );
  }

  //Item Thống kê
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
