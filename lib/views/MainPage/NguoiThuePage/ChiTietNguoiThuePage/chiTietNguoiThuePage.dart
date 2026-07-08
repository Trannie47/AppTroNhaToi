import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/view_models/hopdong_view_model.dart';
import 'package:AppTroNhaToi/view_models/nguoithue_view_model.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../modelviews/MainPage/NguoiThuePage/ChiTietNguoiThuePage/chiTietNguoiThuePageViewModel.dart';
import '../../../../states/chi_tiet_nguoi_thue_state.dart';
import '../../../../widgets/app_confirm_dialog.dart';
import '../../../../widgets/app_error.dart';

class ChiTietNguoiThuePage extends StatefulWidget {
  final NguoiThue nguoiThue;

  //final List<Phong> dsPhong;

  const ChiTietNguoiThuePage({
    super.key,
    required this.nguoiThue,
    //required this.dsPhong,
  });

  @override
  State<ChiTietNguoiThuePage> createState() => _ChiTietNguoiThuePageState();
}

class _ChiTietNguoiThuePageState extends State<ChiTietNguoiThuePage> {
  late ChiTietNguoiThuePageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ChiTietNguoiThuePageViewModel(context.read<NguoiThueProvider>());
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchRoomByNguoiThue(widget.nguoiThue.idnt!);
    }); //Kích hoạt gọi api lấy ds phòng theo id ngthue

  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  // void openPhuongTienPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return PhuongTienNguoiThuePage(
  //           nguoiThue: vm.nguoiThue,
  //           dsPhuongTien: vm.dsXe,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final detail = widget.nguoiThue; // lấy dữ liệu người thuê được gửi từ mà trước qua
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: Colors.white,

        centerTitle: false,

        titleSpacing: 0,

        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),

          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xff1C1C1E),
              ),
            ),
          ),
        ),

        title: const Text(
          "Chi tiết người thuê",

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xff1C1C1E),
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Container(
              width: 38,
              height: 38,

              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
                shape: BoxShape.circle,
              ),

              child: PopupMenuButton<String>(
                offset: const Offset(0, 48),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Color(0xff666666),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                elevation: 10,
                onSelected: (value) {
                  switch (value) {
                    case 'update':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NguoiThueForm(nguoiThue: widget.nguoiThue),
                        ),
                      );
                      break;

                    case 'room':
                      break;

                    case 'vehicle':
                      //  openPhuongTienPage();
                      break;

                    case 'parking_bill':
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) {
                      //       return HoaDonGuiXePage(dsPhuongTien: [...vm.dsXe]);
                      //     },
                      //   ),
                      // );
                      break;

                    case 'guest':
                      break;

                    case 'delete':
                      // vm.showDeleteDialog(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'update',
                    child: _menuItem(
                      Icons.edit_outlined,
                      const Color(0xff2D7A3A),
                      "Cập nhật thông tin",
                      "Sửa tên, SĐT, CCCD, quê quán",
                    ),
                  ),

                  PopupMenuItem(
                    value: 'room',
                    child: _menuItem(
                      Icons.work_outline,
                      const Color(0xff2D7A3A),
                      "Phòng đang thuê",
                      "Xem lịch sử thuê phòng",
                    ),
                  ),

                  PopupMenuItem(
                    value: 'vehicle',
                    child: _menuItem(
                      Icons.directions_car_outlined,
                      const Color(0xff635BFF),
                      "Phương tiện",
                      "Thêm, sửa xe của người thuê",
                    ),
                  ),

                  PopupMenuItem(
                    value: 'parking_bill',
                    child: _menuItem(
                      Icons.receipt_long_outlined,
                      const Color(0xffF59E0B),
                      "Hóa đơn gửi xe",
                      "Lịch sử hóa đơn gửi xe",
                    ),
                  ),

                  PopupMenuItem(
                    value: 'guest',
                    child: _menuItem(
                      Icons.groups_outlined,
                      const Color(0xff8B5CF6),
                      "Người lưu trú tạm thời",
                      "Ba mẹ, anh chị, bạn bè ở ngắn ngày",
                    ),
                  ),

                  PopupMenuItem(
                    value: 'delete',
                    child: _menuItem(
                      Icons.delete_outline,
                      Colors.red,
                      "Xóa người thuê",
                      "Chỉ xóa nếu chưa phát sinh dữ liệu",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),

                      blurRadius: 10,

                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,

                      decoration: const BoxDecoration(
                        color: Color(0xff1F9D3A),
                        shape: BoxShape.circle,
                      ),

                      alignment: Alignment.center,

                      child: Text(
                        vietTat(detail.hoTen ?? ""),

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      detail.hoTen ?? "",

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                     Text(
                       detail.trangThai==0
                           ? "Chưa có hợp đồng"
                       : detail.trangThai==1
                       ? "Đang thuê hoạt động"
                       : "Đã dọn đi",
                      style: TextStyle(
                        color: detail.trangThai == 0
                            ? Colors.orange.shade700
                            : detail.trangThai == 1
                            ? const Color(0xff1F9D3A)
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => LauncherUtils.goidien(detail.sdt ?? ""),
                            child: _actionButton(
                              const Icon(
                                Icons.call_outlined,
                                color: Color(0xff2F61E7),
                              ),
                              "Gọi điện",
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => LauncherUtils.nhantin(detail.sdt ?? ""),
                            child: _actionButton(
                              const Icon(
                                Icons.message_outlined,
                                color: Color(0xff2F61E7),
                              ),
                              "Nhắn tin",
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => LauncherUtils.zalo(detail.sdt ?? ""),
                            child: _actionButton(
                              Image.asset(
                                "assets/images/zalo.png",
                                width: 20,
                                height: 20,
                              ),
                              "Zalo",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// THÔNG TIN CÁ NHÂN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _section(
                    title: "Thông tin cá nhân",
                    action: "Sửa",
                    // thêm sữa thông tin cá nhân
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              NguoiThueForm(nguoiThue: widget.nguoiThue),
                        ),
                      );
                    },

                    child: Column(
                      children: [
                        _itemInfo(
                          "Số điện thoại",
                          detail.sdt ?? "",
                          isBlue: true,
                        ),

                        _itemInfo("CCCD", detail.cccd ?? ""),

                        _itemInfo("Ngày sinh", formatDate(detail.ngaySinh)),

                        _itemInfo("Quê quán", detail.queQuan ?? ""),

                        _itemInfo("Ghi chú", detail.ghiChu ?? ""),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  _section(
                    title: switch(vm.chiTietNguoiThueState){
                      ChiTietNguoiThueSuccess(listHD: final list) => "Phòng đang thuê (${list.length})",
                      _ => "Phòng đang thuê (...)",
                    },
                    action: "Xem thêm",
                    child: switch(vm.chiTietNguoiThueState){
                      ChiTietNguoiThueLoading() => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: Color(0xff2D7A3A)),
                        ),
                      ),
                      ChiTietNguoithueError(message: final msg) =>
                      AppErrorWidget(
                        message: msg,
                        onRetry: (){
                          vm.fetchRoomByNguoiThue(widget.nguoiThue.idnt!);
                        },
                      ),


                      ChiTietNguoiThueSuccess(listHD: final list) => list.isEmpty
                          ? const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          "Người này hiện chưa thuê phòng nào",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      )
                          : Column(
                        children: list.asMap().entries.map((e) {
                          final index = e.key;
                          final hopDong = e.value;
                          final phong = hopDong.phong;
                          final loaiPhong = phong?.loaiPhong;

                          String chuoiNgay = "Chưa rõ ngày ký";
                          if (hopDong.ngayKy != null) {
                            chuoiNgay = "Đang thuê từ ${formatDate(hopDong.ngayKy)}";
                          }

                          return Column(
                            children: [
                              _itemPhong(
                                phong?.tenPhong != null
                                    ? "P${phong?.tenPhong}"
                                    : "P??",
                                "Phòng ${phong?.tenPhong ?? "P??"} · ${loaiPhong?.tenLoaiPhong ?? "Chưa rõ loại"}",
                                chuoiNgay,
                              ),
                              if (index != list.length - 1)
                                const Divider(height: 0.5),
                            ],
                          );
                        }).toList(),
                      ),

                    }
                  ),

                  const SizedBox(height: 24),

                  /// DELETE
                  Container(
                    width: double.infinity,
                    height: 56,

                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1F1),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: TextButton.icon(
                      onPressed: () => _thucHienXoaNguoiThue(),

                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),

                      label: const Text(
                        "Ẩn người thuê này",

                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _thucHienXoaNguoiThue() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,// ngăn người dùng nhấn ra ngoài làm trả về null
      builder: (dialogContext) => AppConfirmDialog(
        title: "Ẩn người thuê",
        content: "Bạn có chắc chắn muốn ẩn người thuê ${widget.nguoiThue.hoTen} không?",
        textConfirm: "Ẩn ngay",
        isDangerous: true,
        onConfirm: () {
          Navigator.pop(dialogContext, true);
        },
      ),
    );

    if (confirmDelete != true) return;
    try {
      final idnt = widget.nguoiThue.idnt;
      if (idnt != null) {
        // Gọi hàm xóa qua vm con mới, mảng local trong Provider tổng tự động refresh
        bool isSuccess = await vm.xoaNguoiThue(idnt);

        if (isSuccess && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ẩn người thuê thành công!')),
          );
          Navigator.pop(context, true); // Quay lại màn hình danh sách chính
        }
      }
    } catch (e) {
      String errorMessage = "Không thể ẩn người thuê này!";
      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'].toString();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Widget _section({
    required String title,
    required String action,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        spacing: 4,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff2D7A3A),
                ),
              ),
              onTap != null
                  ? GestureDetector(
                      onTap: onTap,
                      child: Text(
                        action,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2D7A3A),
                        ),
                      ),
                    )
                  : Text(
                      action,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2D7A3A),
                      ),
                    ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _itemInfo(String title, String value, {bool isBlue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 13, color: Color(0xff999999)),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,

              color: isBlue ? const Color(0xff2F61E7) : const Color(0xff1C1C1E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPhong(String maPhong, String tenPhong, String ngayThue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xffEEF6EF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              maPhong,
              style: const TextStyle(
                color: Color(0xff2D7A3A),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tenPhong,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1C1E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Đề phòng tên phòng quá dài tự chấm chấm
                ),

                const SizedBox(height: 4),

                Text(
                  ngayThue,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff8E8E93),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xffC7C7CC)),
        ],
      ),
    );
  }

  Widget _actionButton(Widget icon, String title) {
    return Container(
      height: 72,

      decoration: BoxDecoration(
        color: const Color(0xffF7F8FC),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(width: 22, height: 22, child: Center(child: icon)),

          const SizedBox(height: 8),

          Text(
            title,

            style: const TextStyle(fontSize: 12, color: Color(0xff555555)),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, Color color, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
