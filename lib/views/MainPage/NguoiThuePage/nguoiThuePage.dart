import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/nguoiThuePage.dart';
import 'package:AppTroNhaToi/view_models/hopdong_view_model.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/widgets/itemNguoiThue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/nguoi_thue_provider.dart';
import 'ChiTietNguoiThuePage/chiTietNguoiThuePage.dart';

class NguoiThuePage extends StatefulWidget {
  const NguoiThuePage({super.key});

  @override
  State<NguoiThuePage> createState() => _NguoiThuePageState();
}

class _NguoiThuePageState extends State<NguoiThuePage> {
  late NguoiThuePageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = NguoiThuePageViewModel(context.read<NguoiThueProvider>());
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    vm.refresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toChiTietNguoiThue(NguoiThue nt) async {
    final check = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiTietNguoiThuePage(nguoiThue: nt),
      ),
    );
    if ((check == true || check != null) && mounted) {
      vm.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listNguoiThue = vm.listNguoiThue;
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Người thuê",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1C1C1E),
                    ),
                  ),

                  Row(
                    children: [
                      /// ADD
                      GestureDetector(
                        onTap: () async {
                          final check = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const NguoiThueForm();
                              },
                            ),
                          );
                          if (check != null && mounted) {
                            vm.refresh();
                          }
                        },

                        child: Image.asset(
                          "assets/images/add.png",
                          width: 40,
                          height: 40,
                        ),
                      ),

                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),

              child: Container(
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),

                  borderRadius: BorderRadius.circular(12),
                ),

                alignment: Alignment.center,

                child: TextField(
                  controller: vm.searchController,

                  textAlignVertical: TextAlignVertical.center,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    isDense: true,

                    contentPadding: const EdgeInsets.symmetric(vertical: 10),

                    hintText: "Tìm tên, SDT, CCCD...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,

                      fontSize: 13,
                    ),

                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listNguoiThue.length,
                itemBuilder: (context, index) {
                  final tagetNguoiThue = listNguoiThue[index];
                  return ItemNguoiThue(
                    nguoiThue: listNguoiThue[index],
                    onTap: () => toChiTietNguoiThue(tagetNguoiThue),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
