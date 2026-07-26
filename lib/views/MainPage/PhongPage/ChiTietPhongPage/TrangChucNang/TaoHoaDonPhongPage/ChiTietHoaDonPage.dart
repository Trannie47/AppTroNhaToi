import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/hoa_don_phong_provider.dart';
import '../../../../../../Provider/phieu_thu_dien_nuoc_provider.dart';
import '../../../../../../core/utils/currency_formatter.dart';
import '../../../../../../core/utils/date_formatter.dart';
import '../../../../../../modelviews/MainPage/KhacPage/taoHoaDonPhongPage/ChiTietHoaDonPhongViewModel.dart';

import '../../../../../../widgets/app_confirm_dialog.dart';

import 'CapNhatThanhToanDialog.dart';
import 'CapNhatThanhToanDienNuocDialog.dart';

class ChiTietHoaDonPage extends StatefulWidget {
  final int phongId;
  final String thangNam;

  const ChiTietHoaDonPage({
    super.key,
    required this.phongId,
    required this.thangNam,
    String? maHoaDon,
    String? chiTietJson,
  });

  @override
  State<ChiTietHoaDonPage> createState() => _ChiTietHoaDonPageState();
}

class _ChiTietHoaDonPageState extends State<ChiTietHoaDonPage> {
  late ChiTietHoaDonPhongViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HoadonPhongProvider>(context, listen: false);
    _viewModel = ChiTietHoaDonPhongViewModel(provider: provider);

