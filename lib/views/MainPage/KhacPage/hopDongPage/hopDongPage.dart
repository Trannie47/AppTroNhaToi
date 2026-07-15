import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/HopDongForm/hopDongForm.dart';
import 'package:AppTroNhaToi/widgets/itemNTHopDong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/hop_dong_provider.dart';
import '../../../../modelviews/MainPage/KhacPage/hopDongPage/HopDongPageViewModel.dart';
import '../../../../states/hop_dong_state.dart';
import '../../../../widgets/app_error.dart';
import '../chiTietHopDongPage/chiTietHopDongPage.dart';

class HopDongPage extends StatefulWidget {
  HopDongPage({super.key});

  @override
  State<HopDongPage> createState() => _HopDongPageState();
}

class _HopDongPageState extends State<HopDongPage> {
  late HopDongPageViewModel vm;
  @override
  void initState(){
    super.initState();
    vm= HopDongPageViewModel(hopDongProvider: context.read<HopDongProvider>());
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      vm.loadListHD();
    });
  }
  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  String boLoc = "TAT_CA";
  String tuKhoa = "";

  String taoMaHopDong(DateTime ngayKy, int stt) {
    String ngay = ngayKy.day.toString().padLeft(2, '0');

    String thang = ngayKy.month.toString().padLeft(2, '0');

    String nam = ngayKy.year.toString();

    String soThuTu = stt.toString().padLeft(2, '0');

    return "$ngay$thang$nam$soThuTu";
  }


  void moTrangTaoHopDong() async{
   final result=await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HopDongForm()),
    );
   if (result == true && mounted) {
    vm.loadListHD();
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, size: 18),
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            'Hợp đồng',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1A1A1A),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: moTrangTaoHopDong,
                          child: Container(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xff2E7D32),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 18, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "Tạo mới",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            tuKhoa = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Tìm tên người thuê, phòng...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                boLoc = "TAT_CA";
                              });
                            },
                            child: _buildFilter(
                              title: "Tất cả (0)",
                              color: Colors.grey.shade700,
                              bgColor: const Color(0xFFF5F5F5),
                            ),
                          ),

                          const SizedBox(width: 8),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                boLoc = "HIEU_LUC";
                              });
                            },
                            child: _buildFilter(
                              title: "Hiệu lực (0)",
                              color: Colors.green,
                              bgColor: const Color(0xffE8F5E9),
                            ),
                          ),

                          const SizedBox(width: 8),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                boLoc = "SAP_HET_HAN";
                              });
                            },
                            child: _buildFilter(
                              title: "Sắp hết hạn (0)",
                              color: const Color(0xffD97706),
                              bgColor: const Color(0xffFEF3C7),
                            ),
                          ),

                          const SizedBox(width: 8),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                boLoc = "DA_KET_THUC";
                              });
                            },
                            child: _buildFilter(
                              title: "Đã kết thúc (0)",
                              color: Colors.red,
                              bgColor: const Color(0xffFFEBEE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: switch (vm.hopDongState) {
                HopDongLoading() => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2E7D32)),
                  ),
                ),

                HopDongError(errorMessage: final msg) =>
                    AppErrorWidget(
                        message: msg,
                        onRetry:(){
                          vm.loadListHD();
                        }
                    ),

                HopDongSuccess(data: final danhSach) => danhSach.isEmpty
                    ? const Center(child: Text("Không có hợp đồng nào."))
                    : ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  itemCount: danhSach.length,
                  itemBuilder: (context, index) {
                    final itemHD = danhSach[index];
                    return ItemNTHopDong(
                      hopDong: danhSach[index],
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChiTietHopDongPage(hopDong: itemHD),
                          ),
                        );
                        if (result == true && mounted) {
                          vm.loadListHD();
                        }
                      },
                    );
                  },
                ),

                HopDongInitial() => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter({
    required String title,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}