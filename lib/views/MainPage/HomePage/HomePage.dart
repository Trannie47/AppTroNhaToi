import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_bao_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/HomePage/homePageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/hopDongPage/hopDongPage.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/widgets/itemCongNo.dart';
import 'package:AppTroNhaToi/widgets/itemThongBao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../PhongPage/FormPhong/FormPhong.dart';
import 'GhiDienNuocHomePage/GhiDienNuocHomePage.dart';
import 'HoaDonHomePage/HoaDonHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = HomePageViewModel(
      context.read<PhongProvider>(),
      context.read<ThongKeProvider>(),
      context.read<NguoiThueProvider>(),
      context.read<ThongBaoProvider>(),
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  //Nút chuyển sang trang Form Room
  void navigateToFormRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPhong()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),

              const SizedBox(height: 16),

              if (vm.isLoading)
                _loadingHome()
              /// DỮ LIỆU THẬT
              else ...[
                _quickActions(),

                const SizedBox(height: 16),

                _stats(),

                const SizedBox(height: 16),

                if (vm.roomCount > 0) ...[
                  _revenue(vm.doanhThuThang, vm.congNoThang),

                  const SizedBox(height: 16),

                  _status(),
                ] else ...[
                  _emptyHome(),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// LOADING UI
  Widget _loadingHome() {
    return Column(
      children: [
        /// QUICK ACTION
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        /// STATS
        Row(
          children: List.generate(3, (index) {
            return Expanded(
              child: Container(
                height: 110,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        /// REVENUE
        Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// STATUS
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  // HEADER
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDateVN(DateTime.now()),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tổng quan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  // QUICK ACTION
  Widget _quickActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(Icons.flash_on, "Ghi điện",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GhiDienNuocHomePage(),
                ),
              );
            },),
          _item(Icons.receipt, "Hóa đơn",
              (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> const HoaDonHomePage()
                  ),
                );
              }),

          _item(Icons.person_add, "Người thuê",
              (){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=> const NguoiThueForm()
                    ),
                  );
              }),
          _item(Icons.description, "Hợp đồng",
              (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> HopDongPage()),
                );
              }),
        ],
      ),

    );
  }

  Widget _item(IconData icon, String title, VoidCallback? onTap) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F2), // nền xám nhạt
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ICON BOX
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF3E4), // xanh nhạt
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF2D7A3A)),
                ),

                const SizedBox(height: 8),

                // TEXT
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // STATS
  Widget _stats() {
    return Row(
      children: [
        _box(
          vm.roomCount,
          "Tổng phòng",
          badge: (vm.roomCount > 0)
              ? "${(vm.occupiedRoomCount / vm.roomCount * 100).toInt()}% lấp đầy"
              : null,
        ),
        _box(
          vm.emptyRoomCount,
          "Phòng trống",
          color: Colors.green,
          badge: "Sẵn thuê",
        ),
        _box(vm.occupiedRoomCount, "Đang thuê", badge: "người thuê"),
      ],
    );
  }

  Widget _box(
    double value,
    String label, {
    Color color = Colors.black,
    String? badge,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VALUE
            Text(
              value.toInt().toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            // LABEL
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 8),

            // BADGE
            Visibility(
              visible: badge != null,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge ?? "",
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF2D7A3A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REVENUE
  Widget _revenue(double revenue, double debt) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2D7A3A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatMoneyShort(revenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Doanh thu tháng",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatMoneyShort(debt),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: debt > 0 ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Công nợ", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STATUS
  Widget _status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ===== TÌNH TRẠNG =====
        const Text(
          "Tình trạng hôm nay",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        vm.issues.isEmpty ? _statusOk() : _needHandle(),

        const SizedBox(height: 16),

        /// ===== CÔNG NỢ =====
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Công nợ tạp hóa",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (vm.debts.isNotEmpty)
              const Text(
                "Xem tất cả",
                style: TextStyle(color: Color(0xFF2D7A3A)),
              ),
          ],
        ),

        const SizedBox(height: 10),

        vm.debts.isEmpty ? _debtEmpty() : _debtList(),
      ],
    );
  }

  Widget _statusOk() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFDDF3E4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF2D7A3A)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mọi thứ đều ổn",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D7A3A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Không có hóa đơn trễ, không có hợp đồng sắp hết hạn, điện nước đã ghi đầy đủ.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _needHandle() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: vm.issues.map((e) {
          return ItemThongBao(thongBao: e);
        }).toList(),
      ),
    );
  }

  Widget _debtEmpty() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Không có công nợ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Tất cả người thuê đã thanh toán đầy đủ trong tháng này.",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _debtList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: vm.debts.map((e) {
          return ItemCongNo(congNo: e);
        }).toList(),
      ),
    );
  }

  Widget _emptyHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ===== CARD XANH =====
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D7A3A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TAG
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "★ Chào mừng bạn",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Bắt đầu quản lý nhà trọ của bạn",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Thêm phòng trọ đầu tiên để bắt đầu theo dõi doanh thu, hóa đơn và người thuê.",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),

              const SizedBox(height: 16),

              // BUTTON
              InkWell(
                onTap: () {
                  navigateToFormRoom();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Thêm phòng trọ đầu tiên",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// ===== HƯỚNG DẪN =====
        const Text(
          "Hướng dẫn bắt đầu",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 10),

        _stepItem(
          1,
          "Thêm phòng trọ",
          "Nhập thông tin phòng, diện tích, giá thuê và trạng thái",
          null,
        ),
        _stepItem(
          2,
          "Thêm người thuê",
          "Nhập thông tin người thuê và phân vào phòng",
          null,
        ),
        _stepItem(
          3,
          "Tạo hợp đồng",
          "Lập hợp đồng thuê phòng và ghi nhận tiền cọc",
          null,
        ),
        _stepItem(
          4,
          "Ghi điện nước & tạo hóa đơn",
          "Ghi chỉ số hàng tháng và xuất hóa đơn cho người thuê",
          null,
        ),
      ],
    );
  }

  Widget _stepItem(int index, String title, String desc, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // NUMBER
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFDDF3E4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$index",
                style: const TextStyle(
                  color: Color(0xFF2D7A3A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
