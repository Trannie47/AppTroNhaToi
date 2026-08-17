import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPage.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongFormDialog.dart';
import 'package:AppTroNhaToi/widgets/ItemLapRap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LapRapPage extends StatefulWidget {
  final int phongId;
  final int thietBiId;

  const LapRapPage({super.key, required this.phongId, required this.thietBiId});

  @override
  State<LapRapPage> createState() => _LapRapPageState();
}

class _LapRapPageState extends State<LapRapPage> {
  late LapRapPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = LapRapPageViewModel(
      phongId: widget.phongId,
      thietBiId: widget.thietBiId,
      provider: context.read<LapRapProvider>(),
    );

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.refresh();
    });
  }

  Future<void> _moDialogThemThietBi() async {
    final tenThietBi = vm.dsLapRap.isNotEmpty
        ? vm.dsLapRap.first.lapRap.thietBi?.tenThietBi
        : null;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ThietBiPhongFormDialog(
        phongId: widget.phongId,
        thietBiIdCoDinh: widget.thietBiId,
        tenThietBiCoDinh: tenThietBi,
        onCreate: (thietBiId, ngayLap, ghiChu) =>
            vm.themThietBi(ghiChu: ghiChu, ngayLap: ngayLap),
        onUpdate: (item, ngayLap, ghiChu) =>
            vm.capNhatThietBi(item: item, ghiChu: ghiChu, ngayLap: ngayLap),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm thiết bị thành công!"),
          backgroundColor: Color(0xff2D7A3A),
        ),
      );
      await vm.refresh();
    }
  }

  Future<void> _moDialogSuaThietBi(LapRap item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ThietBiPhongFormDialog(
        phongId: widget.phongId,
        item: item,
        onUpdate: (item, ngayLap, ghiChu) =>
            vm.capNhatThietBi(item: item, ghiChu: ghiChu, ngayLap: ngayLap),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cập nhật thiết bị thành công!"),
          backgroundColor: Color(0xff2D7A3A),
        ),
      );
      await vm.refresh();
    }
  }

  Future<void> _moLichSuSuaChua(LapRap item) async {
    if (item.thietBi == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => SuaChuaProvider())],
          child: LichSuSuaChuaPage(thietBi: item.thietBi!, lapRap: item),
        ),
      ),
    );

    if (!mounted) return;
    await vm.refresh();
  }
  Future<void> _xacNhanXoaThietBi(LapRap item) async {
    final xacNhan = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Xác nhận xóa",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            "Bạn có chắc muốn xóa lịch sử lắp ráp này không?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );

    if (xacNhan != true) return;

    await vm.xoaThietBi(item);
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Lịch sử lắp ráp",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _moDialogThemThietBi();
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xff2D7A3A),
            ),
          ),
        ],
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.dsLapRap.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Chưa có lịch sử lắp ráp",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Nhấn dấu + ở góc trên bên phải để thêm thiết bị.",
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

              itemCount: vm.dsLapRap.length,

              separatorBuilder: (_, __) => const SizedBox(height: 12),

              itemBuilder: (_, index) {
                final item = vm.dsLapRap[index];

                return ItemLapRap(
                  lapRap: item.lapRap,

                  trangThai: item.trangThai ?? 0,

                  onClick: () => _moLichSuSuaChua(item.lapRap),

                  edit: () {
                    _moDialogSuaThietBi(item.lapRap);
                  },
                  delete: () {
                    _xacNhanXoaThietBi(item.lapRap);
                  },
                );
              },
            ),
    );
  }
}
