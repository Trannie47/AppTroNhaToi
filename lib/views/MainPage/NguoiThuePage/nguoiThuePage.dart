import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/nguoiThuePage.dart';
import 'package:AppTroNhaToi/view_models/hopdong_view_model.dart';
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

  late NguoithueViewModel nguoithueViewModel;

  @override
  void initState() {
    super.initState();
    //khởi tạo kích hoạt api lấy dữ liệu list người thuê về
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<NguoithueViewModel>(context, listen: false);
      nguoithueViewModel = vm;
      vm.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      vm.fetchAllNguoiThue();

    });


  }
  @override
  void dispose() {
    super.dispose();
  }
  void toChiTietNguoiThue(NguoiThue nt) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
            create: (_) => HopdongViewModel(),
            child:  ChiTietNguoiThuePage(nguoiThue: nt),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    nguoithueViewModel= Provider.of<NguoithueViewModel>(context);
    final listNguoiThue= nguoithueViewModel.listNguoithu;
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
                  controller: nguoithueViewModel.searchController,

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
                  final tagetNguoiThue= listNguoiThue[index];
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
