import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/phieu_thu_hang_thang_provider.dart';
import '../../../../../../core/utils/currency_formatter.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../models/phieu_thu_hang_thang.dart';
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
        trangThaiHienTai: trangThaiHienTai,
      ),
      child: Consumer<CapNhatThanhToanViewModel>(
        builder: (context, vm, child) {
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(context, vm),
                      const Divider(height: 16),
                      _tongQuanCard(vm),
                      const SizedBox(height: 14),
                      _lichSuThanhToanSection(vm),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axisAlignment: -1,
                                child: child,
                              ),
                            ),
                        child: vm.daThanhToanDu
                            ? _daThanhToanDuView(context, vm)
                            : _formThuTienView(context, vm),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, CapNhatThanhToanViewModel vm) {
    return Row(
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
    );
  }

  Widget _tongQuanCard(CapNhatThanhToanViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: _thongKeCot(
              "Tổng hóa đơn",
              vm.tongTienHD,
              Colors.black87,
            ),
          ),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          Expanded(
            child: _thongKeCot(
              "Đã thu",
              vm.tongDaThu,
              const Color(0xff2E7D32),
            ),
          ),
          Container(width: 1, height: 30, color: Colors.grey.shade300),
          Expanded(
            child: _thongKeCot(
              "Còn nợ",
              vm.conThieu,
              vm.conThieu > 0 ? Colors.red.shade700 : const Color(0xff2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thongKeCot(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            formatMoney(value),
            key: ValueKey(value),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _trangThaiSelector(CapNhatThanhToanViewModel vm) {
    final tuyChon = [
      (
        LuaChonThanhToan.chuaThanhToan,
        "Chưa\nthanh toán",
        Colors.grey.shade700,
        Colors.grey.shade200,
      ),
      (
        LuaChonThanhToan.motPhan,
        "Thanh toán\n1 phần",
        Colors.orange.shade800,
        Colors.orange.shade100,
      ),
      (
        LuaChonThanhToan.du,
        "Thanh toán\nđủ",
        const Color(0xff2E7D32),
        Colors.green.shade100,
      ),
    ];

    return Row(
      children: [
        for (final o in tuyChon)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: o.$1 != LuaChonThanhToan.du ? 8 : 0,
              ),
              child: GestureDetector(
                onTap: () => vm.chonHinhThucThanhToan(o.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: vm.luaChonThanhToan == o.$1
                        ? o.$4
                        : const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: vm.luaChonThanhToan == o.$1
                          ? o.$3
                          : Colors.grey.shade300,
                      width: vm.luaChonThanhToan == o.$1 ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    o.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: vm.luaChonThanhToan == o.$1
                          ? o.$3
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _lichSuThanhToanSection(CapNhatThanhToanViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lịch sử thu tiền:",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: vm.isLoadingHistory
              ? const Padding(
                  key: ValueKey("loading"),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : vm.lichSuThanhToan.isEmpty
              ? Container(
                  key: const ValueKey("empty"),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    "Chưa có lần thu tiền nào",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                )
              : Container(
                  key: ValueKey(vm.lichSuThanhToan.length),
                  constraints: const BoxConstraints(maxHeight: 160),
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    itemCount: vm.lichSuThanhToan.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 10, color: Colors.grey.shade200),
                    itemBuilder: (context, index) =>
                        _phieuThuRow(vm.lichSuThanhToan[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _phieuThuRow(PhieuThuHangThang phieuThu) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDate(phieuThu.ngayThu),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                if (phieuThu.ghiChu != null &&
                    phieuThu.ghiChu!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    phieuThu.ghiChu!,
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            "+${formatMoney(phieuThu.soTien)}",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xff2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _daThanhToanDuView(BuildContext context, CapNhatThanhToanViewModel vm) {
    return Column(
      key: const ValueKey("da-thanh-toan-du"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              const Icon(Icons.check_circle, color: Color(0xff2E7D32), size: 20),
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
              "ĐÓNG",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formThuTienView(BuildContext context, CapNhatThanhToanViewModel vm) {
    final coHienThiForm =
        vm.luaChonThanhToan != LuaChonThanhToan.chuaThanhToan;

    return Column(
      key: const ValueKey("form-thu-tien"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hình thức thu tiền:",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _trangThaiSelector(vm),
        const SizedBox(height: 14),

        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !coHienThiForm
              ? const SizedBox(key: ValueKey("form-an"), width: double.infinity)
              : Column(
                  key: const ValueKey("form-hien"),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Số tiền thu:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.txtSoTien,
                      enabled: vm.luaChonThanhToan != LuaChonThanhToan.du,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DinhDangGiaVN(),
                      ],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "Nhập số tiền...",
                        suffixText: "đ",
                        filled: vm.luaChonThanhToan == LuaChonThanhToan.du,
                        fillColor: Colors.grey.shade100,
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
                    const SizedBox(height: 14),
                    const Text(
                      "Ghi chú thu tiền:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.txtGhiChu,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "VD: Đã thu tiền mặt / chuyển khoản...",
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
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
                  ],
                ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: vm.errorMessage != null
              ? Padding(
                  key: ValueKey(vm.errorMessage),
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),

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
                onPressed: (!coHienThiForm || vm.isLoading)
                    ? null
                    : () async {
                        final success = await vm.submitPhieuThu();
                        if (context.mounted && success) {
                          Navigator.pop(context, true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2E7D32),
                  disabledBackgroundColor: Colors.grey.shade300,
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
    );
  }
}
