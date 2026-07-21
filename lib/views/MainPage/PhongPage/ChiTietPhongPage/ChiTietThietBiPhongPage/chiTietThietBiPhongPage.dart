import 'package:AppTroNhaToi/Provider/lap_rap_thietbi_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/item_phong.dart';
import '../../../../../models/lap_rap.dart';
import '../../../../../modelviews/MainPage/PhongPage/ChiTietPhongPage/ChiTietThietBiPhongPage/chiTietThietBiPhongViewModel.dart';
import '../../../../../widgets/app_error.dart';
import 'ThemThietBiPhongDialog.dart';

class ChiTietThietBiPhongPage extends StatefulWidget {
  final ItemPhong room;

  const ChiTietThietBiPhongPage({
    super.key,
    required this.room,
  });

  @override
  State<ChiTietThietBiPhongPage> createState() =>
      _ChiTietThietBiPhongPageState();
}

class _ChiTietThietBiPhongPageState extends State<ChiTietThietBiPhongPage> {
  late ChiTietThietBiPhongViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ChiTietThietBiPhongViewModel(
      context.read<LapRapThietbiProvider>(),
      widget.room.phongId,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchThietBiByPhongId();
    });
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return "Chưa rõ";
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  IconData _getIconByLoai(String? loai) {
    if (loai == null) return Icons.devices_other_rounded;
    final l = loai.toLowerCase();
    if (l.contains('máy lạnh') || l.contains('điều hòa')) {
      return Icons.ac_unit_rounded;
    }
    if (l.contains('tủ lạnh')) return Icons.kitchen_rounded;
    if (l.contains('quạt')) return Icons.mode_fan_off_rounded;
    if (l.contains('bình') || l.contains('nóng lạnh')) {
      return Icons.water_drop_rounded;
    }
    return Icons.devices_other_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xff1C1C1E),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Thiết bị",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Phòng ${widget.room.tenPhong} · ${vm.dsLapRap.length} thiết bị",
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff8E8E93),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => ThemThietBiPhongDialog(
                        phongId: widget.room.phongId,
                      ),
                    );

                    if (!mounted) return;

                    // HIỂN THỊ THÔNG BÁO VÀ LOAD LẠI DANH SÁCH TẠI MÀN HÌNH CHÍNH
                    if (result == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Thêm thiết bị vào phòng thành công!"),
                          backgroundColor: Color(0xff2D7A3A),
                        ),
                      );
                      vm.fetchThietBiByPhongId();
                    } else if (result == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Thêm thiết bị thất bại, vui lòng thử lại!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2D7A3A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Thêm",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2D7A3A)),
              ),
            );
          }

          if (vm.errorMessage != null) {
            return AppErrorWidget(
              message: vm.errorMessage!,
              onRetry: () => vm.fetchThietBiByPhongId(),
            );
          }

          if (vm.dsLapRap.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices_other_rounded,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Phòng ${widget.room.tenPhong} hiện chưa có thiết bị nào",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            itemCount: vm.dsLapRap.length,
            itemBuilder: (context, index) {
              final item = vm.dsLapRap[index];
              return _buildItemThietBi(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemThietBi(LapRap item) {
    final tb = item.thietBi;
    final isTot = tb?.laTot ?? true;
    final statusColor =
    isTot ? const Color(0xff2D7A3A) : const Color(0xffD9534F);
    final iconBgColor =
    isTot ? const Color(0xffEEF5EF) : const Color(0xffFDF2F2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTot ? const Color(0xffEFEFEF) : const Color(0xffFADBD8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getIconByLoai(tb?.loai),
              color: statusColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tb?.tenThietBi ?? 'Chưa rõ tên',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1C1E),
                  ),
                ),
                const SizedBox(height: 3),

                Text(
                  "Loại: ${tb?.loai ?? 'Khác'} · Ngày lắp ${_formatDate(item.ngayLap)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff8E8E93),
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      tb?.trangThaiText ?? "Tốt",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Số lượng: ${item.soLuong ?? 1}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xffC7C7CC),
            size: 20,
          ),
        ],
      ),
    );
  }
}