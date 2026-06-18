import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/chiTietPhongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDong_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ===================== TAB DEFINITIONS =====================

const List<_TabItem> _kTabs = [
  _TabItem(icon: Icons.info_outline, label: 'Thông tin phòng'),
  _TabItem(icon: Icons.bolt, label: 'Ghi điện nước'),
  _TabItem(icon: Icons.receipt_long_outlined, label: 'Tạo hóa đơn'),
  _TabItem(icon: Icons.article_outlined, label: 'Hợp đồng'),
  _TabItem(icon: Icons.history, label: 'Lịch sử thuê'),
];

class _TabItem {
  final IconData icon;
  final String label;1
  const _TabItem({required this.icon, required this.label});
}

// ===================== PAGE =====================

class ChiTietPhongPage extends StatelessWidget {
  final Phong phongId;
  final LoaiPhong loaiPhong;

  const ChiTietPhongPage({
    super.key,
    required this.phongId,
    required this.loaiPhong,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ChiTietPhongViewModel(phong: phongId, loaiphong: loaiPhong),
      child: const _ChiTietPhongView(),
    );
  }
}

class _ChiTietPhongView extends StatelessWidget {
  const _ChiTietPhongView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChiTietPhongViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context, vm),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.errorMessage != null
          ? _ErrorView(message: vm.errorMessage!, onRetry: vm.refresh)
          : Column(
              children: [
                // ---- Status Banner ----
                if (vm.phong != null) _TrangThaiBanner(vm: vm),

                // ---- Horizontal Tab Bar ----
                _HorizontalTabBar(vm: vm),

                // ---- Tab Content ----
                Expanded(child: _TabContent(vm: vm)),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ChiTietPhongViewModel vm,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black87),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        vm.phong?.tenPhong ?? 'Chi tiết phòng',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _MoreOptionsSheet(),
    );
  }
}

// ===================== TRANG THAI BANNER =====================

class _TrangThaiBanner extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _TrangThaiBanner({required this.vm});

  @override
  Widget build(BuildContext context) {
    final phong = vm.phong!;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: vm.trangThaiColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.trangThaiText,
                style: TextStyle(
                  color: vm.trangThaiColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              // if (phong.ngayBatDauThue != null || phong.soThangConLai != null)
              //   Text(
              //     _buildSubText(phong),
              //     style: const TextStyle(color: Colors.black54, fontSize: 12),
              //   ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSubText(Phong phong) {
    //   final parts = <String>[];
    //   if (phong.ngayBatDauThue != null) {
    //     final d = phong.ngayBatDauThue!;
    //     parts.add(
    //       'Từ ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}',
    //     );
    //   }
    //   if (phong.soThangConLai != null) {
    //     parts.add('Còn ${phong.soThangConLai} tháng');
    //   }
    //   return parts.join(' · ');
    return '';
  }
}

// ===================== HORIZONTAL TAB BAR =====================

class _HorizontalTabBar extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _HorizontalTabBar({required this.vm});

  static const _kActiveColor = Color(0xFF22C55E);
  static const _kInactiveColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(_kTabs.length, (index) {
                final tab = _kTabs[index];
                final isSelected = vm.selectedTabIndex == index;
                final isGhiDienNuoc = index == 1;

                return GestureDetector(
                  onTap: () => vm.selectTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        // Tab chip
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isGhiDienNuoc
                                ? _kActiveColor
                                : isSelected
                                ? _kActiveColor.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isGhiDienNuoc || isSelected
                                ? null
                                : Border.all(
                                    color: const Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tab.icon,
                                size: 15,
                                color: isGhiDienNuoc
                                    ? Colors.white
                                    : isSelected
                                    ? _kActiveColor
                                    : _kInactiveColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected || isGhiDienNuoc
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isGhiDienNuoc
                                      ? Colors.white
                                      : isSelected
                                      ? _kActiveColor
                                      : _kInactiveColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Active indicator line
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 2.5,
                          width: isSelected ? 48 : 0,
                          decoration: BoxDecoration(
                            color: _kActiveColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
        ],
      ),
    );
  }
}

// ===================== TAB CONTENT =====================

class _TabContent extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _TabContent({required this.vm});

  @override
  Widget build(BuildContext context) {
    switch (vm.selectedTabIndex) {
      case 0:
        return _ThongTinPhongTab(vm: vm);
      case 1:
        return _GhiDienNuocTab(vm: vm);
      case 2:
        return _TaoHoaDonTab(vm: vm);
      case 3:
        return _HopDongTab(vm: vm);
      case 4:
        return _LichSuThueTab(vm: vm);
      default:
        return const SizedBox();
    }
  }
}

