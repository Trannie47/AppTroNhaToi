import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/ThongKePage/ThongKeViewModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ThongKePage extends StatefulWidget {

  const ThongKePage({super.key});
  @override

  State<ThongKePage> createState() => _ThongKePageState();
}

class _ThongKePageState extends State<ThongKePage> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ThongKeViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(vm),

            _buildFilter(vm),

            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: 10,

                itemScrollController: vm.itemScrollController,

                itemPositionsListener: vm.itemPositionsListener,

                padding: const EdgeInsets.only(bottom: 24),

                itemBuilder: (context, index) {

                  switch (index) {

                    case 0:
                      return _buildKpiSection();

                    case 1:
                      return _buildRevenueChart();

                    case 2:
                      return _buildPieChart();

                    case 3:
                      return _buildRoomSection();

                    case 4:
                      return _buildTenantSection();

                    case 5:
                      return _buildDeviceSection();

                    case 6:
                      return _buildExpenseSection();

                    case 7:
                      return _buildTopRevenue();

                    case 8:
                      return _buildTopDebt();

                    case 9:
                      return _buildRecentActivity();

                    default:
                      return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // HEADER

  Widget _buildHeader(ThongKeViewModel vm) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECF2))),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),

          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("📊", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 10),
                  Text(
                    "Báo cáo thống kê",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // menu chạy từng phần
          PopupMenuButton<String>(
            icon: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.black87,
              ),
            ),

            offset: const Offset(0, 10),

            position: PopupMenuPosition.under,

            elevation: 10,

            color: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),

            onSelected: (value) {
              switch (value) {
                case "revenue":
                  vm.scrollTo(1);
                  break;

                case "pie":
                  vm.scrollTo(2);
                  break;

                case "room":
                  vm.scrollTo(3);
                  break;

                case "tenant":
                  vm.scrollTo(4);
                  break;

                case "device":
                  vm.scrollTo(5);
                  break;

                case "expense":
                  vm.scrollTo(6);
                  break;

                case "topRevenue":
                  vm.scrollTo(7);
                  break;

                case "topDebt":
                  vm.scrollTo(8);
                  break;

                case "activity":
                  vm.scrollTo(9);
                  break;
              }
            },

            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "revenue",
                child: Row(
                  children: [
                    Icon(Icons.show_chart, color: Color(0xFF7C4DFF)),
                    SizedBox(width: 12),
                    Text("Doanh thu"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "pie",
                child: Row(
                  children: [
                    Icon(Icons.pie_chart, color: Colors.orange),
                    SizedBox(width: 12),
                    Text("Cơ cấu doanh thu"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "room",
                child: Row(
                  children: [
                    Icon(Icons.home_work, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text("Tình trạng phòng"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "tenant",
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.blue),
                    SizedBox(width: 12),
                    Text("Người thuê"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "device",
                child: Row(
                  children: [
                    Icon(Icons.handyman, color: Colors.brown),
                    SizedBox(width: 12),
                    Text("Thiết bị"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "expense",
                child: Row(
                  children: [
                    Icon(Icons.payments, color: Colors.green),
                    SizedBox(width: 12),
                    Text("Chi phí"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "topRevenue",
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber),
                    SizedBox(width: 12),
                    Text("Top doanh thu"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "topDebt",
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 12),
                    Text("Top công nợ"),
                  ],
                ),
              ),

              const PopupMenuItem(
                value: "activity",
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.deepPurple),
                    SizedBox(width: 12),
                    Text("Hoạt động"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // FILTER

  Widget _buildFilter(ThongKeViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount:vm.filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  final selected = vm.selectedFilter == index;

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                        vm.changeFilter(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF7C4DFF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF7C4DFF)
                              : const Color(0xFFE3E6ED),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            if (index == 4) ...[
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              vm.filters[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (index == 4) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KPI

  Widget _buildKpiSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        children: [
          _buildKpiCard(
            title: "Tổng doanh thu",
            value: "150.000.000đ",
            subTitle: "↑ +12% so với kỳ trước",
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF7C4DFF),
            iconBg: const Color(0xFFEDE4FF),
            borderColor: const Color(0xFFD7C8FF),
            subColor: Colors.green,
          ),

          const SizedBox(height: 8),

          _buildKpiCard(
            title: "Đã thu",
            value: "120.000.000đ",
            subTitle: "80% tổng doanh thu",
            icon: Icons.account_balance_wallet,
            iconColor: Colors.green,
            iconBg: const Color(0xFFDDF7E6),
            borderColor: const Color(0xFFBFECCF),
            subColor: Colors.green,
          ),

          const SizedBox(height: 8),

          _buildKpiCard(
            title: "Chưa thu",
            value: "30.000.000đ",
            subTitle: "20% tổng doanh thu",
            icon: Icons.receipt_long_rounded,
            iconColor: Colors.orange,
            iconBg: const Color(0xFFFFF1D8),
            borderColor: const Color(0xFFFFD8A5),
            subColor: Colors.orange,
          ),

          const SizedBox(height: 8),

          _buildKpiCard(
            title: "Tổng chi phí",
            value: "25.000.000đ",
            subTitle: "↓ -5% so với kỳ trước",
            icon: Icons.pie_chart_rounded,
            iconColor: Colors.red,
            iconBg: const Color(0xFFFFE5E8),
            borderColor: const Color(0xFFFFC9D0),
            subColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subTitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Color borderColor,
    required Color subColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // REVENUE CHART

  Widget _buildRevenueChart() {
    return Container(

      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart_rounded, color: Color(0xFF7C4DFF)),
                  SizedBox(width: 10),
                  Text(
                    "Doanh thu theo thời gian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: _RevenueChartPainter(),
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PIE CHART

  Widget _buildPieChart() {
    final List<Map<String, dynamic>> data = [
      {"title": "Tiền phòng", "value": "60%", "color": const Color(0xFF7C4DFF)},
      {"title": "Tiền điện", "value": "18%", "color": Colors.blue},
      {"title": "Tiền nước", "value": "10%", "color": Colors.green},
      {"title": "Tạp hóa", "value": "8%", "color": Colors.orange},
      {"title": "Khác", "value": "4%", "color": Colors.red},
    ];

    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pie_chart_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Cơ cấu doanh thu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 35,
                      sectionsSpace: 2,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                          value: 60,
                          color: const Color(0xFF7C4DFF),
                          title: "60%",
                          radius: 28,
                        ),
                        PieChartSectionData(
                          value: 18,
                          color: Colors.green,
                          title: "18%",
                          radius: 28,
                        ),
                        PieChartSectionData(
                          value: 10,
                          color: Colors.orange,
                          title: "10%",
                          radius: 28,
                        ),
                        PieChartSectionData(
                          value: 8,
                          color: Colors.blue,
                          title: "8%",
                          radius: 28,
                        ),
                        PieChartSectionData(
                          value: 4,
                          color: Colors.red,
                          title: "4%",
                          radius: 28,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    children: data.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: item["color"] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item["title"] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Text(
                              item["value"] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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

  // ROOM

  Widget _buildRoomSection() {
    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.meeting_room_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Tình trạng phòng",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Tổng phòng",
                    value: "40",
                    color: const Color(0xFF7C4DFF),
                    icon: Icons.home_work_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "Đang thuê",
                    value: "34",
                    color: Colors.green,
                    icon: Icons.check_circle_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Phòng trống",
                    value: "6",
                    color: Colors.orange,
                    icon: Icons.meeting_room_outlined,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "Lấp đầy",
                    value: "85%",
                    color: Colors.blue,
                    icon: Icons.bar_chart_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Tỷ lệ lấp đầy",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: .85,
                minHeight: 10,
                backgroundColor: Color(0xFFE9ECF2),
                valueColor: AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }

  // TENANT

  Widget _buildTenantSection() {
    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.people_alt_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Người thuê",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Tổng người thuê",
                    value: "56",
                    color: const Color(0xFF7C4DFF),
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "Đang ở",
                    value: "54",
                    color: Colors.green,
                    icon: Icons.person,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Đã trả phòng",
                    value: "2",
                    color: Colors.orange,
                    icon: Icons.logout_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "HĐ sắp hết",
                    value: "4",
                    color: Colors.red,
                    icon: Icons.event_busy_rounded,
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

  // DEVICE

  Widget _buildDeviceSection() {
    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.handyman_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Thiết bị",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Tổng thiết bị",
                    value: "180",
                    color: const Color(0xFF7C4DFF),
                    icon: Icons.inventory_2_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "Hoạt động",
                    value: "171",
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    title: "Đang sửa",
                    value: "6",
                    color: Colors.orange,
                    icon: Icons.build_circle_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildStatisticCard(
                    title: "Đã hỏng",
                    value: "3",
                    color: Colors.red,
                    icon: Icons.error_rounded,
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

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // EXPENSE

  Widget _buildExpenseSection() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.payments_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Chi phí",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildExpenseItem(
              title: "Sửa chữa",
              value: "12.000.000đ",
              percent: .48,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            _buildExpenseItem(
              title: "Mua thiết bị",
              value: "8.000.000đ",
              percent: .32,
              color: Colors.orange,
            ),

            const SizedBox(height: 16),

            _buildExpenseItem(
              title: "Chi phí khác",
              value: "5.000.000đ",
              percent: .20,
              color: Colors.blue,
            ),

            const Divider(height: 36),

            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Tổng chi phí",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  "25.000.000đ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 8),
                Text(
                  "Biểu đồ chi phí",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildExpenseBar("Sửa", .95, Colors.red),
                  _buildExpenseBar("TB", .70, Colors.orange),
                  _buildExpenseBar("Khác", .45, Colors.blue),
                  _buildExpenseBar("Tổng", 1, const Color(0xFF7C4DFF)),
                ],
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }

  Widget _buildExpenseItem({
    required String title,
    required String value,
    required double percent,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: const Color(0xFFE8EBF2),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseBar(String title, double value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 42,
          height: value * 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  // TOP REVENUE

  Widget _buildTopRevenue() {
    final items = [
      {
        "room": "P101",
        "money": "15.000.000đ",
        "icon": "🥇",
        "color": Colors.amber,
      },
      {
        "room": "P203",
        "money": "13.500.000đ",
        "icon": "🥈",
        "color": Colors.grey,
      },
      {
        "room": "P305",
        "money": "12.800.000đ",
        "icon": "🥉",
        "color": const Color(0xFFCD7F32),
      },
      {
        "room": "P102",
        "money": "12.000.000đ",
        "icon": "4",
        "color": Colors.blue,
      },
      {
        "room": "P401",
        "money": "11.500.000đ",
        "icon": "5",
        "color": Colors.green,
      },
    ];

    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Top 5 phòng doanh thu cao",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...items.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: (item["color"] as Color).withOpacity(
                        .12,
                      ),
                      child: Text(
                        item["icon"].toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["room"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Doanh thu tháng",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Text(
                        item["money"].toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }

  // TOP DEBT

  Widget _buildTopDebt() {
    final items = [
      {"room": "P104", "money": "6.500.000đ"},
      {"room": "P210", "money": "5.000.000đ"},
      {"room": "P305", "money": "4.000.000đ"},
      {"room": "P110", "money": "3.500.000đ"},
      {"room": "P402", "money": "2.800.000đ"},
    ];

    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  "Top 5 phòng còn nợ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...List.generate(items.length, (index) {
              final item = items[index];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(.08),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                title: Text(item["room"].toString()),
                subtitle: const Text("Chưa thanh toán"),
                trailing: Text(
                  item["money"].toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
        ),
    );
  }

  // RECENT ACTIVITY

  Widget _buildRecentActivity() {
    final activities = [
      {
        "icon": Icons.payments_rounded,
        "title": "Thu tiền phòng P101",
        "time": "10 phút trước",
        "color": Colors.green,
      },
      {
        "icon": Icons.build_rounded,
        "title": "Thanh toán sửa chữa máy lạnh",
        "time": "40 phút trước",
        "color": Colors.orange,
      },
      {
        "icon": Icons.inventory_rounded,
        "title": "Nhập thiết bị mới",
        "time": "1 giờ trước",
        "color": Colors.blue,
      },
      {
        "icon": Icons.logout_rounded,
        "title": "Người thuê trả phòng",
        "time": "Hôm nay",
        "color": Colors.red,
      },
      {
        "icon": Icons.description_rounded,
        "title": "Lập hợp đồng mới",
        "time": "Hôm nay",
        "color": const Color(0xFF7C4DFF),
      },
    ];

    return Container(

        child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history_rounded, color: Color(0xFF7C4DFF)),
                SizedBox(width: 10),
                Text(
                  "Hoạt động gần đây",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ...activities.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: (item["color"] as Color).withOpacity(.12),
                  child: Icon(
                    item["icon"] as IconData,
                    color: item["color"] as Color,
                  ),
                ),
                title: Text(
                  item["title"].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                subtitle: Text(item["time"].toString()),
              ),
            ),
          ],
        ),
      ),
        ),
    );
  }

}

// REVENUE CHART PAINTER

class _RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE9ECF2)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF7C4DFF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = const Color(0xFF7C4DFF)
      ..style = PaintingStyle.fill;

    final path = Path();

    final points = [
      Offset(0, size.height * .82),
      Offset(size.width * .15, size.height * .70),
      Offset(size.width * .30, size.height * .62),
      Offset(size.width * .45, size.height * .48),
      Offset(size.width * .60, size.height * .56),
      Offset(size.width * .75, size.height * .30),
      Offset(size.width, size.height * .18),
    ];

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];

      path.quadraticBezierTo(
        previous.dx,
        previous.dy,
        (previous.dx + current.dx) / 2,
        (previous.dy + current.dy) / 2,
      );
    }

    path.lineTo(points.last.dx, points.last.dy);

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);

      canvas.drawCircle(
        point,
        9,
        Paint()
          ..color = const Color(0xFF7C4DFF).withOpacity(.15)
          ..style = PaintingStyle.fill,
      );
    }

    const labels = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

    final textStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < labels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );

      tp.layout();

      tp.paint(canvas, Offset(points[i].dx - tp.width / 2, size.height + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
