import 'package:AppTroNhaToi/Provider/hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/CauHinhGiaPage/cauHinhGiaPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LoaiPhongPage/loaiPhongPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/TapHoaPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThongKePage/thongKePage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/hopDongPage/hopDongPage.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/SuCoPage/SuCoPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Provider/cau_hinh_gia_provider.dart';
import '../../../modelviews/MainPage/KhacPage/KhacPage.dart';

class KhacPage extends StatefulWidget {
  const KhacPage({super.key});

  @override
  State<KhacPage> createState() => _KhacPageState();
}

class _KhacPageState extends State<KhacPage> {
  late KhacPageModelView vm;

  @override
  void initState() {
    super.initState();
    final hopDongProvider = Provider.of<HopDongProvider>(
      context,
      listen: false,
    );
    final cauHinhGiaProvider = Provider.of<CauHinhGiaProvider>(
      context,
      listen: false,
    );
    vm = KhacPageModelView(hopDongProvider, cauHinhGiaProvider);
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thietBiProvider = context.watch<ThietBiProvider>();
    final hoaDonTapHoaProvider = context.watch<HoaDonTapHoaProvider>();
    final thongKeProvider = context.watch<ThongKeProvider>();
    final cauHinhGiaProvider = context.watch<CauHinhGiaProvider>();

    final soLuongSapHetHan = vm.soLuongSapHetHan;

    final cauHinhGia = cauHinhGiaProvider.cauHinhGia;


    int soMucDaCauHinh = 0;
    if (cauHinhGia != null) {
      if (cauHinhGia.giaDien > 0) soMucDaCauHinh++;
      if (cauHinhGia.giaNuoc > 0) soMucDaCauHinh++;
      if (cauHinhGia.giaXeMay > 0) soMucDaCauHinh++;
      if (cauHinhGia.giaXeHoi > 0) soMucDaCauHinh++;
      if (cauHinhGia.giaXeDap > 0) soMucDaCauHinh++;
    }

    final statusCauHinhGia = soMucDaCauHinh == 0
        ? "Chưa cấu hình đơn giá"
        : soMucDaCauHinh == 5
        ? "Đã cấu hình đầy đủ"
        : "Đã cấu hình $soMucDaCauHinh/5 mục";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: const Text(
                  "Khác",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: const EdgeInsets.only(top: 12, bottom: 16),
                children: [
                  const SizedBox(height: 0),

                  _buildItem(
                    icon: Icons.description_outlined,
                    iconColor: Colors.indigo,
                    iconBg: const Color(0xFFEDEBFF),
                    title: "Hợp đồng",
                    subtitle:
                        "Quản lý hợp đồng thuê phòng,\ntheo dõi ngày hết hạn",
                    status: soLuongSapHetHan > 0
                        ? "$soLuongSapHetHan sắp hết hạn"
                        : "Không có hợp đồng sắp hết hạn",
                    statusColor: soLuongSapHetHan > 0
                        ? const Color(0xFFFFA726)
                        : Colors.grey.shade600,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HopDongPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  _buildItem(
                    icon: Icons.category_outlined,
                    iconColor: Colors.teal,
                    iconBg: const Color(0xFFE0F2F1),
                    title: "Loại phòng",
                    subtitle:
                        "Quản lý danh sách loại phòng,\ndiện tích, giá thuê gốc và tiện ích",
                    status: "Cấu hình danh mục",
                    statusColor: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoaiPhongPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    icon: Icons.tune_outlined,
                    iconColor: Colors.blue.shade700,
                    iconBg: const Color(0xFFE3F2FD),
                    title: "Cấu hình giá",
                    subtitle:
                        "Thiết lập đơn giá điện, nước,\ngiá gửi xe mặc định cho hệ thống",
                    status: statusCauHinhGia,
                    statusColor: Colors.blue.shade700,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CauHinhGiaPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    icon: Icons.desktop_windows_outlined,
                    iconColor: Colors.green,
                    iconBg: const Color(0xFFE7F5EA),
                    title: "Thiết bị",
                    subtitle: "Quản lý thiết bị, theo dõi sửa\nchữa, nhập kho",
                    status: "${thietBiProvider.soLuongDangSua} đang sửa",
                    statusColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThietBiPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    icon: Icons.inventory_2_outlined,
                    iconColor: Colors.orange,
                    iconBg: const Color(0xFFFFF1D6),
                    title: "Tạp hóa",
                    subtitle:
                        "Quản lý hàng hóa, lập hóa đơn,\ntheo dõi công nợ",
                    status:
                        "${NumberFormat('#,##0').format(hoaDonTapHoaProvider.tongCongNo)}đ công nợ",
                    statusColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TapHoaPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildItem(
                    icon: Icons.bar_chart,
                    iconColor: Colors.deepPurple,
                    iconBg: const Color(0xFFF0E5FF),
                    title: "Thống kê",
                    subtitle:
                        "Báo cáo doanh thu, chi phí,\nlợi nhuận theo tháng",
                    status:
                        "Tháng ${thongKeProvider.thangHienTai}: "
                        "${NumberFormat('#,##0').format(thongKeProvider.tongDoanhThuThang)}đ",
                    statusColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThongKePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildItem(
                    icon: Icons.report_problem_outlined,
                    iconColor: Colors.red,
                    iconBg: const Color(0xFFFFEBEE),
                    title: "Sự cố",
                    subtitle:
                    "Quản lý sự cố,\ntheo dõi sửa chữa và luân chuyển phòng",
                    status: "Quản lý sự cố",
                    statusColor: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SuCoPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
