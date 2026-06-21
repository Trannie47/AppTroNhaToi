import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/HoaDonTapHoaForm/hoaDonTapHoaViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ChonHangHoaPage/chonHangHoaPage.dart';

import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoaChon.dart';
import 'package:flutter/material.dart';

class HoaDonTapHoaForm extends StatefulWidget {

  final HoaDonTapHoaModel? hoaDonModel;

  const HoaDonTapHoaForm({
    super.key,
    this.hoaDonModel,
  });

  @override
  State<HoaDonTapHoaForm> createState() =>
      _HoaDonTapHoaFormState();
}
class _HoaDonTapHoaFormState extends State<HoaDonTapHoaForm> {
  final vm = HoaDonTapHoaFormViewModel();

  @override
  void initState() {
    super.initState();

    vm.LoadData();

    if (widget.hoaDonModel != null) {

      vm.maHoaDon = widget.hoaDonModel!.hoaDon.maHoaDon!;

      vm.selectedNguoiThue = vm.dsNguoiThue.firstWhere(
            (e) => e.idnt == widget.hoaDonModel!.hoaDon.idnt,
        orElse: () => vm.dsNguoiThue.first,
      );

      vm.nguoiThueTro =
          widget.hoaDonModel!.hoaDon.idnt != null;

      vm.coPhieuThu =
          widget.hoaDonModel!.phieuThu != null;

      vm.txtNguoiDongTien.text =
          widget.hoaDonModel!.phieuThu?.nguoiDong ?? "";

      vm.dsHangHoaChon =
          List.from(widget.hoaDonModel!.dsHangHoa);

      vm.soLuong =
          Map.from(widget.hoaDonModel!.soLuong);
    }
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
          height: 48,
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

            if (vm.maHoaDon != 0)
              Text(
                vm.maHoaDon.toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
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
                              "Khách vãng lai chỉ thêm sản phẩm,\nkhông nhập các thông tin khác.",
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

                            vm.doiTrangThaiNguoiThueTro(value);

                          });

                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (vm.nguoiThueTro) ...[

                    SizedBox(
                      height: 48,
                      child: CustomDropdownSearch<NguoiThue>(

                        items: vm.dsNguoiThue,
                        selectedItem: vm.selectedNguoiThue,
                        itemAsString: (item) => item.hoTen!,

                        onChanged: (value) {

                          setState(() {

                            vm.selectedNguoiThue = value;
                            vm.errNguoiThue = null;

                          });

                        },
                      ),

                    ),

                    if (vm.errNguoiThue != null) ...[
                      const SizedBox(height: 4),

                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          vm.errNguoiThue!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],

                  ],

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
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (vm.nguoiThueTro && vm.coPhieuThu) ...[
                    inputBox(
                      title: "Người đóng tiền",
                      controller: vm.txtNguoiDongTien,
                    ),

                  ]
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

                onPressed: () async {
                  final HangHoa? result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChonHangHoaPage()),
                  );

                  if (result != null) {
                    setState(() {
                      vm.themHangHoa(result);
                      vm.errHangHoa = null;
                    });
                  }
                },

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
            if (vm.errHangHoa != null) ...[
              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    vm.errHangHoa!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],


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

                  if (!vm.kiemTraDuLieu()) {
                    setState(() {});
                    return;
                  }

                  if (vm.maHoaDon == "") {
                    vm.taoMaHoaDon();
                  }

                  HoaDonTapHoa hoaDon = HoaDonTapHoa(
                    maHoaDon: vm.maHoaDon,
                    idnt: vm.nguoiThueTro
                        ? vm.selectedNguoiThue?.idnt
                        : null,
                    ngayBan: DateTime.now(),
                    tongTien: vm.tongTien,
                  );

                  PhieuThuHdTh? phieuThu;

                  if (vm.coPhieuThu) {

                    phieuThu = PhieuThuHdTh(
                      maHoaDon: vm.maHoaDon,
                      nguoiDong: vm.txtNguoiDongTien.text,
                      soTien: vm.tongTien,
                      ngayThu: DateTime.now(),
                    );
                  }

                  Navigator.pop(
                    context,
                    HoaDonTapHoaModel(
                      hoaDon: hoaDon,

                      phieuThu: phieuThu,

                      tenNguoiMua:
                      vm.selectedNguoiThue?.hoTen ?? "Khách vãng lai",

                      dsHangHoa: List.from(vm.dsHangHoaChon),

                      soLuong: Map.from(vm.soLuong),
                    ),
                  );
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
