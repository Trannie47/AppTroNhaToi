import 'package:AppTroNhaToi/Provider/phieu_luan_chuyen_provider.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/luanChuyenPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ChiTietPhieuLuanChuyenPage/ChiTietPhieuLuanChuyenPage.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/phieuLuanChuyenForm.dart';
import 'package:AppTroNhaToi/widgets/itemPhieuLuanChuyen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhieuLuanChuyenPage extends StatefulWidget {
  final ItemPhong phong;

  const PhieuLuanChuyenPage({super.key, required this.phong});

  @override
  State<PhieuLuanChuyenPage> createState() => _PhieuLuanChuyenPageState();
}

class _PhieuLuanChuyenPageState extends State<PhieuLuanChuyenPage> {
  late PhieuLuanChuyenPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = PhieuLuanChuyenPageViewModel(
      context.read<PhieuLuanChuyenProvider>(),
      widget.phong,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.refesh();
    });
  }

  void _themPhieuLuanChuyen() async {
    final result = await Navigator.push<PhieuLuanChuyen>(
      context,
      MaterialPageRoute(
        builder: (_) => PhieuLuanChuyenForm(
          phongCuIdCoDinh: widget.phong.phongId,
          tenPhongCu: widget.phong.tenPhong,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm phiếu luân chuyển thành công!"),
          backgroundColor: Color(0xff2D7A3A),
        ),
      );
      await vm.refesh();
    }
  }

  void _suaPhieu(PhieuLuanChuyen item) async {
    final result = await Navigator.push<PhieuLuanChuyen>(
      context,
      MaterialPageRoute(
        builder: (_) => PhieuLuanChuyenForm(
          item: item,
          phongCuIdCoDinh: item.hopDong?.phongID ?? widget.phong.phongId,
          tenPhongCu: widget.phong.tenPhong,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật phiếu luân chuyển thành công!"),
          backgroundColor: Color(0xff2D7A3A),
        ),
      );
      await vm.refesh();
    }
  }

  void _xemChiTiet(PhieuLuanChuyen item) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChiTietPhieuLuanChuyenPage(item: item)),
    );
    await vm.refesh();
  }

  Future<void> _anPhieu(PhieuLuanChuyen item) async {
    if (item.chiTietLuanChuyenID == null) return;

    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn ẩn phiếu luân chuyển này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ẩn", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (xacNhan != true) return;

    try {
      await vm.anPhieu(item.chiTietLuanChuyenID!);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
              "Phiếu luân chuyển",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              widget.phong.tenPhong,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _themPhieuLuanChuyen,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2D7A3A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                "Thêm",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
        ],
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.dsPhieu.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.compare_arrows_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Chưa có phiếu luân chuyển",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Nhấn \"Thêm\" ở góc trên để tạo phiếu mới.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.dsPhieu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = vm.dsPhieu[index];
                return ItemPhieuLuanChuyen(
                  item: item,
                  phongCu: widget.phong,
                  edit: () => _suaPhieu(item),
                  onClick: () => _xemChiTiet(item),
                  delete: () => _anPhieu(item),
                );
              },
            ),
    );
  }
}
