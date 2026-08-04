import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/nguoi_luu_tru_tam_thoi_provider.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/utils/string_formatter.dart';
import '../../../../../models/nguoi_luu_tru_tam_thoi.dart';
import '../../../../models/hop_dong.dart';
import '../../../../modelviews/MainPage/NguoiThuePage/NguoiLuuTruTamThoiPage/NguoiLuuTruTamThoiPageViewModel.dart';
import '../../../../widgets/app_confirm_dialog.dart';
import '../NguoiLuuTruTamThoiForm/NguoiLuuTruTamThoiForm.dart';

class LuuTruTamThoiPage extends StatefulWidget {
  final int idnt;
  final String? tenNguoiThue;
  final List<HopDong> dsHopDong;

  const LuuTruTamThoiPage({
    super.key,
    required this.idnt,
    this.tenNguoiThue,
    this.dsHopDong = const [],
  });

  @override
  State<LuuTruTamThoiPage> createState() => _LuuTruTamThoiPageState();
}

class _LuuTruTamThoiPageState extends State<LuuTruTamThoiPage> {
  late LuuTruTamThoiViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = LuuTruTamThoiViewModel(
      context.read<NguoiLuuTruTamThoiProvider>(),
      widget.idnt,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.getDanhSach();
    });
  }

  void _onAddNew() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NguoiLuuTruTamThoiForm(
          idnt: widget.idnt,
          tenNguoiThue: widget.tenNguoiThue,
          dsHopDong: widget.dsHopDong,
        ),
      ),
    );

    if (result == true) {
      vm.getDanhSach();
    }
  }

  void _onEditItem(NguoiLuuTruTamThoi item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NguoiLuuTruTamThoiForm(
          idnt: widget.idnt,
          tenNguoiThue: widget.tenNguoiThue,
          dsHopDong: widget.dsHopDong,
          itemEdit: item,
        ),
      ),
    );

    if (result == true) {
      vm.getDanhSach();
    }
  }

  String _getTenPhong(int? phongId) {
    if (phongId == null) return "";
    try {
      final hd = widget.dsHopDong.firstWhere((e) => e.phongID == phongId);
      final ten = hd.phong?.tenPhong;
      if (ten != null && ten.isNotEmpty) {
        return "P$ten";
      }
    } catch (_) {}
    return "P$phongId";
  }

  void _showConfirmDeleteDialog(NguoiLuuTruTamThoi item) {
    if (item.idtt == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: "Xóa lưu trú tạm thời",
        content:
            "Bạn có chắc chắn muốn xóa thông tin lưu trú của \"${item.hoTen ?? 'người này'}\" không? Thao tác này không thể hoàn tác.",
        textConfirm: "Xóa ngay",
        textCancel: "Hủy",
        isDangerous: true,
        onConfirm: () async {
          Navigator.pop(ctx);

          try {
            final success = await vm.deleteLuuTru(item.idtt!);
            if (success && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Đã xóa người lưu trú tạm thời thành công"),
                  backgroundColor: Color(0xff437648),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceFirst('Exception: ', '')),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lưu trú tạm thời",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xff1C1C1E),
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Người thân / bạn bè ở ngắn ngày",
              style: TextStyle(
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
                  onPressed: _onAddNew,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff437648),
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
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff437648)),
              ),
            );
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vm.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => vm.getDanhSach(),
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            );
          }

          if (vm.dsLuuTru.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.groups_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Chưa có thông tin người lưu trú tạm thời",
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffEFEFEF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.dsLuuTru.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffF2F2F7),
                ),
                itemBuilder: (context, index) {
                  final item = vm.dsLuuTru[index];
                  return InkWell(
                    onTap: () => _onEditItem(item),
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(20) : Radius.zero,
                      bottom: index == vm.dsLuuTru.length - 1
                          ? const Radius.circular(20)
                          : Radius.zero,
                    ),
                    child: _buildItemLuuTru(item, index),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemLuuTru(NguoiLuuTruTamThoi item, int index) {
    final bool isDangO = item.isDangO;

    final String moiQuanHeText = item.moiQuanHe ?? "Người thân";
    final String tenPhongText = _getTenPhong(item.phongId);
    final String subTitleText = tenPhongText.isNotEmpty
        ? "$moiQuanHeText · $tenPhongText"
        : moiQuanHeText;

    final String chuoiNgayDen = formatDate(item.ngayDen);
    final String chuoiNgayVe = formatDate(item.ngayVe);

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xffDCE8FF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              vietTat(item.hoTen ?? ""),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xff2563EB),
              ),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.hoTen ?? "Chưa rõ tên",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1C1C1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subTitleText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff8E8E93),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$chuoiNgayDen → $chuoiNgayVe",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff8E8E93),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDangO
                  ? const Color(0xffEAF5ED)
                  : const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.trangThaiText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDangO
                    ? const Color(0xff2D7A3A)
                    : const Color(0xff8E8E93),
              ),
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Color(0xff8E8E93),
              size: 20,
            ),
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _onEditItem(item);
              } else if (value == 'delete') {
                _showConfirmDeleteDialog(item);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                height: 40,
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Color(0xff1C1C1E),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Chỉnh sửa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                height: 40,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Xóa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
