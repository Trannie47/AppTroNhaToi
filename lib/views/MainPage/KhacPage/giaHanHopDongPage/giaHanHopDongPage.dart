import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/hop_dong_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../modelviews/MainPage/KhacPage/giaHanHopDongPage/giaHanHopDongPageViewModel.dart';
import '../../../../widgets/app_confirm_dialog.dart';

class GiaHanHopDongPage extends StatefulWidget {
  final HopDongDTO hopDong;

  const GiaHanHopDongPage({super.key, required this.hopDong});

  @override
  State<GiaHanHopDongPage> createState() => _GiaHanHopDongPageState();
}

class _GiaHanHopDongPageState extends State<GiaHanHopDongPage> {
  late GiaHanHopDongViewModel vm;

  @override
  void initState() {
    super.initState();
    final hopDongProvider = Provider.of<HopDongProvider>(
      context,
      listen: false,
    );
    vm = GiaHanHopDongViewModel(hopDongProvider, widget.hopDong);
    vm.init();

    //Kiểm tra ngay khi vừa mở trang: Nếu còn > 30 ngày -> Báo SnackBar và bật ra ngoài
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.kiemTraHopDongKhaDungGiaHan()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage ?? "Hợp đồng chưa tới đợt gia hạn!"),
            backgroundColor: Colors.orange.shade800,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context); // Thoát trang ngay lập tức
      }
    });

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void _xuLySubmitGiaHan() async {
    final success = await vm.giaHanHopDong();
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gia hạn hợp đồng thành công!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(
        context,
        true,
      ); // Trả về true để màn hình danh sách/chi tiết reload
    } else if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage!),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: const Color(0xffF3F3F3),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _hienThiXacNhanThoat(),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: 14),
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              "Gia hạn hợp đồng",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _section(
                  title: "Thông tin hợp đồng hiện tại",
                  child: Column(
                    children: [
                      _infoRow("Phòng thuê:", widget.hopDong.phong.tenPhong),
                      const SizedBox(height: 8),
                      _infoRow("Người thuê:", widget.hopDong.nguoithue.hoTen),
                      const SizedBox(height: 8),
                      _infoRow(
                        "Giá thuê:",
                        "${formatMoney(widget.hopDong.giaPhongThucTe.toInt())} đ/tháng",
                      ),
                      const SizedBox(height: 8),
                      _infoRow(
                        "Hạn hợp đồng hiện tại:",
                        formatDate(widget.hopDong.ngayHetHan),
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Thiết lập thời hạn gia hạn",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gia hạn nhanh:",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          _chipOption(
                            "+ 3 Tháng",
                            3,
                            () => vm.chonNhanhThang(3),
                          ),
                          const SizedBox(width: 8),
                          _chipOption(
                            "+ 6 Tháng",
                            6,
                            () => vm.chonNhanhThang(6),
                          ),
                          const SizedBox(width: 8),
                          _chipOption(
                            "+ 12 Tháng",
                            12,
                            () => vm.chonNhanhThang(12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Text(
                        "Ngày hết hạn mới (Tối thiểu gia hạn 3 tháng)",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: vm.txtNgayHetHanMoi,
                        readOnly: true,
                        decoration: InputDecoration(
                          errorText: vm.errNgayHetHanMoi,
                          filled: true,
                          fillColor: const Color(0xffF8F8F8),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Color(0xff2E7D32),
                            ),
                            onPressed: () => vm.chonNgay(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xffEAEAEA),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xff2D7A3A),
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Ghi chú (Tùy chọn)",
                  child: TextFormField(
                    controller: vm.txtGhiChu,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Nhập ghi chú gia hạn nếu có...",
                      filled: true,
                      fillColor: const Color(0xffF7F7F7),
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff2D7A3A),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Ảnh Hợp đồng gia hạn (Tùy chọn)",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vm.listImagePhuLuc.isEmpty)
                        InkWell(
                          onTap: vm.selectImages,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.grey.shade600,
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Chạm để thêm ảnh ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...List.generate(vm.listImagePhuLuc.length, (
                              index,
                            ) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      vm.listImagePhuLuc[index],
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: InkWell(
                                      onTap: () => vm.deleteImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            InkWell(
                              onTap: vm.selectImages,
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey.shade600,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: vm.isLoading ? null : _xuLySubmitGiaHan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Xác nhận gia hạn",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // NÚT HỦY BỎ
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _hienThiXacNhanThoat(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC62828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Hủy bỏ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (vm.isLoading)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withOpacity(0.45),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Đang gia hạn...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2E7D32),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isHighlight ? const Color(0xffE65100) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _chipOption(String text, int soThang, VoidCallback onTap) {
    final isSelected = vm.selectedMonthOption == soThang;

    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color(0xff2E7D32)
              : Colors.transparent,
          side: const BorderSide(color: Color(0xff2E7D32)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff2E7D32),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _hienThiXacNhanThoat() async {
    if (!vm.coThayDoi) {
      Navigator.pop(context);
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: "Thoát khỏi trang?",
        content: "Thông tin bạn vừa nhập sẽ không được lưu.",
        textConfirm: "Thoát",
        textCancel: "Ở lại",
        isDangerous: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
      ),
    );
    if (confirm == true && mounted) {
      Navigator.pop(context);
    }
  }
}
