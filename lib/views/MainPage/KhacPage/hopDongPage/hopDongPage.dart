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
      vm.loadList();
    });
  }
  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  String tuKhoa = "";



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
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: SizedBox(
                      height: 38,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _itemFilter(
                              filter: -1,
                              text: "Tất cả (${vm.listHD.length})",
                              bgColor: const Color(0xFFF5F5F5),
                              textColor: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            _itemFilter(
                              filter: 1,
                              text: "Hiệu lực (${vm.listHDHieuLuc.length})",
                              bgColor: const Color(0xffE8F5E9),
                              textColor: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            _itemFilter(
                              filter: 0,
                              text: "Khởi tạo (${vm.listHDKhoiTao.length})",
                              bgColor: const Color(0xffFEF3C7),
                              textColor: const Color(0xffD97706),
                            ),
                            const SizedBox(width: 8),
                            _itemFilter(
                              filter: 2,
                              text: "Đã kết thúc (${vm.listHDKetThuc.length})",
                              bgColor: const Color(0xffFFEBEE),
                              textColor: Colors.red,
                            ),
                          ],
                        ),
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

                HopDongSuccess(data: final _) => (() {
                  final dsTheoTab = vm.listHDHienThi;

                  final dsHienThi = dsTheoTab.where((hd) {
                    if (tuKhoa.isEmpty) return true;

                    final tenNguoiThue = hd.nguoithue.hoTen.toLowerCase();
                    final tenPhong = hd.phong.tenPhong.toLowerCase();
                    final maHD = hd.hopDongID.toLowerCase();

                    return tenNguoiThue.contains(tuKhoa) ||
                        tenPhong.contains(tuKhoa) ||
                        maHD.contains(tuKhoa);
                  }).toList();

                  return dsHienThi.isEmpty
                      ? const Center(child: Text("Không có hợp đồng nào."))
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: dsHienThi.length,
                    itemBuilder: (context, index) {
                      final itemHD = dsHienThi[index];
                      return ItemNTHopDong(
                        hopDong: itemHD,
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
                  );
                })(),

                HopDongInitial() => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _itemFilter({
    required int filter,
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    final isSelected = vm.currentFilter == filter;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? textColor : bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => vm.setFilter(filter),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}