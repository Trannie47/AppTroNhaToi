import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/phongPage.dart';
import 'package:AppTroNhaToi/pages/MainPage/HomePage/FormPhong/FormPhong.dart';
import 'package:AppTroNhaToi/widget/itemPhong.dart';
import 'package:flutter/material.dart';

class PhongPage extends StatefulWidget {
  const PhongPage({super.key});

  @override
  State<PhongPage> createState() => _PhongPageState();
}

class _PhongPageState extends State<PhongPage> {
  final PhongPageModelView vm = PhongPageModelView();

  @override
  void initState() {
    super.initState();

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

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

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
              child: Column(
                children: [
                  /// SEARCH + FILTER + THỐNG KÊ
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          // Search bar
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
                              children: [
                                _itemFilter(
                                  filter: -1,
                                  text: "Tất cả (${vm.dsPhong.length})",
                                  bgColor: const Color(0xffECECEC),
                                  textColor: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 0,
                                  text: "Còn trống (${vm.countByStatus(0)})",
                                  bgColor: const Color(0xffEAF3EB),
                                  textColor: const Color(0xff2D7A3A),
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 1,
                                  text: "Đang thuê (${vm.countByStatus(1)})",
                                  bgColor: const Color(0xffFFF1E1),
                                  textColor: const Color(0xffFF8A00),
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 2,
                                  text: "Đang sửa (${vm.countByStatus(2)})",
                                  bgColor: const Color(0xffFFEAEA),
                                  textColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          /// THỐNG KÊ
                          Row(
                            children: [
                              _itemThongKe(
                                title: "${vm.dsPhong.length}",
                                subTitle: "Tổng phòng",
                                color: const Color(0xff222222),
                              ),
                              _itemThongKe(
                                title: "${vm.countByStatus(0)}",
                                subTitle: "Còn trống",
                                color: const Color(0xff2D7A3A),
                              ),
                              _itemThongKe(
                                title: "${vm.countByStatus(1)}",
                                subTitle: "Đang thuê",
                                color: const Color(0xffFF8A00),
                              ),
                              _itemThongKe(
                                title: "${vm.countByStatus(2)}",
                                subTitle: "Đang sửa",
                                color: Colors.red,
                              ),
                            ],
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
                        itemCount: vm.dsPhongFilter.length,
                        itemBuilder: (context, index) {
                          final phong = vm.dsPhongFilter[index];
                          final loaiPhong = vm.getLoaiPhong(phong.maLoaiPhong);
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
    required int filter,
  }) {
    return GestureDetector(
      onTap: () => vm.applyFilter(filter),
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