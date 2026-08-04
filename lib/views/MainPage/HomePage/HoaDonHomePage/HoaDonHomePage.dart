import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import '../../../../modelviews/MainPage/HomePage/HoaDonHomePage/HoaDonHomePageViewModel.dart';
import '../../PhongPage/ChiTietPhongPage/TrangChucNang/TaoHoaDonPhongPage/CapNhatThanhToanDialog.dart';
import '../../PhongPage/ChiTietPhongPage/TrangChucNang/TaoHoaDonPhongPage/CapNhatThanhToanDienNuocDialog.dart';

class HoaDonHomePage extends StatefulWidget {
  const HoaDonHomePage({super.key});

  @override
  State<HoaDonHomePage> createState() => _HoaDonHomePageState();
}

class _HoaDonHomePageState extends State<HoaDonHomePage> {
  late HoaDonHomePageViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HoaDonHomePageViewModel(
      hoaDonProvider: context.read<HoadonPhongProvider>(),
    );
    _viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          leadingWidth: 40,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: const Text(
            "Quản lý tất cả hóa đơn",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<HoaDonHomePageViewModel>(
          builder: (context, vm, child) {
            final filteredList = vm.filteredList;

            // Tính toán tổng tiền thực tế từ dữ liệu trả về của backend
            double tongDaThu = filteredList
                .where((e) => (e['trangThai'] ?? 0) == 2)
                .fold(
                  0,
                  (sum, item) =>
                      sum + ((item['soTien'] as num?)?.toDouble() ?? 0),
                );
            double tongChuaThu = filteredList
                .where((e) => (e['trangThai'] ?? 0) != 2)
                .fold(
                  0,
                  (sum, item) =>
                      sum + ((item['soTien'] as num?)?.toDouble() ?? 0),
                );

            return Column(
              children: [
                // 1. THANH TỔNG QUAN TÀI CHÍNH
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xffEAF3EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Đã thu",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff2D7A3A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatMoney(tongDaThu),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2D7A3A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFEAEA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Còn nợ / Chưa thu",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatMoney(tongChuaThu),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F3F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) => vm.setSearchQuery(val),
                                decoration: const InputDecoration(
                                  hintText:
                                      "Tìm theo số phòng, tên người thuê, mã HĐ...",
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Kỳ hóa đơn: ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                            onTap: () => vm.chonKyHoaDon(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffEAF3EB),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xffC8E6C9),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    size: 16,
                                    color: Color(0xff2D7A3A),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Tháng ${vm.selectedThangNam}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2D7A3A),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    size: 18,
                                    color: Color(0xff2D7A3A),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      _buildFilterTab(vm, "Tất cả", -1),
                      const SizedBox(width: 8),
                      _buildFilterTab(vm, "Chưa thanh toán", 0),
                      const SizedBox(width: 8),
                      _buildFilterTab(vm, "Đã thanh toán", 2),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: vm.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff2D7A3A),
                          ),
                        )
                      : filteredList.isEmpty
                      ? const Center(
                          child: Text(
                            "Không tìm thấy hóa đơn nào phù hợp",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return _buildItemHoaDon(context, item, vm);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterTab(
    HoaDonHomePageViewModel vm,
    String title,
    int filterValue,
  ) {
    bool isSelected = vm.selectedFilter == filterValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setFilter(filterValue),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff2D7A3A)
                : const Color(0xffF1F3F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemHoaDon(
    BuildContext context,
    Map<String, dynamic> item,
    HoaDonHomePageViewModel vm,
  ) {
    final bool isDienNuoc =
        item['chiTietJson'] != null &&
        item['chiTietJson'].toString().contains('"type":"DIEN_NUOC"');

    final int trangThai = item['trangThai'] ?? 0;
    bool isPaid = trangThai == 2;

    final String tenPhong = item['tenPhong'] ?? '';
    final String hoTenKhach = item['hoTenKhach'] ?? 'Khách thuê';
    final String thangNam = item['thangNam'] ?? '';
    final String maHoaDon = item['maHoaDon'] ?? '';
    final double soTien = (item['soTien'] as num?)?.toDouble() ?? 0;
    final double tongDaThu = (item['tongDaThu'] as num?)?.toDouble() ?? 0;

    String? ghiChuThu;
    if (item['phieuThuHangThang'] != null && item['phieuThuHangThang'] is Map) {
      ghiChuThu = item['phieuThuHangThang']['ghiChu']?.toString();
    }
    ghiChuThu ??= item['ghiChuThu']?.toString();
    String? ngayThuStr;
    if (item['phieuThuHangThang'] != null && item['phieuThuHangThang'] is Map) {
      final rawNgayThu = item['phieuThuHangThang']['ngayThu']?.toString();
      if (rawNgayThu != null && rawNgayThu.isNotEmpty) {
        try {
          final parsedDate = DateTime.parse(rawNgayThu);
          ngayThuStr =
              "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
        } catch (_) {
          ngayThuStr = rawNgayThu.substring(0, 10);
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffECECEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDienNuoc
                          ? const Color(0xffEAF3EB)
                          : const Color(0xffFFF1E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isDienNuoc ? Icons.bolt : Icons.receipt_long,
                      color: isDienNuoc
                          ? const Color(0xff2D7A3A)
                          : const Color(0xffFF8A00),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isDienNuoc
                                ? "Điện nước - Phòng $tenPhong"
                                : hoTenKhach,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF1F3F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isDienNuoc ? "Điện nước" : "Tiền phòng",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDienNuoc
                            ? "Kỳ: $thangNam · Chi phí chung phòng"
                            : "Phòng $tenPhong · Kỳ: $thangNam · Mã: $maHoaDon",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xffEAF3EB)
                      : const Color(0xffFFEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? "Đã thu" : "Chưa thu",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? const Color(0xff2D7A3A) : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xffF1F1F1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDienNuoc
                    ? "Khoản thu chung của phòng"
                    : "Hợp đồng thuê phòng",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Row(
                children: [
                  Text(
                    formatMoney(soTien),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? const Color(0xff2D7A3A) : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!isPaid)
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool? reloaded = false;

                          if (isDienNuoc) {
                            int lanGhi = 1;
                            try {
                              if (maHoaDon.contains('L')) {
                                final parts = maHoaDon.split('L');
                                if (parts.length > 1) {
                                  lanGhi = int.tryParse(parts.last) ?? 1;
                                }
                              } else if (item['chiTietJson'] != null) {
                                final parsed = item['chiTietJson'] is String
                                    ? jsonDecode(item['chiTietJson'])
                                    : item['chiTietJson'];
                                lanGhi =
                                    int.tryParse(parsed['lanGhi'].toString()) ??
                                    1;
                              }
                            } catch (_) {}

                            int pId = 1;
                            try {
                              final parts = maHoaDon.split('-');
                              if (parts.length >= 3) {
                                pId = int.tryParse(parts[2]) ?? 1;
                              }
                            } catch (_) {}

                            reloaded = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => CapNhatThanhToanDienNuocDialog(
                                phongId: pId,
                                thangNam: thangNam,
                                lanGhi: lanGhi,
                                tenPhong: "Phòng $tenPhong",
                                tongTienDN: soTien,
                                trangThaiHienTai: trangThai,
                              ),
                            );
                          } else {
                            reloaded = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => CapNhatThanhToanDialog(
                                maHoaDon: maHoaDon,
                                hoTenKhach: hoTenKhach,
                                tenPhong: "Phòng $tenPhong",
                                tongTienHD: soTien,
                                tongDaThu: tongDaThu,
                                trangThaiHienTai: trangThai,
                              ),
                            );
                          }

                          if (reloaded == true && context.mounted) {
                            vm.loadData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2D7A3A),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Thu tiền",
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          if ((ngayThuStr != null && ngayThuStr.isNotEmpty) ||
              (ghiChuThu != null && ghiChuThu.isNotEmpty)) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xffEEEEEE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ngayThuStr != null && ngayThuStr.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: Color(0xff616161),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Ngày thu: $ngayThuStr",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    if (ghiChuThu != null && ghiChuThu.isNotEmpty)
                      const SizedBox(height: 4),
                  ],
                  if (ghiChuThu != null && ghiChuThu.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          size: 13,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Ghi chú: $ghiChuThu",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
