import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/widgets/itemHoaDonGuiXe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/hoa_don_gui_xe_provider.dart';
import '../../../../modelviews/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePageViewModel.dart';

class HoaDonGuiXePage extends StatefulWidget {
  final List<PhuongTien> dsPhuongTien;
  final String tenKhachThue;

  const HoaDonGuiXePage({
    super.key,
    required this.dsPhuongTien,
    required this.tenKhachThue,
  });

  @override
  State<HoaDonGuiXePage> createState() => _HoaDonGuiXePageState();
}

class _HoaDonGuiXePageState extends State<HoaDonGuiXePage> {
  late HoaDonGuiXePageViewModel vm;

  @override
  void initState() {
    super.initState();
    final provider = context.read<HoaDonGuiXeProvider>();
    vm = HoaDonGuiXePageViewModel(
      dsPhuongTien: widget.dsPhuongTien,
      provider: provider,
      tenKhachThue: widget.tenKhachThue,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xff1C1C1E),
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
                          "${vm.tenKhachThue} • ${vm.tongSoXe} xe",
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

            /// THỐNG KÊ (CARD XE & NỢ)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
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
                              const SizedBox(width: 6),
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                              SizedBox(width: 6),
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
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DANH SÁCH HÓA ĐƠN
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF4F5F7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: vm.dsNam.contains(vm.namDangChon)
                                  ? vm.namDangChon
                                  : (vm.dsNam.isNotEmpty
                                        ? vm.dsNam.first
                                        : null),
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
                                if (value != null) {
                                  vm.changeYear(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(color: Color(0xffF1F1F1), height: 1),
                    const SizedBox(height: 10),

                    Expanded(
                      child: vm.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff2D7A3A),
                              ),
                            )
                          : vm.dsHoaDonTheoNam.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Không có hóa đơn năm ${vm.namDangChon}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: vm.dsHoaDonTheoNam.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 22,
                                color: Color(0xffF1F1F1),
                              ),
                              itemBuilder: (context, index) {
                                final hoaDon = vm.dsHoaDonTheoNam[index];
                                final xe = vm.getXeTheoHoaDon(hoaDon);

                                return ItemHoaDonGuiXe(
                                  hoaDon: hoaDon,
                                  phuongTien: xe,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
