import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietLichSuSuaChuaPage/chiTietLichSuSuaChuaPageViewModel.dart';
import 'package:flutter/material.dart';

class ChiTietLichSuSuaChuaPage extends StatefulWidget {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;
  final Phong phong;
  final ThietBi thietBi;

  const ChiTietLichSuSuaChuaPage({
    super.key,
    required this.suaChua,
    this.hoaDonSuaChua,
    required this.phong,
    required this.thietBi,
  });

  @override
  State<ChiTietLichSuSuaChuaPage> createState() =>
      _ChiTietLichSuSuaChuaPageState();
}

class _ChiTietLichSuSuaChuaPageState extends State<ChiTietLichSuSuaChuaPage> {
  late ChiTietLichSuSuaChuaPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ChiTietLichSuSuaChuaPageViewModel();

    vm.init(widget.suaChua, widget.hoaDonSuaChua, widget.phong, widget.thietBi);

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  Widget _infoRow(
    String title,
    String value, {
    Color? color,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(color: Colors.grey.shade500)),
          ),

          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2D7A3A),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
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
              "Chi Tiết Sửa Chữa",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              "${widget.thietBi.tenThietBi} - ${widget.phong.tenPhong}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),

            itemBuilder: (context) => [
              PopupMenuItem(
                value: "update",
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xff2D7A3A),
                  ),
                  title: const Text("Cập nhật thông tin"),
                  subtitle: const Text("Sửa lỗi, loại sửa"),
                ),
              ),

              PopupMenuItem(
                value: "delete",
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    "Xóa chi tiết",
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                    "Không thể hoàn tác",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            _section(
              title: "Thông tin sửa chữa",
              child: Column(
                children: [
                  _infoRow("Nguyên nhân", vm.suaChua.nguyenNhan ?? ""),

                  _infoRow(
                    "Ngày sửa",
                    formatDate(vm.suaChua.ngaySuaChua),
                    isLast: true,
                  ),
                ],
              ),
            ),

            if (vm.hoaDonSuaChua != null)
              _section(
                title: "Hoá đơn sửa chữa",
                child: Column(
                  children: [
                    _infoRow("Mã hoá đơn", "${vm.hoaDonSuaChua!.maHoaDonSC}"),

                    _infoRow("Loại sửa chữa", vm.hoaDonSuaChua!.loaiSuaText),

                    _infoRow(
                      "Giá tiền",
                      formatMoney(vm.hoaDonSuaChua!.giaTien),
                    ),

                    _infoRow(
                      "Ngày tạo hóa đơn",
                      formatDate(vm.hoaDonSuaChua!.ngayLapHoaDonSC),
                    ),

                    _infoRow(
                      "Trạng thái",
                      vm.hoaDonSuaChua!.trangThaiText,
                      color: Colors.red,
                      isLast: true,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
