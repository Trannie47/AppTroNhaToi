import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietLichSuMuaThietBiPage/chiTietLichSuMuaThietBiPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuMuaThietBiForm/LichSuMuaThietBiForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChiTietLichSuMuaThietBiPage extends StatefulWidget {
  final LichSuMuaThietBi lichSuMua;
  final ThietBi thietBi;

  const ChiTietLichSuMuaThietBiPage({
    super.key,
    required this.lichSuMua,
    required this.thietBi,
  });

  @override
  State<ChiTietLichSuMuaThietBiPage> createState() =>
      _ChiTietLichSuMuaThietBiPageState();
}

class _ChiTietLichSuMuaThietBiPageState
    extends State<ChiTietLichSuMuaThietBiPage> {
  late ChiTietLichSuMuaThietBiPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ChiTietLichSuMuaThietBiPageViewModel();

    vm.init(widget.lichSuMua, widget.thietBi);

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  Future<void> capNhatThongTin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (dialogContext) => ChangeNotifierProvider.value(
          value: context.read<LichSuMuaThietBiProvider>(),
          child: LichSuMuaThietBiForm(
            lichSuMua: vm.lichSuMua,
            thietBi: widget.thietBi,
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (result is LichSuMuaThietBi) {
      setState(() {
        vm.lichSuMua = result;
      });
    }
  }

  Future<void> xoaChiTiet() async {
    if (!mounted) return;

    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Ẩn lịch sử mua"),
          content: const Text(
            "Bạn có chắc muốn ẩn lịch sử mua này không?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text("Ẩn"),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (xacNhan != true) return;

    try {
      final provider = context.read<LichSuMuaThietBiProvider>();

      final ok = await provider.xoa(
        vm.lichSuMua.id!,
        vm.lichSuMua.thietBiID!,
      );

      if (!mounted) return;

      if (ok) {
        Navigator.of(context).pop(true);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ẩn lịch sử mua thất bại"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Widget _infoRow(
    String title,
    String value, {
    Color? color,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey.shade500)),
          ),

          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2D7A3A),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ngayMua = vm.ngayMua;
    final now = DateTime.now();

    final hienBaCham =
        ngayMua != null &&
            ngayMua.year == now.year &&
            ngayMua.month == now.month;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,

        leadingWidth: 52,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, color: Colors.black),
            ),
          ),
        ),

        titleSpacing: 12,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chi Tiết Mua Thiết Bị",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              vm.tenThietBi,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          if (hienBaCham)
            PopupMenuButton<String>(
              color: Colors.white,
              elevation: 8,
              offset: const Offset(0, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              onSelected: (value) {
                switch (value) {
                  case "update":
                    capNhatThongTin();
                    break;

                  case "delete":
                    xoaChiTiet();
                    break;
                }
              },

              icon: const Icon(Icons.more_vert),

              itemBuilder: (context) => [
                if (vm.duocCapNhat)
                  PopupMenuItem<String>(
                    value: "update",
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xff2D7A3A),
                      ),
                      title: const Text("Cập nhật thông tin"),
                      subtitle: const Text("Số lượng, đơn giá, ngày mua"),
                    ),
                  ),

                if (vm.duocCapNhat)
                  PopupMenuItem<String>(
                    value: "delete",
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Ẩn chi tiết",
                        style: TextStyle(color: Colors.red),
                      ),
                      subtitle: const Text(
                        "Không thể hoàn tác",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            _section(
              title: "Thông tin mua hàng",
              child: Column(
                children: [
                  _infoRow("Số lượng", "${vm.soLuong}"),

                  _infoRow("Đơn giá", formatMoney(vm.donGia)),

                  _infoRow(
                    "Thành tiền",
                    formatMoney(vm.soLuong * vm.donGia),
                    color: const Color(0xff2D7A3A),
                  ),

                  _infoRow("Ngày mua", formatDate(vm.ngayMua)),

                  _infoRow(
                    "Ghi chú",
                    vm.ghiChu.isNotEmpty ? vm.ghiChu : "Không có",
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
