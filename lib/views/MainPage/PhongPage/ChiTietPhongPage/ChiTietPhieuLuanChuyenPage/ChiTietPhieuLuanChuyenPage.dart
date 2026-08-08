import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/ChiTietPhieuLuanChuyenPage/ChiTietPhieuLuanChuyenPageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChiTietPhieuLuanChuyenPage extends StatefulWidget {
  final PhieuLuanChuyen item;

  const ChiTietPhieuLuanChuyenPage({super.key, required this.item});

  @override
  State<ChiTietPhieuLuanChuyenPage> createState() =>
      _ChiTietPhieuLuanChuyenPageState();
}

class _ChiTietPhieuLuanChuyenPageState
    extends State<ChiTietPhieuLuanChuyenPage> {
  late ChiTietPhieuLuanChuyenViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ChiTietPhieuLuanChuyenViewModel(
      hopDongProvider: context.read<HopDongProvider>(),
      item: widget.item,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,

        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, color: Colors.black),
            ),
          ),
        ),

        titleSpacing: 12,
        title: const Text(
          "Chi tiết luân chuyển",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== Card: Hành trình chuyển phòng =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff2D7A3A), Color(0xff45A04F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  item.hopDongId ?? "Chưa có hợp đồng",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Phòng cũ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.hopDong?.phong?.tenPhong ?? "--",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Phòng mới",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.phongMoi?.tenPhong ?? "--",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.denNgay != null
                            ? "${formatDate(item.tuNgay)}  →  ${formatDate(item.denNgay)}"
                            : formatDate(item.tuNgay),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== Card: Thông tin luân chuyển =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin luân chuyển",
                  style: TextStyle(
                    color: Color(0xff2D7A3A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 14),

                _dongThongTin(
                  icon: Icons.payments_outlined,
                  label: "Chi phí",
                  value: formatMoney(item.chiPhi ?? 0),
                  valueColor: const Color(0xff2D7A3A),
                  valueBold: true,
                ),

                if ((item.lyDoLuanChuyen ?? "").isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _dongThongTin(
                    icon: Icons.info_outline,
                    label: "Lý do",
                    value: item.lyDoLuanChuyen!,
                  ),
                ],

                if ((item.ghiChu ?? "").isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _dongThongTin(
                    icon: Icons.note_outlined,
                    label: "Ghi chú",
                    value: item.ghiChu!,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== Card: Người thuê trong hợp đồng =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Người thuê trong hợp đồng",
                      style: TextStyle(
                        color: Color(0xff2D7A3A),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (!vm.isLoading)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8F3EA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${vm.tongSoNguoi} người",
                          style: const TextStyle(
                            color: Color(0xff2D7A3A),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                if (vm.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.tenDaiDien == null && vm.dsNguoiOGhep.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Không có thông tin người thuê",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                else ...[
                  if (vm.tenDaiDien != null)
                    _dongNguoiThue(
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xff2D7A3A),
                      iconBg: const Color(0xffE8F3EA),
                      ten: vm.tenDaiDien!,
                      vaiTro: "Người thuê đại diện",
                    ),

                  ...vm.dsNguoiOGhep.map(
                    (nt) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _dongNguoiThue(
                        icon: Icons.person_outline,
                        iconColor: const Color(0xff1976D2),
                        iconBg: const Color(0xffE8F3FF),
                        ten: nt.hoTen ?? "Chưa rõ",
                        vaiTro: (nt.quanHeVoiDaiDien ?? "").isNotEmpty
                            ? nt.quanHeVoiDaiDien!
                            : "Ở ghép",
                        phu: nt.sdt,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _dongThongTin({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? Colors.black87,
                  fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dongNguoiThue({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String ten,
    required String vaiTro,
    String? phu,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ten,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  vaiTro,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          if (phu != null && phu.isNotEmpty)
            Text(
              phu,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
