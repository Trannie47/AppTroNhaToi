import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/HopDongForm/hopDongForm.dart';
import 'package:AppTroNhaToi/widgets/itemNTHopDong.dart';
import 'package:flutter/material.dart';

class HopDongPage extends StatefulWidget {
  HopDongPage({super.key});

  @override
  State<HopDongPage> createState() => _HopDongPageState();
}

class _HopDongPageState extends State<HopDongPage> {
  String boLoc = "TAT_CA";
  String tuKhoa = "";

  String taoMaHopDong(DateTime ngayKy, int stt) {
    String ngay = ngayKy.day.toString().padLeft(2, '0');

    String thang = ngayKy.month.toString().padLeft(2, '0');

    String nam = ngayKy.year.toString();

    String soThuTu = stt.toString().padLeft(2, '0');

    return "$ngay$thang$nam$soThuTu";
  }

  //final List<HopDong> danhSachHopDong = [];

  final List<HopDong> danhSachHopDong = [
    HopDong(
      hopDongID: "1",
      phongID: 101,
      giaPhongThucTe: 3000000,
      trangThai: 1,
      ngayHetHan: DateTime(2026, 12, 31),
    ),

    // HopDong(
    //   hopDongID: 2,
    //   phongID: 102,
    //   giaPhongThucTe: 3500000,
    //   trangThai: "SAP_HET_HAN",
    //   ngayHetHan: DateTime.now().add(const Duration(days: 15)),
    // ),
    //
    // HopDong(
    //   hopDongID: 3,
    //   phongID: 103,
    //   giaPhongThucTe: 2800000,
    //   trangThai: "DA_KET_THUC",
    //   ngayHetHan: DateTime.now().subtract(const Duration(days: 10)),
    // ),
  ];

  void moTrangTaoHopDong() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HopDongForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<HopDong> danhSachHienThi;

    switch (boLoc) {
      case "HIEU_LUC":
        danhSachHienThi = danhSachHopDong
            .where((e) => e.trangThai == "HIEU_LUC")
            .toList();
        break;

      // case "SAP_HET_HAN":
      //   danhSachHienThi = danhSachHopDong.where((hd) {
      //     if (hd.ngayHetHan == null) return false;

      //     final soNgayConLai =
      //         hd.ngayHetHan!.difference(DateTime.now()).inDays;

      //     return soNgayConLai <= 30 &&
      //         soNgayConLai >= 0;
      //   }).toList();
      //   break;

      case "SAP_HET_HAN":
        danhSachHienThi = danhSachHopDong
            .where((e) => e.trangThai == "SAP_HET_HAN")
            .toList();
        break;

      case "DA_KET_THUC":
        danhSachHienThi = danhSachHopDong
            .where((e) => e.trangThai == "DA_KET_THUC")
            .toList();
        break;

      default:
        danhSachHienThi = danhSachHopDong;
    }

    if (tuKhoa.isNotEmpty) {
      danhSachHienThi = danhSachHienThi.where((hd) {
        return hd.phongID.toString().contains(tuKhoa);
      }).toList();
    }

    int tongHopDong = danhSachHopDong.length;

    int hopDongHieuLuc = danhSachHopDong
        .where((e) => e.trangThai == "HIEU_LUC")
        .length;

    int hopDongKetThuc = danhSachHopDong
        .where((e) => e.trangThai == "DA_KET_THUC")
        .length;

    // int hopDongSapHetHan = danhSachHopDong.where((hd) {
    //   final ngayHetHan = hd.ngayHetHan;

    //   if (ngayHetHan == null) return false;

    //   final soNgayConLai =
    //       ngayHetHan.difference(DateTime.now()).inDays;

    //   return soNgayConLai <= 30 && soNgayConLai >= 0;
    // }).length;

    int hopDongSapHetHan = danhSachHopDong
        .where((e) => e.trangThai == "SAP_HET_HAN")
        .length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Hợp đồng',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1A1A1A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: moTrangTaoHopDong,
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xff2E7D32),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, size: 18, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Tạo mới",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      tuKhoa = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Tìm tên người thuê, phòng...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // FILTER
            Container(
              color: const Color(0xFFF4F4F4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          boLoc = "TAT_CA";
                        });
                      },
                      child: _buildFilter(
                        title: "Tất cả ($tongHopDong)",
                        color: Colors.grey.shade700,
                        bgColor: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          boLoc = "HIEU_LUC";
                        });
                      },
                      child: _buildFilter(
                        title: "Hiệu lực ($hopDongHieuLuc)",
                        color: Colors.green,
                        bgColor: const Color(0xffE8F5E9),
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          boLoc = "SAP_HET_HAN";
                        });
                      },
                      child: _buildFilter(
                        title: "Sắp hết hạn ($hopDongSapHetHan)",
                        color: const Color(0xffD97706),
                        bgColor: const Color(0xffFEF3C7),
                      ),
                    ),

                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          boLoc = "DA_KET_THUC";
                        });
                      },
                      child: _buildFilter(
                        title: "Đã kết thúc ($hopDongKetThuc)",
                        color: Colors.red,
                        bgColor: const Color(0xffFFEBEE),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Container(
                color: const Color(0xFFF4F4F4),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: danhSachHienThi.length,
                  itemBuilder: (context, index) {
                    return ItemNTHopDong(
                      hopDong: danhSachHienThi[index],
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter({
    required String title,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
