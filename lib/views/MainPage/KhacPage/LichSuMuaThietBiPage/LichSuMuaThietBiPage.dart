import 'package:AppTroNhaToi/Provider/lich_su_Them_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/LichSuMuaThietBiPage/LichSuMuaThietBiPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuMuaThietBiForm/LichSuMuaThietBiForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietLichSuMuaThietBiPage/chiTietLichSuMuaThietBiPage.dart';
import 'package:AppTroNhaToi/widgets/itemLichSuMuaThietBi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LichSuMuaThietBiPage extends StatefulWidget {
  final ThietBi thietBi;

  const LichSuMuaThietBiPage({super.key, required this.thietBi});

  @override
  State<LichSuMuaThietBiPage> createState() => _LichSuMuaThietBiPageState();
}

class _LichSuMuaThietBiPageState extends State<LichSuMuaThietBiPage> {
  late LichSuMuaThietBiPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = LichSuMuaThietBiPageViewModel(
      thietBi: widget.thietBi,
      lichSuMuaThietBiProvider: context.read<LichSuMuaThietBiProvider>(),
    );

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  /// Thêm lịch sử mua
  Future<void> taoMoi(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<LichSuMuaThietBiProvider>(),
          child: LichSuMuaThietBiForm(thietBi: vm.thietBi),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              "Lịch sử mua thiết bị",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.thietBi.tenThietBi ?? "",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: () => taoMoi(context),
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: vm.txtSearch,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: "Ghi chú",
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                itemCount: vm.lichSuMuaThietBi.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = vm.lichSuMuaThietBi[index];

                  return ItemLichSuMuaThietBi(
                    lichSu: item,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: context.read<LichSuMuaThietBiProvider>(),
                            child: ChiTietLichSuMuaThietBiPage(
                              lichSuMua: item,
                              thietBi: widget.thietBi,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
