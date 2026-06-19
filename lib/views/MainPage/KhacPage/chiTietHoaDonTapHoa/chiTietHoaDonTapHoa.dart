import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHoaDonTapHoa/chiTietHoaDonTapHoaViewModel.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoaChon.dart';
import 'package:flutter/material.dart';
import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';

class ChiTietHoaDonTapHoa extends StatefulWidget {
  final HoaDonTapHoa hoaDon;
  final PhieuThuHdTh? phieuThu;
  final String? tenNguoiMua;

  const ChiTietHoaDonTapHoa({
    super.key,
    required this.hoaDon,
    this.phieuThu,
    this.tenNguoiMua,
  });

  @override
  State<ChiTietHoaDonTapHoa> createState() => _ChiTietHoaDonTapHoaState();
}

class _ChiTietHoaDonTapHoaState extends State<ChiTietHoaDonTapHoa> {
  late ChiTietHoaDonTapHoaViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ChiTietHoaDonTapHoaViewModel(
      hoaDon: widget.hoaDon,
      phieuThu: widget.phieuThu,
      tenNguoiMua: widget.tenNguoiMua,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
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
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chi tiết Hoá đơn tạp hoá",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _section(
              title: "Thông tin hoá đơn",
              child: Column(
                children: [
                  _infoRow("Mã hoá đơn", vm.hoaDon.maHoaDon ?? ""),

                  _infoRow("Ngày mua", formatDate(vm.hoaDon.ngayBan)),

                  _infoRow("Tên người mua", vm.tenNguoiMua!),

                  _infoRow(
                    "Tổng tiền",
                    formatMoney(vm.hoaDon.tongTien),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            if (vm.phieuThu != null) ...[
              _section(
                title: "Thông tin Phiếu thu tạp hoá",
                child: Column(
                  children: [
                    _infoRow(
                      "Mã phiếu thu",
                      vm.phieuThu?.maPhieuThu?.toString() ?? "",
                    ),

                    _infoRow("Ngày lập", formatDate(vm.phieuThu?.ngayThu)),

                    _infoRow(
                      "Tên người thanh toán",
                      vm.phieuThu?.nguoiDong ?? "",
                    ),

                    _infoRow(
                      "Tổng tiền",
                      formatMoney(vm.phieuThu?.soTien),
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Danh sách sản phẩm",
                style: TextStyle(
                  color: Color(0xff2D7A3A),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// item sản phẩm của bạn
            Column(
              children: vm.dsChiTietHoaDonTapHoa.map((e) {
                return ItemHangHoaChon(
                  hangHoa: e.hangHoa,

                  soLuong: e.chiTietTapHoa.soLuong ?? 0,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2D7A3A),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Color(0xff999999), fontSize: 16),
            ),
          ),

          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
