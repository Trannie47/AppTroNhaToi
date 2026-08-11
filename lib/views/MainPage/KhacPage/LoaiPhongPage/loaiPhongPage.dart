import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/Provider/loai_phong_provider.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';

import '../../../../modelviews/MainPage/KhacPage/LoaiPhongPage/loaiPhongPageViewModel.dart';
import '../../../../widgets/app_confirm_dialog.dart';
import '../../PhongPage/FormLoaiPhong/FormLoaiPhong.dart';

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
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormLoaiPhong(),
                  ),
                );
                await vm.loadDataInitial();
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text(
                "Thêm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => vm.loadDataInitial(),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text(
                "Thử lại",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),

      LoaiPhongSuccess(listLoaiPhong: final dsLoai) =>
        dsLoai.isEmpty
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
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
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D7A3A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _infoBadge(Icons.square_foot_rounded, "${item.dienTich.toInt()} m²"),
                const SizedBox(width: 14),
                _infoBadge(Icons.people_outline_rounded, "Tối đa ${item.soNguoiToiDa} người"),
                const SizedBox(width: 14),
                _infoBadge(
                  item.isMayLanh ? Icons.ac_unit_rounded : Icons.air_rounded,
                  item.isMayLanh ? 'Có máy lạnh' : 'Không máy lạnh',
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _miniThongKe(
                  label: "Tổng",
                  value: item.tongSoPhong,
                  bg: const Color(0xffF3F4F6),
                  color: Colors.black87,
                ),
                const SizedBox(width: 8),
                _miniThongKe(
                  label: "Trống",
                  value: item.soPhongTrong,
                  bg: const Color(0xffEAF3EB),
                  color: const Color(0xFF2D7A3A),
                ),
                const SizedBox(width: 8),
                _miniThongKe(
                  label: "Đang thuê",
                  value: item.soPhongDangThue,
                  bg: const Color(0xffFFF7ED),
                  color: const Color(0xffFF8A00),
                ),
                const SizedBox(width: 8),
                _miniThongKe(
                  label: "Đang sửa",
                  value: item.soPhongDangSua,
                  bg: const Color(0xffFEF2F2),
                  color: Colors.red.shade600,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF1F3F2)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormLoaiPhong(loaiPhong: item),
                      ),
                    );
                    await vm.loadDataInitial();
                  },
                  icon: const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF2D7A3A)),
                  label: const Text(
                    "Chỉnh sửa",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D7A3A),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFFEAF3EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AppConfirmDialog(
                          title: "Ẩn loại phòng",
                          content:
                          "Bạn có chắc chắn muốn ẩn loại phòng '${item.tenLoaiPhong}' này không?",
                          textConfirm: "Ẩn đi",
                          textCancel: "Hủy",
                          isDangerous: true,
                          onConfirm: () async {
                            Navigator.pop(dialogContext);

                            final errorMsg = await vm.deleteLoaiPhongProcess(
                              item.maLoaiPhong,
                            );

                            if (!mounted) return;

                            if (errorMsg != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMsg),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Ẩn loại phòng thành công!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.visibility_off_outlined, size: 15, color: Colors.red),
                  label: const Text(
                    "Ẩn",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xffFEF2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _miniThongKe({
    required String label,
    required int value,
    required Color bg,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              "$value",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
