import 'dart:ui';

import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietLichSuSuaChuaPage/chiTietLichSuSuaChuaPage.dart';
import 'package:AppTroNhaToi/widgets/itemLichSuSuaChua.dart';
import 'package:flutter/material.dart';

class LichSuSuaChuaPage extends StatefulWidget {
  final ThietBi thietBi;

  const LichSuSuaChuaPage({super.key, required this.thietBi});

  @override
  State<LichSuSuaChuaPage> createState() => _LichSuSuaChuaPageState();
}

class _LichSuSuaChuaPageState extends State<LichSuSuaChuaPage> {
  late LichSuSuaChuaPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = LichSuSuaChuaPageViewModel();

    vm.init(widget.thietBi);

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

  //Thêm Phiếu Sửa chữa
  void taoMoi(BuildContext context) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhieuSuaChuaForm(thietBi: vm.thietBi)),
    );

    if (result == true) {
      //
    }
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
              "Lịch sử sửa chữa",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              "${widget.thietBi.tenThietBi} - ${101}",
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
          /// Search
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white),

            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: vm.txtSearch,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Nguyên nhân",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.separated(
                itemCount: vm.lichSuSuaChua.length,

                separatorBuilder: (_, __) => const SizedBox(height: 14),

                itemBuilder: (context, index) {
                  final item = vm.lichSuSuaChua[index];

                  return ItemLichSuSuaChua(
                    suaChua: item.suaChua!,
                    hoaDonSuaChua: item.hoaDonSuaChua,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChiTietLichSuSuaChuaPage(
                            suaChua: item.suaChua!,
                            hoaDonSuaChua: item.hoaDonSuaChua,
                            thietBi: widget.thietBi,
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
