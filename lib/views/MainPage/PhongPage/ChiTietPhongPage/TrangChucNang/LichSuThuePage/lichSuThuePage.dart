import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/TrangChucNang/LichSuThuePage/lichSuThuePageViewModel.dart';

class LichSuThuePage extends StatelessWidget {
  final int phongId;
  final String tenPhong;

  const LichSuThuePage({
    super.key,
    required this.phongId,
    required this.tenPhong,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final provider = ctx.read<HopDongProvider>();
        final vm = LichSuThuePageViewModel(provider);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.init(phongId);
        });
        return vm;
      },
      child: _LichSuThueView(phongId: phongId, tenPhong: tenPhong),
    );
  }
}

class _LichSuThueView extends StatelessWidget {
  final int phongId;
  final String tenPhong;

  const _LichSuThueView({required this.phongId, required this.tenPhong});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LichSuThuePageViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildBody(context, vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch sử thuê',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Phòng $tenPhong',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, LichSuThuePageViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff4B7A47)),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => vm.init(phongId),
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4B7A47),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (vm.dsLichSu.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "Chưa có lịch sử thuê cho phòng này",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.dsLichSu.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildContractCard(context, vm.dsLichSu[index]),
        );
      },
    );
  }

  Widget _buildContractCard(BuildContext context, HopDongDTO contract) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    String getInitials(String name) {
      List<String> nameParts = name.trim().split(' ');
      if (nameParts.length > 1) {
        return nameParts[0].substring(0, 1).toUpperCase() +
            nameParts.last.substring(0, 1).toUpperCase();
      } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
        return nameParts[0]
            .substring(0, nameParts[0].length >= 2 ? 2 : 1)
            .toUpperCase();
      }
      return '??';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Xử lý xem chi tiết hợp đồng
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hàng 1: Avatar + Tên/SĐT + Nhãn cố định "Đã kết thúc"
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xff4B7A47).withOpacity(0.1),
                    child: Text(
                      getInitials(contract.nguoithue.hoTen),
                      style: const TextStyle(
                        color: Color(0xff4B7A47),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contract.nguoithue.hoTen,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contract.nguoithue.soDienThoai,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 🔥 ĐÃ CHỈNH: Luôn hiển thị nhãn "Đã kết thúc" cố định
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Đã kết thúc',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
              const Divider(height: 1, thickness: 1, color: Color(0xffF0F0F0)),
              const SizedBox(height: 12),

              // Hàng 2: Ngày bắt đầu (ngayKy) - Ngày kết thúc (ngayHetHan)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.date_range_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${dateFormat.format(contract.ngayKy)} - ${dateFormat.format(contract.ngayHetHan)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currencyFormat.format(contract.giaPhongThucTe)}/tháng',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4B7A47),
                    ),
                  ),
                  Text(
                    'Cọc: ${currencyFormat.format(contract.tienCoc)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
