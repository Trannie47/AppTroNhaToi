
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/TapHoaPageViewModel/TapHoaPageViewModel.dart';

import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThemHangHoa/ThemHangHoa.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoa.dart';
import 'package:flutter/material.dart';

class TapHoaPage extends StatefulWidget {
  const TapHoaPage({super.key});

  @override
  State<TapHoaPage> createState() => _TapHoaPageState();
}

class _TapHoaPageState extends State<TapHoaPage> {
  final vm = TapHoaPageViewModel();

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
        ),

        title: const Text(
          "Tạp hóa",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),


        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2D7A3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
              label: const Text(
                "Lập hóa đơn",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TAB
            Row(
              children: [
                _tabButton(
                  "Hàng hóa",
                  0,
                  const Color(0xffEAF5EC),
                  // const Color(0xff555555),
                  const Color(0xff2D7A3A),
                ),

                const SizedBox(width: 8),

                _tabButton(
                  "Công nợ (${vm.soCongNo})",
                  1,
                  const Color(0xffFFF0E0),
                  Colors.orange,
                ),

                const SizedBox(width: 8),

                _tabButton(
                  "Hóa đơn",
                  2,
                  const Color(0xffEEEEEE),
                  Colors.black87,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// THỐNG KÊ
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF4EE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tổng mặt hàng",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${vm.tongMatHang} loại",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2D7A3A),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF2F2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Công nợ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${vm.formatTien(vm.tongCongNo)}đ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DANH SÁCH HÀNG
            Expanded(
              child: ListView.builder(
                itemCount: vm.dsHangHoa.length,
                itemBuilder: (context, index) {
                  return ItemHangHoa(
                    hangHoa: vm.dsHangHoa[index],
                    tonKho: vm.getTonKho(vm.dsHangHoa[index]),
                    onSua: () async {

                      final HangHoa? hangHoaSua =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ThemHangHoa(
                            hangHoa: vm.dsHangHoa[index],
                          ),
                        ),
                      );

                      if (hangHoaSua != null) {

                        vm.dsHangHoa[index] = hangHoaSua;

                        vm.notifyListeners();
                      }
                    },
                    onXoa: () async {

                      bool? xacNhan = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text("Xóa hàng hóa"),
                            content: Text(
                              "Bạn có muốn xóa '${vm.dsHangHoa[index].tenHangHoa}' không?",
                            ),
                            actions: [

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text(
                                  "Hủy",
                                ),
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text(
                                  "Xóa",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (xacNhan == true) {
                        vm.xoaHangHoa(
                          vm.dsHangHoa[index].maHangHoa!,
                        );
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// THÊM HÀNG HÓA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () async {

                  final HangHoa? hangHoaMoi =
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ThemHangHoa(),
                    ),
                  );

                  if (hangHoaMoi != null) {

                    vm.dsHangHoa.add(hangHoaMoi);

                    vm.notifyListeners();
                  }
                },

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xffB9DDBF),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xff2D7A3A),
                ),
                label: const Text(
                  "Thêm hàng hóa mới",
                  style: TextStyle(
                    color: Color(0xff2D7A3A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
      String title,
      int index,
      Color bgColor,
      Color textColor,
      ) {
    bool selected = vm.currentTab == index;

    return GestureDetector(
      onTap: () {
        vm.changeTab(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? bgColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? textColor : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}