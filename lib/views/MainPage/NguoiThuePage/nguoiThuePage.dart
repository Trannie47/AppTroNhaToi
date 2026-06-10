import 'package:AppTroNhaToi/models/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/nguoiThuePage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/widgets/itemNguoiThue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/nguoithue_view_model.dart';
import 'ChiTietNguoiThuePage/chiTietNguoiThuePage.dart';

class NguoiThuePage extends StatefulWidget {
  const NguoiThuePage({super.key});


  @override
  State<NguoiThuePage> createState() => _NguoiThuePageState();
}

class _NguoiThuePageState extends State<NguoiThuePage> {
  late NguoiThuePageViewModel vm;
  late NguoithueViewModel nguoithueViewModel;

  @override
  void initState() {
    super.initState();

    vm = NguoiThuePageViewModel();
    nguoithueViewModel= Provider.of<NguoithueViewModel>(context, listen: false); //Nguồn dữ liệu list người thuê bên DB


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
  void toChiTietNguoiThue(NguoiThuePhong nt) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            ChiTietNguoiThuePage(nguoiThue: nt.nguoiThue, dsPhong: nt.phong),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) {
                                return const NguoiThueForm();
                              },
                            ),
                          );
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

                itemCount: vm.danhSachNguoiThue.length,

                itemBuilder: (context, index) {
                  return ItemNguoiThue(
                    nguoiThue: vm.danhSachNguoiThue[index].nguoiThue,

                    phong: vm.danhSachNguoiThue[index].phong.first,

                    onTap: () => toChiTietNguoiThue(vm.danhSachNguoiThue[index]),
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