    _viewModel.fetchInvoicesByPhong(
      pId: widget.phongId,
      tNam: widget.thangNam,
    );
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, true);
      },
      child: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<ChiTietHoaDonPhongViewModel>(
          builder: (context, vm, child) {
            return Scaffold(
              backgroundColor: const Color(0xffF4F6F8),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
                  onPressed: () => Navigator.pop(context, true),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Danh sách Hóa đơn - Phòng ${widget.phongId}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      "Kỳ hóa đơn: Tháng ${widget.thangNam} (${vm.listHoaDon.length} hóa đơn)",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              body: vm.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xff2E7D32)))
                  : vm.listHoaDon.isEmpty
                  ? const Center(
                child: Text(
                  "Chưa có hóa đơn nào được lập cho phòng này!",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vm.listHoaDon.length,
                itemBuilder: (context, index) {
                  final item = vm.listHoaDon[index];
                  return _buildInvoiceCardItem(item, index, vm);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInvoiceCardItem(Map<String, dynamic> item, int index, ChiTietHoaDonPhongViewModel vm) {
    final bool isDienNuoc = item['isDienNuoc'] == true;
    final int trangThai = item['trangThai'] ?? 0;
    final String hoTen = item['hoTen'] ?? 'Khách thuê';
    final String hopDongId = item['hopDongId'] ?? '';
    final String maHoaDon = item['maHoaDon'] ?? '';
    final double tongTien = (item['tongTien'] as num?)?.toDouble() ?? 0;
    final double tongDaThu = (item['tongDaThu'] as num?)?.toDouble() ?? 0;
    final double conNo = (item['conNo'] as num?)?.toDouble() ?? (tongTien - tongDaThu > 0 ? tongTien - tongDaThu : 0);

    final double tongTienPhong = (item['tongTienPhong'] as num?)?.toDouble() ?? 0;
    final double tienDichVuKhac = (item['tienDichVuKhac'] as num?)?.toDouble() ?? 0;
    final List danhSachXe = item['danhSachXe'] ?? [];
    final double tongTienXe = danhSachXe.fold(0.0, (sum, x) => sum + ((x['price'] as num?)?.toDouble() ?? 0));

    String statusText = "CHƯA THANH TOÁN";
    Color statusBg = Colors.red.shade50;
    Color statusBorder = Colors.red.shade200;
    Color statusColor = Colors.red.shade700;

    if (trangThai == 2) {
      statusText = "ĐÃ THANH TOÁN";
      statusBg = Colors.green.shade50;
      statusBorder = Colors.green.shade300;
      statusColor = const Color(0xff2E7D32);
    } else if (trangThai == 1) {
      statusText = "THANH TOÁN 1 PHẦN";
      statusBg = Colors.orange.shade50;
      statusBorder = Colors.orange.shade300;
      statusColor = Colors.orange.shade800;
    }

    String ngayLapFormatted = "";
    if (item['ngayLap'] != null) {
      DateTime? parsedDate = DateTime.tryParse(item['ngayLap'].toString());
      ngayLapFormatted = formatDate(parsedDate);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDienNuoc ? Colors.blue.shade200 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDienNuoc ? const Color(0xffEBF3FE) : const Color(0xffF8F9FA),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: isDienNuoc ? Colors.blue.shade100 : Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDienNuoc ? "Hóa đơn Điện Nước - ${item['tenPhong']}" : "Hóa đơn - $hoTen",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDienNuoc ? const Color(0xff1565C0) : const Color(0xff2E7D32),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Mã HD: $maHoaDon",
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusBorder),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                if (trangThai == 0)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () => _confirmDeleteInvoice(item, vm),
                    tooltip: "Xóa hóa đơn",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),

          // BODY CHI TIẾT CÁC KHOẢN PHÍ
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Phòng:", item['tenPhong'] ?? 'Phòng ${widget.phongId}'),
                if (!isDienNuoc) ...[
                  const SizedBox(height: 4),
                  _buildDetailRow("Khách thuê:", "$hoTen ${hopDongId.isNotEmpty ? "($hopDongId)" : ""}"),
                ],
                const SizedBox(height: 4),
                _buildDetailRow("Ngày lập:", ngayLapFormatted),

                if (isDienNuoc && item['chiTietDienNuoc'] != null) ...[
                  const SizedBox(height: 12),
                  _buildDienNuocSection(item['chiTietDienNuoc']),
                ],

                if (!isDienNuoc) ...[
                  const SizedBox(height: 12),
                  const Text("Chi tiết các khoản phí:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff2E7D32))),
                  const SizedBox(height: 6),

                  // 1. Tiền phòng
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xffFAFAFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("• Tiền phòng", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(formatMoney(tongTienPhong), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff2E7D32))),
                          ],
                        ),
                        if (item['formulaText'] != null && item['formulaText'].toString().isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item['formulaText'].toString(),
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.3),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 2. Tiền xe
                  if (danhSachXe.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("• Tiền gửi xe (${danhSachXe.length} chiếc)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              Text(formatMoney(tongTienXe), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff2E7D32))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...danhSachXe.map((xe) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("- ${xe['hangXe'] ?? 'Xe'} (${xe['bienSo'] ?? ''})", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                                Text(formatMoney(xe['price']), style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],

                  // 3. Dịch vụ phát sinh
                  if (tienDichVuKhac > 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("• Dịch vụ phát sinh thêm", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(formatMoney(tienDichVuKhac), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff2E7D32))),
                        ],
                      ),
                    ),
                  ],
                ],

                if (item['ghiChu'] != null && item['ghiChu'].toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Ghi chú: ${item['ghiChu']}",
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black54),
                  ),
                ],

                const Divider(height: 20),

                // SUMMARY FOOTER
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Tổng hóa đơn:", formatMoney(tongTien)),
                      const SizedBox(height: 4),
                      _buildDetailRow("Đã thu:", formatMoney(tongDaThu)),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "CÒN LẠI PHẢI NỘP:",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          Text(
                            formatMoney(conNo),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: conNo > 0 ? Colors.red.shade700 : const Color(0xff2E7D32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FOOTER BUTTONS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFA),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => vm.exportOrSharePdf(item),
                    icon: const Icon(Icons.download_rounded, size: 16, color: Colors.black87),
                    label: const Text(
                      "Lưu về máy",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isDienNuoc) {
                        final int lanGhi = item['lanGhi'] ?? 1;

                        final bool? reloaded = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => CapNhatThanhToanDienNuocDialog(
                            phongId: widget.phongId,
                            thangNam: widget.thangNam,
                            lanGhi: lanGhi,
                            tenPhong: item['tenPhong'] ?? "Phòng ${widget.phongId}",
                            tongTienDN: tongTien,
                            trangThaiHienTai: trangThai,
                          ),
                        );

                        if (reloaded == true && mounted) {
                          vm.fetchInvoicesByPhong(pId: widget.phongId, tNam: widget.thangNam);
                        }
                      } else {
                        final bool? reloaded = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => CapNhatThanhToanDialog(
                            maHoaDon: maHoaDon,
                            hoTenKhach: hoTen,
                            tenPhong: item['tenPhong'] ?? "Phòng ${widget.phongId}",
                            tongTienHD: tongTien,
                            tongDaThu: tongDaThu,
                            trangThaiHienTai: trangThai,
                          ),
                        );

                        if (reloaded == true && mounted) {
                          vm.fetchInvoicesByPhong(pId: widget.phongId, tNam: widget.thangNam);
                        }
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    label: const Text(
                      "Cập nhật",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDienNuoc ? const Color(0xff1565C0) : const Color(0xff2E7D32),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDienNuocSection(Map<String, dynamic> dn) {
    final dien = dn['dien'] ?? {};
    final nuoc = dn['nuoc'] ?? {};

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffF0F7FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          _buildMeterRow(
            label: "Điện (kWh)",
            cu: dien['cu'],
            moi: dien['moi'],
            suDung: dien['suDung'],
            donGia: dien['donGia'],
            thanhTien: dien['thanhTien'],
          ),
          const Divider(height: 16),
          _buildMeterRow(
            label: "Nước (m³)",
            cu: nuoc['cu'],
            moi: nuoc['moi'],
            suDung: nuoc['suDung'],
            donGia: nuoc['donGia'],
            thanhTien: nuoc['thanhTien'],
          ),
        ],
      ),
    );
  }

  Widget _buildMeterRow({
    required String label,
    dynamic cu,
    dynamic moi,
    dynamic suDung,
    dynamic donGia,
    dynamic thanhTien,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xff1565C0))),
            Text(formatMoney(thanhTien), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xff1565C0))),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Chỉ số: $cu ➔ $moi (Sử dụng: $suDung)", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            Text("Đơn giá: ${formatMoney(donGia)}", style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  void _confirmDeleteInvoice(Map<String, dynamic> item, ChiTietHoaDonPhongViewModel vm) {
    final bool isDienNuoc = item['isDienNuoc'] == true;
    final String maHD = item['maHoaDon'] ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: "Xác nhận xóa hóa đơn",
        content: isDienNuoc
            ? "Bạn có chắc chắn muốn xóa hóa đơn điện nước này không? Dữ liệu sẽ được đưa về trạng thái nháp để chốt lại."
            : "Bạn có chắc chắn muốn xóa hóa đơn $maHD này không? Hợp đồng liên quan sẽ được đưa về trạng thái chờ tạo hóa đơn.",
        textConfirm: "Xóa bỏ",
        textCancel: "Quay lại",
        isDangerous: true,
        onConfirm: () async {
          Navigator.pop(ctx);

          if (isDienNuoc) {
            final int lanGhi = item['lanGhi'] ?? 1;
            final dnProvider = Provider.of<PhieuThuDienNuocProvider>(context, listen: false);

            final success = await dnProvider.removePhieuThuDienNuoc(
              phongId: widget.phongId,
              thangNam: widget.thangNam,
              lanGhi: lanGhi,
            );

            if (mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa hóa đơn điện nước thành công!"), backgroundColor: Colors.green),
                );
                vm.fetchInvoicesByPhong(pId: widget.phongId, tNam: widget.thangNam);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(dnProvider.errorMessage ?? "Xóa thất bại!"), backgroundColor: Colors.red),
                );
              }
            }
          } else {
            final success = await vm.deleteHoaDonByMa(maHD);
            if (mounted) {
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa hóa đơn thành công!"), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(vm.errorMessage ?? "Xóa thất bại!"), backgroundColor: Colors.red),
                );
              }
            }
          }
        },
      ),
    );
  }
}