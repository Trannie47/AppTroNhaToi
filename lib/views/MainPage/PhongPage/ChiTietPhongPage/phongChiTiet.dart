import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/widgets/more_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/phong_provider.dart';
import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../modelviews/MainPage/PhongPage/ChiTietPhongPage/chiTietPhongViewModel.dart';
import '../../../../states/NguoiThueState.dart';
import '../../../../states/phong_save_state.dart';
import '../../../../widgets/app_confirm_dialog.dart';
import '../../../../widgets/app_error.dart';

class PhongChiTiet extends StatefulWidget {
  final ItemPhong room;

  const PhongChiTiet({
    super.key,
    required this.room,
  });

  @override
  State<PhongChiTiet> createState() => _PhongChiTiet();

}
  class _PhongChiTiet extends State<PhongChiTiet> {
    late ChiTietPhongViewModel vm;
  @override
  void initState(){
    super.initState();
    vm = ChiTietPhongViewModel(
      context.read<PhongProvider>(),
      context.read<NguoiThueProvider>(),
      widget.room.phongId,
    );
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.getListNguoiThueFromIdPhong(widget.room.phongId);
    });
  }
    @override
    Widget build(BuildContext context) {
      final room = context.watch<PhongProvider>().listPhong.firstWhere(
            (p) => p.phongId == widget.room.phongId,
        orElse: () => widget.room,
      );
      // Lấy ra các màu sắc và văn bản trạng thái trực tiếp từ thuộc tính trangThai của room
      Color statusColor = _getTrangThaiColor(room.trangThai);
      String statusText = _getTrangThaiText(room.trangThai);

      return Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Phòng ${room.tenPhong}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                _showMoreOption(context, room);
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  BANNER TRẠNG THÁI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: statusColor.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: statusColor),
                    const SizedBox(width: 10),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // hàng chức năng tiện ích
              _buildQuickActionsRow(),
              const SizedBox(height: 20),

              // Thông tin phòng trọ
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin phòng",
                      style: TextStyle(color: Color(0xFF2D7A3A),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    _infoLine(label: "Loại phòng",
                        value: room.loaiPhong.tenLoaiPhong),
                    _infoLine(label: "Diện tích",
                        value: "${room.loaiPhong.dienTich.toInt()} m²"),
                    _infoLine(
                        label: "Giá thuê",
                        value: "${_formatCurrency(room.giahientai)}đ/tháng",
                        valueColor: const Color(0xFF2D7A3A),
                        isBold: true
                    ),
                    _infoLine(label: "Số người tối đa",
                        value: "${room.loaiPhong.soNguoiToiDa} người"),
                    _infoLine(label: "Máy lạnh",
                        value: room.loaiPhong.isMayLanh ? "Có" : "Không"),
                    _infoLine(label: "Mô tả",
                        value: room.moTa.isEmpty ? "Không có mô tả" : room.moTa,
                        isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              //Danh sách người đang thuê phòng này
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.nguoiThueState is NguoiThueSuccess
                          ? "Người thuê hiện tại (${(vm.nguoiThueState as NguoiThueSuccess).listNguoithue.length})"
                          : "Người thuê hiện tại (...)",
                      style: const TextStyle(
                        color: Color(0xFF2D7A3A),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    ...switch (vm.nguoiThueState){
                      NguoiThueLoading() => [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7A3A)))),
                        )
                      ],

                      NguoiThueError(errorMessage: final msg) => [
                        AppErrorWidget(message: msg,
                            onRetry:(){
                                vm.getListNguoiThueFromIdPhong(room.phongId);
                            }
                        )

                      ],
                      NguoiThueSuccess(listNguoithue: final dsKhach) => [
                        const SizedBox(height: 16),
                        if (dsKhach.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "Phòng hiện đang trống, chưa có người thuê.",
                                style: TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dsKhach.length,
                            itemBuilder: (context, index) {
                              final khach = dsKhach[index];
                              final isLastItem = index == dsKhach.length - 1;

                              return _itemNguoiThue(khach: khach, isLastItem: isLastItem);
                            },
                          ),
                      ],
                    }
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }


    // Hàng chức năng tiện ích cho phong
    Widget _buildQuickActionsRow() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _actionChip(title: "Ghi điện nước",
                icon: Icons.flash_on,
                isActive: true,
                onTap: () {}),
            const SizedBox(width: 8),
            _actionChip(title: "Tạo hóa đơn",
                icon: Icons.receipt_long,
                isActive: false,
                onTap: () {}),
            const SizedBox(width: 8),
            _actionChip(title: "Hợp đồng",
                icon: Icons.assignment,
                isActive: false,
                onTap: () {}),
            const SizedBox(width: 8),
            _actionChip(title: "Lịch sử thuê",
                icon: Icons.history,
                isActive: false,
                onTap: () {}),
          ],
        ),
      );
    }

    Widget _actionChip({
      required String title,
      required IconData icon,
      required bool isActive,
      required VoidCallback onTap,
    }) {
      Color mainColor = const Color(0xFF2D7A3A);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? mainColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isActive ? mainColor : Colors.grey.shade300, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16,
                color: isActive ? Colors.white : Colors.black54),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.black.withOpacity(
                      0.7)),
            ),
          ],
        ),
      );
    }

    Widget _infoLine({
      required String label,
      required String value,
      Color? valueColor,
      bool isBold = false,
      bool isLast = false,
    }) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(
                    color: Colors.black54, fontSize: 14)),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      color: valueColor ?? Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast) Divider(color: Colors.grey.shade100, height: 1),
        ],
      );
    }

    // màu trạng thái phòng
    Color _getTrangThaiColor(int status) {
      if (status == 0) return Colors.green;
      if (status == 1) return Colors.orange;
      return Colors.red;
    }

    // chữ trạng thái phòng
    String _getTrangThaiText(int status) {
      if (status == 0) return "Còn trống";
      if (status == 1) return "Đang cho thuê";
      return "Đang sửa chữa";
    }

    String _formatCurrency(double amount) {
      final n = amount.toInt();
      final s = n.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
        buffer.write(s[i]);
      }
      return buffer.toString();
    }

  Widget _itemNguoiThue({required dynamic khach, required bool isLastItem}) {
    String initials = vietTat(khach.hoTen);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [

              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE2ECFF),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: const Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Thông tin chữ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      khach.hoTen ?? 'Chưa rõ họ tên',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${khach.sdt ?? 'Không có SĐT'}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLastItem) Divider(color: Colors.grey.shade100, height: 1, indent: 62),
      ],
    );
  }
    void _showMoreOption(BuildContext context, ItemPhong room) async {
      final action = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => MoreOptionsSheet(room: room),
      );

      if (action == "DELETE" && mounted) {
        final dialogResult = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AppConfirmDialog(
            title: "Xóa phòng trọ",
            content: "Bạn có chắc chắn muốn xóa phòng ${room.tenPhong} không? Hành động này không thể hoàn tác.",
            textConfirm: "Xóa ngay",
            isDangerous: true,
            onConfirm: () {
              Navigator.pop(dialogContext, true);
            },
          ),
        );

        if (dialogResult == true && mounted) {
          final navigator = Navigator.of(context);
          final scaffoldMessenger = ScaffoldMessenger.of(context);


          await vm.removePhong(room.phongId);

          if (vm.phongSaveState is PhongSaveSuccess) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text("Xóa phòng trọ thành công!"),
                backgroundColor: Colors.green,
              ),
            );
            // Thoát khỏi màn hình Chi tiết phòng để quay về danh sách tổng
            navigator.pop();
          } else if (vm.phongSaveState is PhongSaveError) {
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text("Xóa thất bại: ${(vm.phongSaveState as PhongSaveError).messageError}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
}