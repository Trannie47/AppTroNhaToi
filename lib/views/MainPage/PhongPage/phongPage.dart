import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/view_models/phong_view_model.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/chiTietPhongPage.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/FormPhong/FormPhong.dart';
import 'package:AppTroNhaToi/widgets/itemPhong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/phong_provider.dart';
import '../../../models/loai_phong.dart';
import '../../../modelviews/MainPage/PhongPage/PhongPageViewModel.dart';
import 'ChiTietPhongPage/phongChiTiet.dart';

class PhongPage extends StatefulWidget {
  const PhongPage({super.key});

  @override
  State<PhongPage> createState() => _PhongPageState();
}

class _PhongPageState extends State<PhongPage> {
  late PhongPageViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = PhongPageViewModel(context.read<PhongProvider>());
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.refresh();
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void themPhong() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPhong()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listPhong = vm.listPhong;
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
              onPressed: themPhong,
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
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: vm.searchController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                hintText: "Tìm kiếm tên phòng, loại phòng...",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                              ),
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
                                  text: "Tất cả (${listPhong.length})",
                                  bgColor: const Color(0xffECECEC),
                                  textColor: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 0,
                                  text:
                                      "Còn trống (${vm.listPhongTrong.length})",
                                  bgColor: const Color(0xffEAF3EB),
                                  textColor: const Color(0xff2D7A3A),
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 1,
                                  text:
                                      "Đang thuê (${vm.listPhongDangThue.length})",
                                  bgColor: const Color(0xffFFF1E1),
                                  textColor: const Color(0xffFF8A00),
                                ),
                                const SizedBox(width: 10),
                                _itemFilter(
                                  filter: 2,
                                  text:
                                      "Đang sửa (${vm.listPhongDangSua.length})",
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
                                title: "${listPhong.length}",
                                subTitle: "Tổng phòng",
                                color: const Color(0xff222222),
                              ),
                              _itemThongKe(
                                title: "${vm.listPhongTrong.length}",
                                subTitle: "Còn trống",
                                color: const Color(0xff2D7A3A),
                              ),
                              _itemThongKe(
                                title: "${vm.listPhongDangThue.length}",
                                subTitle: "Đang thuê",
                                color: const Color(0xffFF8A00),
                              ),
                              _itemThongKe(
                                title: "${vm.listPhongDangSua.length}",
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
                      child: vm.listPhongHienThi.isEmpty
                          ? const Center(
                              child: Text(
                                "Không có phòng trọ nào thuộc trạng thái này",
                              ),
                            )
                          : ListView.builder(
                              itemCount: vm.listPhongHienThi.length,
                              itemBuilder: (context, index) {
                                final itemBackend = vm.listPhongHienThi[index];
                                final currentPhong = Phong(
                                  phongID: itemBackend.phongId,
                                  tenPhong: itemBackend.tenPhong,
                                  trangThai: itemBackend.trangThai,
                                  moTa: itemBackend.moTa,
                                  maLoaiPhong: itemBackend.maLoaiPhong,
                                );
                                final currentLoaiPhong = LoaiPhong(
                                  maLoaiPhong:
                                      itemBackend.loaiPhong.maLoaiPhong,
                                  tenLoaiPhong:
                                      itemBackend.loaiPhong.tenLoaiPhong,
                                  dienTich: itemBackend.loaiPhong.dienTich,
                                  isMayLanh: itemBackend.loaiPhong.isMayLanh,
                                  soNguoiToiDa:
                                      itemBackend.loaiPhong.soNguoiToiDa,
                                  giaTien: itemBackend
                                      .loaiPhong
                                      .giaTien, // item phòng phải hiển thị giá loại phòng lên
                                );
                                return ItemPhong(
                                  phong: currentPhong,
                                  loaiPhong: currentLoaiPhong,
                                  soNguoiHienTai: itemBackend.soNguoiHienTai,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhongChiTiet(room: itemBackend),
                                      ),
                                    );
                                  },
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => vm.setFilter(filter),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5.5),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
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