// ===================== TAB 0: THÔNG TIN PHÒNG =====================

class _ThongTinPhongTab extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _ThongTinPhongTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    final phong = vm.phong!;
    final loaiphong = vm.loaiphong!;
    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ---- Thông tin phòng card ----
          _SectionCard(
            title: 'Thông tin phòng',
            children: [
              _InfoRow(label: 'Loại phòng', value: loaiphong.tenLoaiPhong),
              _InfoRow(
                label: 'Diện tích',
                value: '${loaiphong.dienTich.toInt()} m²',
              ),
              _InfoRow(
                label: 'Giá thuê',
                value: '${_formatCurrency(loaiphong.giaTien)}đ/tháng',
                valueColor: const Color(0xFF22C55E),
                valueBold: true,
              ),
              _InfoRow(
                label: 'Số người tối đa',
                value: '${loaiphong.soNguoiToiDa} người',
              ),
              _InfoRow(
                label: 'Máy lạnh',
                value: loaiphong.isMayLanh ? 'Có' : 'Không',
              ),
              _InfoRow(label: 'Mô tả', value: phong.moTa ?? '', isLast: true),
            ],
          ),

          const SizedBox(height: 12),

          // ---- Người thuê card ----
          _SectionCard(
            title: 'Người thuê hiện tại (${vm.danhSachNguoiThue.length})',
            trailing: GestureDetector(
              onTap: () {},
              child: const Text(
                'Xem tất cả ›',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            children: [
              ...vm.danhSachNguoiThue.asMap().entries.map((entry) {
                final i = entry.key;
                final chiTietHopDong = entry.value;
                return _ChiTietHopDongRow(
                  chiTietHopDong: chiTietHopDong,
                  isLast: i == vm.danhSachNguoiThue.length - 1,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== TAB 1: GHI ĐIỆN NƯỚC =====================

class _GhiDienNuocTab extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _GhiDienNuocTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _ComingSoonWidget(icon: Icons.bolt, label: 'Ghi điện nước'),
    );
  }
}

// ===================== TAB 2: TẠO HÓA ĐƠN =====================

class _TaoHoaDonTab extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _TaoHoaDonTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _ComingSoonWidget(
        icon: Icons.receipt_long_outlined,
        label: 'Tạo hóa đơn',
      ),
    );
  }
}

// ===================== TAB 3: HỢP ĐỒNG =====================

class _HopDongTab extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _HopDongTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _ComingSoonWidget(icon: Icons.article_outlined, label: 'Hợp đồng'),
    );
  }
}

// ===================== TAB 4: LỊCH SỬ THUÊ =====================

class _LichSuThueTab extends StatelessWidget {
  final ChiTietPhongViewModel vm;
  const _LichSuThueTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _ComingSoonWidget(icon: Icons.history, label: 'Lịch sử thuê'),
    );
  }
}

// ===================== SHARED WIDGETS =====================

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 12, thickness: 0.5),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueBold ? FontWeight.w600 : FontWeight.w400,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _ChiTietHopDongRow extends StatelessWidget {
  final chiTietHopDongModel chiTietHopDong;
  final bool isLast;

  const _ChiTietHopDongRow({required this.chiTietHopDong, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final initials = chiTietHopDong.nguoiThue.hoTen
        ?.split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: _avatarColor(initials ?? ''),
                child: Text(
                  initials ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chiTietHopDong.nguoiThue.hoTen ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${chiTietHopDong.nguoiThue.sdt} · Thuê từ ${_formatDate(chiTietHopDong.hopDong.ngayKy!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 0.5, indent: 60, endIndent: 16),
      ],
    );
  }

  Color _avatarColor(String initials) {
    const colors = [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
    ];
    return colors[initials.codeUnitAt(0) % colors.length];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _ComingSoonWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ComingSoonWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Colors.black12),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tính năng đang được phát triển',
          style: TextStyle(fontSize: 13, color: Colors.black26),
        ),
      ],
    );
  }
}

class _MoreOptionsSheet extends StatelessWidget {
  const _MoreOptionsSheet();

  @override
  Widget build(BuildContext context) {
    final options = [
      (Icons.edit_outlined, 'Chỉnh sửa phòng'),
      (Icons.person_add_alt_outlined, 'Thêm người thuê'),
      (Icons.build_outlined, 'Báo cáo sửa chữa'),
      (Icons.delete_outline, 'Xóa phòng'),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => ListTile(
              leading: Icon(opt.$1, color: Colors.black54),
              title: Text(opt.$2),
              onTap: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

// ===================== HELPERS =====================

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
