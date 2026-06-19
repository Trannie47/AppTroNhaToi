import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/HoaDonTapHoaForm/hoaDonTapHoaViewModel.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoaChon.dart';
import 'package:flutter/material.dart';

class HoaDonTapHoaForm extends StatefulWidget {
  const HoaDonTapHoaForm({super.key});

  @override
  State<HoaDonTapHoaForm> createState() => _HoaDonTapHoaFormState();
}

class _HoaDonTapHoaFormState extends State<HoaDonTapHoaForm> {
  final vm = HoaDonTapHoaFormViewModel();

  @override
  void initState() {
    super.initState();

    vm.themHangHoa(
      HangHoa(
        maHangHoa: 1,
        tenHangHoa: "Mì gói Hảo Hảo",
        giaBan: 5000,
        donViTinh: "gói",
      ),
    );

    vm.themHangHoa(
      HangHoa(
        maHangHoa: 2,
        tenHangHoa: "Mì gói Cocomi",
        giaBan: 5000,
        donViTinh: "gói",
      ),
    );
    vm.LoadData();
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  Widget inputBox({
    required String title,
    required TextEditingController controller,
    String? hint,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),

        const SizedBox(height: 8),

        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xff2D7A3A)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
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

        // khoảng cách giữa nút và title
        titleSpacing: 20,

        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hóa đơn Tạp Hóa",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

            if (vm.maHoaDon.isNotEmpty)
              Text(
                vm.maHoaDon,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Thông tin hóa đơn",
                    style: TextStyle(
                      color: Color(0xff2D7A3A),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Người thuê trọ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Khách vãng lai chỉ nhập sản phẩm,\nkhông nhập các thông tin khác.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Switch(
                        value: vm.nguoiThueTro,

                        activeColor: const Color(0xff2D7A3A),

                        onChanged: (value) {
                          setState(() {
                            vm.nguoiThueTro = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  IgnorePointer(
                    ignoring: !vm.nguoiThueTro,
                    child: Opacity(
                      opacity: vm.nguoiThueTro ? 1 : 0.5,
                      child: CustomDropdownSearch<NguoiThue>(
                        items: vm.dsNguoiThue,
                        selectedItem: vm.selectedNguoiThue,
                        itemAsString: (item) => item.hoTen!,
                        onChanged: (value) {
                          setState(() {
                            Switch(
                              value: vm.nguoiThueTro,
                              activeColor: const Color(0xff2D7A3A),
                              onChanged: (value) {
                                setState(() {
                                  vm.doiTrangThaiNguoiThueTro(value);
                                });
                              },
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  inputBox(
                    title: "Ngày mua",

                    controller: vm.txtNgayMua,

                    suffixIcon: IconButton(
                      onPressed: () {},

                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Có xuất phiếu thu",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Xác minh phiếu thu đã thu tiền.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Switch(
                        value: vm.coPhieuThu,
                        activeColor: const Color(0xff2D7A3A),
                        onChanged: (value) {
                          setState(() {
                            vm.doiTrangThaiPhieuThu(value);
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Opacity(
                    opacity: vm.coPhieuThu ? 1 : 0.5,
                    child: IgnorePointer(
                      ignoring: !vm.coPhieuThu,
                      child: inputBox(
                        title: "Người đóng tiền",
                        controller: vm.txtNguoiDongTien,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Column(
              children: vm.dsHangHoaChon.map((e) {
                return ItemHangHoaChon(
                  hangHoa: e,

                  soLuong: vm.laySoLuong(e),

                  onTang: () {
                    setState(() {
                      vm.tangSoLuong(e);
                    });
                  },

                  onChanged: (value) {
                    setState(() {
                      vm.capNhatSoLuong(e, value);
                    });
                  },

                  onGiam: () {
                    setState(() {
                      vm.giamSoLuong(e);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () {},

                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xff2D7A3A),
                ),

                label: const Text(
                  "Thêm hàng hóa",
                  style: TextStyle(
                    color: Color(0xff2D7A3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,

              height: 56,

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: const Color(0xffFFF4E4),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                "${vm.formatTien(vm.tongTien)}đ",

                style: const TextStyle(
                  color: Colors.orange,

                  fontWeight: FontWeight.bold,

                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              height: 56,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2D7A3A),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () {
                  HoaDonTapHoa hoaDon = HoaDonTapHoa(
                    maHoaDon: vm.maHoaDon,

                    ngayBan: DateTime.now(),

                    tongTien: vm.tongTien,
                  );

                  Navigator.pop(context, hoaDon);
                },

                child: const Text(
                  "Lưu hàng hóa",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 16,

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
}
