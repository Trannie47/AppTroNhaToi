import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePageViewModel.dart';
import 'package:AppTroNhaToi/widgets/itemHoaDonGuiXe.dart';
import 'package:flutter/material.dart';

class HoaDonGuiXePage extends StatefulWidget {
  final List<PhuongTien> dsPhuongTien;

  const HoaDonGuiXePage({super.key, required this.dsPhuongTien});

  @override
  State<HoaDonGuiXePage> createState() => _HoaDonGuiXePageState();
}

class _HoaDonGuiXePageState extends State<HoaDonGuiXePage> {
  late HoaDonGuiXePageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = HoaDonGuiXePageViewModel(dsPhuongTien: widget.dsPhuongTien);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Hóa đơn gửi xe",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1C1C1E),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "Nguyễn Văn An • ${vm.tongSoXe} xe",

                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// THỐNG KÊ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [
                  /// XE
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: const Color(0xffEAF7EC),

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_bike_rounded,

                                color: Color(0xff2D7A3A),

                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                "${vm.tongSoXe} xe",

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2D7A3A),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${vm.tongTienThang.toStringAsFixed(0)}đ/tháng",

                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// NỢ
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: const Color(0xffFFF3E8),

                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.attach_money_rounded,

                                color: Color(0xffF08A24),

                                size: 18,
                              ),

                              SizedBox(width: 5),

                              Text(
                                "Còn nợ",

                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffF08A24),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            vm.textNo,

                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DANH SÁCH
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Lịch sử hóa đơn",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2D7A3A),
                            ),
                          ),
                        ),

                        /// DROPDOWN
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 2,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xffF4F5F7),

                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: vm.namDangChon,

                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                              ),

                              borderRadius: BorderRadius.circular(18),

                              style: const TextStyle(
                                fontSize: 13,

                                fontWeight: FontWeight.w600,

                                color: Color(0xff1C1C1E),
                              ),

                              items: vm.dsNam.map((nam) {
                                return DropdownMenuItem(
                                  value: nam,

                                  child: Text(nam),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  vm.namDangChon = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// LIST
                    Expanded(
                      child: ListView.separated(
                        itemCount: vm.dsHoaDonTheoNam.length,

                        separatorBuilder: (_, __) =>
                            const Divider(height: 26, color: Color(0xffF1F1F1)),

                        itemBuilder: (context, index) {
                          final hoaDon = vm.dsHoaDonTheoNam[index];

                          final xe = vm.getXeTheoHoaDon(hoaDon);

                          if (xe == null) {
                            return const SizedBox();
                          }

                          return ItemHoaDonGuiXe(
                            hoaDon: hoaDon,

                            phuongTien: xe,

                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
