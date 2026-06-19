import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/TapHoaPageViewModel/TapHoaPageViewModel.dart';

import 'package:AppTroNhaToi/views/MainPage/KhacPage/HangHoaForm/HangHoaForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/HoaDonTapHoaForm/hoaDonTapHoaForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHoaDonTapHoa/chiTietHoaDonTapHoa.dart';
import 'package:AppTroNhaToi/widgets/itemCongNo.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoa.dart';
import 'package:AppTroNhaToi/widgets/itemHoaDonTapHoa.dart';
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

        toolbarHeight: 60,

        leadingWidth: 52,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 13,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Text(
          "Tạp hóa",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () async {
                final hoaDonMoi = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HoaDonTapHoaForm()),
                );

                if (hoaDonMoi != null) {
                  vm.themHoaDon(hoaDonMoi);
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2D7A3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: const Text(
                "Lập hóa đơn",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TAB
            Center(
              child: Row(
                children: [
                  _tabButton(
                    "Hàng hóa",
                    0,
                    const Color(0xffEAF3EB),
                    const Color(0xff2D7A3A),
                  ),

                  const SizedBox(width: 8),

                  _tabButton(
                    "Công nợ (${vm.soCongNo})",
                    1,
                    const Color(0xffFFF3E0),
                    const Color(0xffD97706),
                  ),

                  const SizedBox(width: 8),

                  _tabButton(
                    "Hóa đơn",
                    2,
                    const Color(0xffFDECEA),
                    const Color(0xffE53E3E),
                  ),
                ],
              ),
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
                            color: Color(0xff2D7A3A),
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
                            color: Color(0xffE53E3E),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${formatMoney(vm.tongCongNo)}",
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
                // itemCount: vm.currentTab == 0
                //     ? vm.dsHangHoa.length
                //     : vm.dsHoaDon.length,
                itemCount: vm.currentTab == 0
                    ? vm.dsHangHoa.length
                    : vm.currentTab == 2
                    ? vm.dsHoaDonTapHoa.length
                    : vm.dsCongNoTapHoa.length,

                itemBuilder: (context, index) {
                  /// HÀNG HÓA
                  if (vm.currentTab == 0) {
                    return ItemHangHoa(
                      hangHoa: vm.dsHangHoa[index],
                      tonKho: vm.getTonKho(vm.dsHangHoa[index]),

                      onSua: () async {
                        final HangHoa? hangHoaSua = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                HangHoaForm(hangHoa: vm.dsHangHoa[index]),
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
                              title: const Text("Xóa hàng hóa"),
                              content: Text(
                                "Bạn có muốn xóa '${vm.dsHangHoa[index].tenHangHoa}' không?",
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Hủy"),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (xacNhan == true) {
                          vm.xoaHangHoa(vm.dsHangHoa[index].maHangHoa!);
                        }
                      },
                    );
                  }

                  /// HÓA ĐƠN
                  if (vm.currentTab == 2) {
                    return ItemHoaDonTapHoa(
                      hoaDon: vm.dsHoaDonTapHoa[index].hoaDon,
                      phieuThu: vm.dsHoaDonTapHoa[index].phieuThu,
                      tenNguoiThue: vm.dsHoaDonTapHoa[index].tenNguoiMua,
                      onSua: () {},
                      onChiTiet: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChiTietHoaDonTapHoa(
                              hoaDon: vm.dsHoaDonTapHoa[index].hoaDon,
                              phieuThu: vm.dsHoaDonTapHoa[index].phieuThu,
                              tenNguoiMua: vm.dsHoaDonTapHoa[index].tenNguoiMua,
                            ),
                          ),
                        );
                      },
                      onXoa: () {},
                    );
                  }

                  if (vm.currentTab == 1) {
                    return ItemHoaDonTapHoa(
                      hoaDon: vm.dsCongNoTapHoa[index].hoaDon,
                      phieuThu: vm.dsCongNoTapHoa[index].phieuThu,
                      tenNguoiThue: vm.dsCongNoTapHoa[index].tenNguoiMua,
                      onSua: () {},
                      onChiTiet: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChiTietHoaDonTapHoa(
                              hoaDon: vm.dsHoaDonTapHoa[index].hoaDon,
                              phieuThu: vm.dsHoaDonTapHoa[index].phieuThu,
                              tenNguoiMua: vm.dsHoaDonTapHoa[index].tenNguoiMua,
                            ),
                          ),
                        );
                      },
                      onXoa: () {},
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            /// THÊM HÀNG HÓA
            if (vm.currentTab == 0)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final HangHoa? hangHoaMoi = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HangHoaForm()),
                    );

                    if (hangHoaMoi != null) {
                      vm.dsHangHoa.add(hangHoaMoi);

                      vm.notifyListeners();
                    }
                  },

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xffB9DDBF)),
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

  Widget _tabButton(String title, int index, Color bgColor, Color textColor) {
    bool selected = vm.currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          vm.changeTab(index);
        },
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? bgColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15, // tăng cỡ chữ
              color: selected ? textColor : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
