import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/danhsachnguoithuepage/DanhSachNguoiThuePage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/ChiTietNguoiThuePage/chiTietNguoiThuePage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/widgets/itemNguoiThue.dart';
import 'package:flutter/material.dart';

class DanhSachNguoiThuePage extends StatefulWidget {
  const DanhSachNguoiThuePage({super.key});

  @override
  State<DanhSachNguoiThuePage> createState() => _DanhSachNguoiThuePageState();
}

class _DanhSachNguoiThuePageState extends State<DanhSachNguoiThuePage> {
   late  DanhSachNguoiThuePageViewModel vm;
  
   @override
  void initState() {
    super.initState();

    vm = DanhSachNguoiThuePageViewModel();

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

  /// THÊM NGƯỜI THUÊ
  void toThemNguoiThue() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NguoiThueForm();
        },
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
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),

              child: Row(
                children: [
                  /// BACK
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(
                      width: 34,
                      height: 34,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// TITLE
                  const Expanded(
                    child: Text(
                      "Danh sách người thuê",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  /// ADD
                  GestureDetector(
                    onTap: toThemNguoiThue,

                    child: SizedBox(
                      width: 40,
                      height: 40,

                      child: Image.asset(
                        "assets/images/add.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Container(
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: TextField(
                  controller: vm.searchController,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    hintText: "Tìm tên, SDT, CCCD...",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),

                    contentPadding: const EdgeInsets.only(top: 10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// THỐNG KÊ
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  _itemThongKe(
                    title: "${vm.tong}",
                    subTitle: "Tổng (chính + ghép)",
                    color: const Color(0xff222222),
                  ),

                  _divider(),

                  _itemThongKe(
                    title: "${vm.thueChinh}",
                    subTitle: "Thuê chính",
                    color: const Color(0xff2D8B47),
                  ),

                  _divider(),

                  _itemThongKe(
                    title: "${vm.oGhep}",
                    subTitle: "Ở ghép",
                    color: const Color(0xff222222),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                itemCount: vm.danhSachNguoiThue.length,

                itemBuilder: (context, index) {
                  return ItemNguoiThue(
                    nguoiThue: vm.danhSachNguoiThue[index].nguoiThue,

                    phong: vm.danhSachNguoiThue[index].phong.first,

                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => ChiTietNguoiThuePage(
                            nguoiThue: vm.danhSachNguoiThue[index].nguoiThue,

                            dsPhong: vm.danhSachNguoiThue[index].phong,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 65, color: const Color(0xffEEEEEE));
  }

  Widget _itemThongKe({
    required String title,
    required String subTitle,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),

        child: Column(
          children: [
            Text(
              title,

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subTitle,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 10,
                color: Color(0xff999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //end
}
