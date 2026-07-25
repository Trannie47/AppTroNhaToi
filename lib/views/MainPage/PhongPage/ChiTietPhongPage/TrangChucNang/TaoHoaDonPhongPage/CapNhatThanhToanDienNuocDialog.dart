import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/phieu_thu_dien_nuoc_provider.dart';
import '../../../../../../modelviews/MainPage/KhacPage/taoHoaDonPhongPage/capNhatThanhToanDienNuocDialogViewModel.dart';

class CapNhatThanhToanDienNuocDialog extends StatelessWidget {
  final int phongId;
  final String thangNam;
  final int lanGhi;
  final String tenPhong;
  final double tongTienDN;
  final int trangThaiHienTai;

  const CapNhatThanhToanDienNuocDialog({
    super.key,
    required this.phongId,
    required this.thangNam,
    required this.lanGhi,
    required this.tenPhong,
    required this.tongTienDN,
    required this.trangThaiHienTai,
  });

  String _formatMoney(num? amount) {
    if (amount == null) return "0đ";
    final integerPart = amount.round().toString();
    final formatted = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
    return "${formatted}đ";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PhieuThuDienNuocProvider>();

    return ChangeNotifierProvider(
      create: (_) => CapNhatThanhToanDienNuocDialogViewModel(
        provider: provider,
        phongId: phongId,
        thangNam: thangNam,
        lanGhi: lanGhi,
        tongTienDN: tongTienDN,
        trangThaiHienTai: trangThaiHienTai,
      ),
      child: Consumer<CapNhatThanhToanDienNuocDialogViewModel>(
        builder: (context, vm, child) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                            Text(
                              "Thu tiền Điện Nước - $tenPhong",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1565C0),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Kỳ tháng $thangNam (Lần $lanGhi)",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // CARD TỔNG TIỀN ĐIỆN NƯỚC
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffEBF3FE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tổng tiền Điện Nước:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(
                          _formatMoney(vm.tongTienDN),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff1565C0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (vm.isPaid) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xff2E7D32), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Hóa đơn điện nước này đã được thanh toán!",
                              style: TextStyle(color: Color(0xff2E7D32), fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Text("Ghi chú thu tiền:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.txtGhiChu,
                      decoration: InputDecoration(
                        hintText: "VD: Đã thu tiền mặt từ đại diện phòng...",
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],

                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // NÚT THAO TÁC
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Hủy", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      if (!vm.isPaid) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1565C0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                              final success = await vm.submitPhieuThuDienNuoc();
                              if (context.mounted && success) {
                                Navigator.pop(context, true);
                              }
                            },
                            child: vm.isLoading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text(
                              "XÁC NHẬN THU TIỀN",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}