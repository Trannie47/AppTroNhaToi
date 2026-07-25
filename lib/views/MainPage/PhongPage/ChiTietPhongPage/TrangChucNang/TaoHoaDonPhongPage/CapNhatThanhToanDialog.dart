import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/phieu_thu_hang_thang_provider.dart';

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
                            const Text(
                              "Cập nhật thanh toán",
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "$hoTenKhach - $tenPhong",
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

                  // CARD TỔNG QUAN TIỀN
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("Tổng hóa đơn:", _formatMoney(vm.tongTienHD), Colors.black87),
                        const SizedBox(height: 4),
                        _buildPriceRow("Đã thu trước đó:", _formatMoney(vm.tongDaThu), Colors.blue.shade700),
                        const Divider(height: 12),
                        _buildPriceRow("Còn thiếu:", _formatMoney(vm.conThieu), Colors.red.shade700, isBold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text("Hình thức thu tiền:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),

                  // 🟢 3 LỰA CHỌN TRẠNG THÁI
                  Row(
                    children: [
                      _buildModeOption(
                        vm,
                        modeVal: 0,
                        label: "Chưa thu",
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 6),
                      _buildModeOption(
                        vm,
                        modeVal: 1,
                        label: "Thu 1 phần",
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 6),
                      _buildModeOption(
                        vm,
                        modeVal: 2,
                        label: "Thu đủ 100%",
                        color: const Color(0xff2E7D32),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Ô NHẬP SỐ TIỀN THU (Chỉ sửa được khi chọn Thu 1 phần)
                  const Text("Số tiền thu đợt này (VNĐ):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: vm.txtSoTienNop,
                    keyboardType: TextInputType.number,
                    enabled: vm.mode == 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: vm.mode == 0 ? Colors.grey : const Color(0xff2E7D32),
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      suffixText: "đ",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: vm.mode != 1,
                      fillColor: vm.mode != 1 ? Colors.grey.shade100 : Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // GHI CHÚ THU TIỀN
                  const Text("Ghi chú thu tiền:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: vm.txtGhiChu,
                    enabled: vm.mode != 0,
                    decoration: InputDecoration(
                      hintText: "VD: Khách chuyển khoản VCB...",
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: vm.mode == 0,
                      fillColor: vm.mode == 0 ? Colors.grey.shade100 : Colors.white,
                    ),
                  ),

                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // NÚT BẤM DƯỚI ĐÁY
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: vm.isLoading || vm.mode == 0
                              ? null
                              : () async {
                            final success = await vm.submitPhieuThu();
                            if (context.mounted && success) {
                              Navigator.pop(context, true); // Trả về true để reload UI
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vm.mode == 0 ? Colors.grey : const Color(0xff2E7D32),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text("LƯU PHIẾU THU", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
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

  Widget _buildModeOption(CapNhatThanhToanViewModel vm, {required int modeVal, required String label, required Color color}) {
    bool isSelected = vm.mode == modeVal;
    return Expanded(
      child: InkWell(
        onTap: () => vm.setMode(modeVal),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: isSelected ? 1.8 : 1),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String val, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(val, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}