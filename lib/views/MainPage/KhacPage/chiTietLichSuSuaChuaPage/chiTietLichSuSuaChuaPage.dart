import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietLichSuSuaChuaPage/chiTietLichSuSuaChuaPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChiTietLichSuSuaChuaPage extends StatefulWidget {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;
  final String? tenPhong;
  final LapRap? lapRap;
  final ThietBi thietBi;

  const ChiTietLichSuSuaChuaPage({
    super.key,
    required this.suaChua,
    this.hoaDonSuaChua,
    required this.thietBi,
    this.tenPhong,
    this.lapRap,
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

    vm.init(
      widget.suaChua,
      widget.hoaDonSuaChua,
      widget.thietBi,
      context.read<SuaChuaProvider>(),
      widget.lapRap,
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

  Future<void> capNhatThongTin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<SuaChuaProvider>(),
          child: PhieuSuaChuaForm(
            suaChua: widget.suaChua,
            hoaDonSuaChua: widget.hoaDonSuaChua,
            thietBi: widget.thietBi,
            lapRap: widget.lapRap,
          ),
        ),
      ),
    );

    if (result is SuaChuaDTO) {
      setState(() {
        vm.suaChua = SuaChua(
          id: result.id,
          lapRapID: result.lapRapId,
          thietBiID: result.thietBiId,
          nguyenNhan: result.nguyenNhan,
          ngaySuaChua: result.ngaySuaChua,
          trangThaiThongBao: result.trangThaiThongBao,
        );
        vm.hoaDonSuaChua = result.hoaDonSuaChua;
      });
    }
  }

  Future<void> xoaChiTiet() async {
    final bool kt = await vm.xoaChiTiet();
    if (kt == true) {
      Navigator.pop(context, true);
    }
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

  /// Hiện dòng "Mức độ xử lý" kèm badge màu theo trangThaiThongBao
  /// (0 = Bình thường, 1 = Gấp).
  Widget _rowMucDoXuLy({bool isLast = false}) {
    final laGap = vm.suaChua.trangThaiThongBao == 1;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Mức độ xử lý",
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: laGap
                  ? Colors.red.withOpacity(0.1)
                  : const Color(0xff2D7A3A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              laGap ? "Gấp (≤ 7 ngày)" : "Bình thường",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: laGap ? Colors.red : const Color(0xff2D7A3A),
              ),
            ),
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
              "${widget.thietBi.tenThietBi} - ${widget.tenPhong}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            onSelected: (value) {
              switch (value) {
                case "update":
                  capNhatThongTin(); // gọi hàm cập nhật
                  break;

                case "delete":
                  xoaChiTiet(); // gọi hàm xóa
                  break;
              }
            },

            icon: const Icon(Icons.more_vert),

            itemBuilder: (context) => [
              if ((vm.hoaDonSuaChua?.trangThai ?? 0) < 2)
                PopupMenuItem<String>(
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
              if ((vm.hoaDonSuaChua?.trangThai ?? 0) < 2)
                PopupMenuItem<String>(
                  value: "delete",
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Ẩn chi tiết",
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

                  _infoRow("Ngày sửa", formatDate(vm.suaChua.ngaySuaChua)),

                  _rowMucDoXuLy(isLast: true),
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
                      isLast: (vm.hoaDonSuaChua!.ghiChu ?? "").trim().isEmpty,
                    ),

                    if ((vm.hoaDonSuaChua!.ghiChu ?? "").trim().isNotEmpty)
                      _infoRow(
                        "Ghi chú",
                        vm.hoaDonSuaChua!.ghiChu!.trim(),
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
