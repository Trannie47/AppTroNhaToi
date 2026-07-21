import 'package:AppTroNhaToi/Provider/phuong_tien_provider.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/PhuongTienNguoiThuePage/PhuongTienNguoiThuePage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/PhuongTienForm/PhuongTienForm.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePage.dart';
import 'package:AppTroNhaToi/widgets/app_error.dart';
import 'package:AppTroNhaToi/widgets/itemPhuongTien.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/hop_dong.dart';
import '../../../../widgets/app_confirm_dialog.dart';

class PhuongTienNguoiThuePage extends StatefulWidget {
  final NguoiThue nguoiThue;
  final List<HopDong>? dsHopDong;

  const PhuongTienNguoiThuePage({
    super.key,
    required this.nguoiThue,
    this.dsHopDong,
  });

  @override
  State<PhuongTienNguoiThuePage> createState() =>
      _PhuongTienNguoiThuePageState();
}

class _PhuongTienNguoiThuePageState extends State<PhuongTienNguoiThuePage> {
  late PhuongTienNguoiThuePageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = PhuongTienNguoiThuePageViewModel(
      nguoiThue: widget.nguoiThue,
      provider: context.read<PhuongTienProvider>(),
    );

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchDsPhuongTien();
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void themPhuongTien() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhuongTienForm(
          nguoiThue: vm.nguoiThue,
          dsHopDong: widget.dsHopDong,
        ),
      ),
    );

    // Nếu thêm xe thành công, tải lại danh sách mới nhất từ Server
    if (result != null && mounted) {
      vm.fetchDsPhuongTien();
    }
  }

  void openHoaDonGuiXe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HoaDonGuiXePage(
          dsPhuongTien: vm.dsPhuongTien,
        ),
      ),
    );
  }
  void _xacNhanXoaXe(PhuongTien xe) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: "Xóa phương tiện",
        content:
        "Bạn có chắc chắn muốn xóa phương tiện ${xe.hangXe ?? ''} (${xe.bienSo ?? 'Không BKS'}) không?",
        textConfirm: "Xóa ngay",
        isDangerous: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
      ),
    );

    if (confirm == true && mounted) {
      final success = await vm.deletePhuongTien(xe);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Xóa phương tiện thành công!"),
              backgroundColor: Color(0xff2D7A3A),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(vm.errorMessage ?? "Không thể xóa phương tiện!"),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 62,
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 16,
              ),
              child: Row(
                children: [
                  /// BACK
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 13,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// TITLE
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Phương tiện",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              height: 1,
                              color: Color(0xff1C1C1E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.nguoiThue.hoTen ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1,
                              color: Color(0xff8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// HÓA ĐƠN GỬI XE
                  GestureDetector(
                    onTap: openHoaDonGuiXe,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xffEEF5EF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/chitiethd.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // XỬ LÝ TRẠNG THÁI HIỂN THỊ DANH SÁCH / LOADING / ERROR / EMPTY
            Expanded(
              child: vm.isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff2D7A3A),
                ),
              )
                  : vm.errorMessage != null
                  ? AppErrorWidget(
                message: vm.errorMessage!,
                onRetry: () => vm.fetchDsPhuongTien(),
              )
                  : vm.dsPhuongTien.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Người thuê này hiện chưa có phương tiện nào",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  110,
                ),
                children: [
                  /// XE MÁY
                  if (vm.xeMay.isNotEmpty)
                    _groupXe(
                      title: "Xe máy",
                      dsXe: vm.xeMay,
                    ),

                  /// Ô TÔ
                  if (vm.oTo.isNotEmpty)
                    _groupXe(
                      title: "Xe ô tô",
                      dsXe: vm.oTo,
                    ),

                  /// XE ĐẠP
                  if (vm.xeDap.isNotEmpty)
                    _groupXe(
                      title: "Xe đạp",
                      dsXe: vm.xeDap,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BUTTON THÊM PHƯƠNG TIỆN
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            14,
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: themPhuongTien,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff2D7A3A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Thêm phương tiện",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _groupXe({
    required String title,
    required List<PhuongTien> dsXe,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
            top: 4,
          ),
          child: Text(
            "$title (${dsXe.length})",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xff2D7A3A),
            ),
          ),
        ),
        ...List.generate(
          dsXe.length,
              (index) {
            final xe = dsXe[index];
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 14,
              ),
              child: ItemPhuongTien(
                phuongTien: xe,
                delete: () {
                  _xacNhanXoaXe(xe);
                },
                edit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhuongTienForm(
                        nguoiThue: widget.nguoiThue,
                        dsHopDong: widget.dsHopDong,
                        phuongTienSua: xe,
                      ),
                    ),
                  );
                  if (result != null && mounted) {
                    vm.fetchDsPhuongTien();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}