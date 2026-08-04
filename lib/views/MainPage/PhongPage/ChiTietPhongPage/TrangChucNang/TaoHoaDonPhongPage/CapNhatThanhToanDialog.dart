import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/phieu_thu_hang_thang_provider.dart';
import '../../../../../../core/utils/currency_formatter.dart';
import '../../../../../../modelviews/MainPage/KhacPage/taoHoaDonPhongPage/capNhatThanhToanDialogViewModel.dart';

class CapNhatThanhToanDialog extends StatelessWidget {
  final String maHoaDon;
  final String hoTenKhach;
  final String tenPhong;
  final double tongTienHD;
  final double tongDaThu;
  final int trangThaiHienTai;

  const CapNhatThanhToanDialog({
    super.key,
    required this.maHoaDon,
    required this.hoTenKhach,
    required this.tenPhong,
    required this.tongTienHD,
    required this.tongDaThu,
    required this.trangThaiHienTai,
  });

  @override
  Widget build(BuildContext context) {
    final phieuThuProvider = context.read<PhieuThuHangThangProvider>();

    return ChangeNotifierProvider(
      create: (_) => CapNhatThanhToanViewModel(
        phieuThuProvider: phieuThuProvider,
        maHoaDon: maHoaDon,
        tongTienHD: tongTienHD,
        tongDaThu: tongDaThu,
        trangThaiBanDau: trangThaiHienTai,
      ),
      child: Consumer<CapNhatThanhToanViewModel>(
        builder: (context, vm, child) {
          bool isPaidFull =
              vm.conThieu <= 0; // Kiểm tra xem đã thanh toán đủ hay chưa

          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Thu tiền Hóa đơn",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2E7D32),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$hoTenKhach - $tenPhong",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // CARD TỔNG QUAN TIỀN
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tổng tiền còn thiếu:",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(vm.conThieu),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (isPaidFull) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xff2E7D32),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Hóa đơn này đã được thanh toán!",
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // NÚT ĐÓNG KHI ĐÃ THANH TOÁN XONG
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "HỦY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      "Ghi chú thu tiền:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.txtGhiChu,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "VD: Đã thu tiền mặt / chuyển khoản...",
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Color(0xff2E7D32),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    if (vm.errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        vm.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Hủy",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    final success = await vm.submitPhieuThu();
                                    if (context.mounted && success) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2E7D32),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "XÁC NHẬN THU TIỀN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
