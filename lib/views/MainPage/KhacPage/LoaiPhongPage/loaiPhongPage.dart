import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/Provider/loai_phong_provider.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';

import '../../../../modelviews/MainPage/KhacPage/LoaiPhongPage/loaiPhongPageViewModel.dart';

class LoaiPhongPage extends StatefulWidget {
  const LoaiPhongPage({super.key});

  @override
  State<LoaiPhongPage> createState() => _LoaiPhongPageState();
}

class _LoaiPhongPageState extends State<LoaiPhongPage> {
  late LoaiPhongPageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = LoaiPhongPageViewModel(context.read<LoaiPhongProvider>());

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.loadDataInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Loại phòng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text(
                "Thêm",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D7A3A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return switch (vm.loaiphongState) {
      LoaiPhongLoading() => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7A3A)),
        ),
      ),

      LoaiPhongError(messageError: final msg) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 36),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Lỗi: $msg",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.08),
                foregroundColor: Colors.red.shade700,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => vm.loadDataInitial(),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text("Thử lại", style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),

      LoaiPhongSuccess(listLoaiPhong: final dsLoai) => dsLoai.isEmpty
          ? const Center(
        child: Text(
          "Chưa có loại phòng nào dưới hệ thống.",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        itemCount: dsLoai.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _buildLoaiPhongCard(context, dsLoai[index]),
          );
        },
      ),
    };
  }

  Widget _buildLoaiPhongCard(BuildContext context, LoaiPhong item) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần thông tin
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.tenLoaiPhong,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      currencyFormat.format(item.giaTien),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D7A3A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "${item.dienTich.toInt()} m²  •  Tối đa ${item.soNguoiToiDa} người  •  ${item.isMayLanh ? 'Có máy lạnh' : 'Không máy lạnh'}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

          // Thanh xám chức năng ở đáy card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    //Xử lý sửa loại phòng
                  },
                  child: const Text(
                    "Sửa",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D7A3A),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    //Xử lý xóa loại phòng
                  },
                  child: const Text(
                    "Xóa",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}