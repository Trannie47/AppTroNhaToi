import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietThietBi/chiTietThietBiViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiForm/thietBiForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChiTietThietBi extends StatefulWidget {
  final ThietBi thietBi;

  final List<Phong> dsPhong;

  final List<LapRap> dsLapRap;
  final List<ThietBi> dsThietBi;

  const ChiTietThietBi({
    super.key,
    required this.thietBi,
    required this.dsPhong,
    required this.dsLapRap,
    required this.dsThietBi,
  });

  @override
  State<ChiTietThietBi> createState() => _ChiTietThietBiState();
}

class _ChiTietThietBiState extends State<ChiTietThietBi> {
  late ChiTietThietBiViewModel vm;
  bool hienMenu = false;

  @override
  void initState() {
    super.initState();

    vm = ChiTietThietBiViewModel();

    vm.init(widget.thietBi, widget.dsPhong, widget.dsLapRap, widget.dsThietBi);
  }

  @override
  Widget build(BuildContext context) {
    bool dangSua = vm.thietBi.trangThaiText.toLowerCase() == "đang sửa";

    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),

            child: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),

        title: const Text(
          "Chi tiết thiết bị",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),

            child: Container(
              width: 38,
              height: 38,

              decoration: const BoxDecoration(
                color: Color(0xffEEF5EE),
                shape: BoxShape.circle,
              ),

              child: IconButton(
                padding: EdgeInsets.zero,

                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xff6E8E72),
                  size: 18,
                ),

                onPressed: () {
                  setState(() {
                    hienMenu = !hienMenu;
                  });
                },
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                if (dangSua)
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1F1),

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(color: const Color(0xffFFD4D4)),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: const Color(0xffFFE5E5),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(Icons.build, color: Colors.red),
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Đang sửa chữa",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "Từ ngày ${formatDate(DateTime.now())}",

                              style: const TextStyle(
                                color: Color(0xff8D8D8D),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

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
                        "Thông tin thiết bị",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2D7A3A),
                        ),
                      ),

                      const SizedBox(height: 22),

                      _rowThongTin("Tên thiết bị", vm.thietBi.tenThietBi ?? ""),

                      _rowThongTin("Loại", vm.thietBi.loai ?? ""),

                      _rowThongTin("Phòng lắp đặt", vm.tenPhong),

                      _rowThongTin(
                        "Ngày mua",
                        DateFormat("MM/yyyy").format(vm.thietBi.ngayMua!),
                      ),

                      _rowThongTin(
                        "Giá trị",
                        "${NumberFormat("#,###").format(vm.thietBi.giaTri)}đ",
                      ),

                      _rowThongTin(
                        "Trạng thái",
                        vm.trangThai,
                        mau: dangSua ? Colors.red : const Color(0xff2D7A3A),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

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
                            "Lịch sử sửa chữa",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2D7A3A),
                            ),
                          ),

                          const Spacer(),

                          TextButton(
                            onPressed: () {},

                            child: const Text(
                              "Xem thêm",
                              style: TextStyle(
                                color: Color(0xff2D7A3A),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: const Color(0xffFAFAFA),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Không lạnh, không khởi động",

                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "${formatDate(DateTime.now())} - Đang sửa",

                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: const Color(0xffFAFAFA),

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Vệ sinh dàn lạnh",

                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              "15/08/2024 · Chi phí 150,000đ",

                              style: TextStyle(
                                color: Color(0xff8E8E8E),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    onPressed: () {},

                    child: const Text(
                      "Xóa thiết bị",

                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hienMenu) Positioned(top: 12, right: 16, child: _buildMenu()),
        ],
      ),
    );
  }

  Widget _rowThongTin(String title, String value, {Color? mau}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          SizedBox(
            width: 110,

            child: Text(
              title,

              style: const TextStyle(color: Color(0xff8E8E8E), fontSize: 13),
            ),
          ),

          Expanded(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: mau,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subTitle,
    Color titleColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),

      onTap: onTap,

      child: SizedBox(
        height: 50,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),

              child: Icon(icon, size: 14, color: iconColor),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subTitle,

                    style: const TextStyle(
                      color: Color(0xffB5B5B5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Material(
      elevation: 6,

      color: const Color(0xffFAFAFA),

      borderRadius: BorderRadius.circular(18),

      child: Container(
        width: 210,

        padding: const EdgeInsets.only(
          left: 14,
          right: 14,
          top: 14,
          bottom: 10,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            _menuItem(
              icon: Icons.edit_outlined,

              iconColor: const Color(0xff2D7A3A),

              iconBg: const Color(0xffE8F5E9),

              title: "Cập nhật thông tin",

              subTitle: "Sửa tên, loại,...",
              onTap: () async {
                setState(() {
                  hienMenu = false;
                });

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThietBiForm(
                      thietBi: vm.thietBi,
                      dsLapRap: widget.dsLapRap,
                      dsPhong: widget.dsPhong,
                    ),
                  ),
                );

                if (result is ThietBi) {
                  setState(() {
                    vm.init(result, vm.dsPhong, vm.dsLapRap, vm.dsThietBi);
                  });
                }
              },
            ),

            _menuItem(
              icon: Icons.access_time,

              iconColor: Colors.orange,

              iconBg: const Color(0xffFFF3E0),

              title: "Cập nhật trạng thái",

              subTitle: "Tốt • Đang sửa chữa",

              onTap: () async {
                setState(() {
                  hienMenu = false;
                });

                await Future.delayed(const Duration(milliseconds: 150));

                if (mounted) {
                  _showCapNhatTrangThai();
                }
              },
            ),

            _menuItem(
              icon: Icons.delete_outline,

              iconColor: Colors.red,

              iconBg: const Color(0xffFFECEC),

              title: "Xóa thiết bị",

              subTitle: "Không thể hoàn tác",

              titleColor: Colors.red,

              onTap: () {
                setState(() {
                  hienMenu = false;
                });

                _showXoaDialog();
              },
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: 101,
              height: 22,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  elevation: 0,

                  backgroundColor: const Color(0xff2E7D32),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => PhieuSuaChuaForm(
                        thietBi: vm.thietBi,

                        phongID: vm.phongHienTai?.phongID,

                        tenPhong: vm.phongHienTai?.tenPhong ?? "",
                      ),
                    ),
                  );

                  if (result == true) {
                    vm.capNhatTrangThai("Đang sửa");

                    Navigator.pop(context, true);
                  }
                },

                child: const Text(
                  "Lập phiếu SC",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
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

  void _showXoaDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text("Xóa thiết bị"),

          content: Text(
            "Bạn có chắc chắn muốn xóa '${vm.thietBi.tenThietBi}' ?\n\nHành động này không thể hoàn tác.",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Hủy"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () {
                Navigator.pop(context);

                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    Navigator.of(this.context).pop(true);
                  }
                });
              },

              child: const Text("Xóa", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCapNhatTrangThai() async {
    String trangThaiTam = vm.trangThai;

    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),

              child: Container(
                padding: const EdgeInsets.all(18),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Text(
                      "Cập nhật trạng thái",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff3D4A59),
                      ),
                    ),

                    const SizedBox(height: 22),

                    InkWell(
                      onTap: () {
                        setStateDialog(() {
                          trangThaiTam = "Tốt";
                        });
                      },

                      child: Center(
                        child: SizedBox(
                          width: 150,
                          child: Container(
                            height: 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              border: Border.all(
                                color: trangThaiTam == "Tốt"
                                    ? const Color(0xff2E7D32)
                                    : const Color(0xffA8D5A2),
                                width: trangThaiTam == "Tốt" ? 3 : 1.5,
                              ),

                              color: trangThaiTam == "Tốt"
                                  ? const Color(0xffEAF7EB)
                                  : const Color(0xffF7FBF4),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Color(0xff3B7D3B),
                                  size: 30,
                                ),

                                const SizedBox(width: 15),

                                Text(
                                  "Tốt",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: trangThaiTam == "Tốt"
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: trangThaiTam == "Tốt"
                                        ? const Color(0xff2E7D32)
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    InkWell(
                      onTap: () {
                        setStateDialog(() {
                          trangThaiTam = "Đang sửa";
                        });
                      },

                      child: Center(
                        child: SizedBox(
                          width: 150,
                          child: Container(
                            height: 50,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),

                              border: Border.all(
                                color: trangThaiTam == "Đang sửa"
                                    ? const Color(0xffCC7415)
                                    : const Color(0xffE7BE85),
                                width: trangThaiTam == "Đang sửa" ? 3 : 1.5,
                              ),

                              color: trangThaiTam == "Đang sửa"
                                  ? const Color(0xffFFF1DE)
                                  : const Color(0xffFFF8EF),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.handyman_outlined,
                                  color: Color(0xffCC7415),
                                  size: 30,
                                ),

                                const SizedBox(width: 15),

                                Text(
                                  "Đang sửa",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: trangThaiTam == "Đang sửa"
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: trangThaiTam == "Đang sửa"
                                        ? const Color(0xffCC7415)
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 23),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(
                              "Hủy bỏ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              vm.capNhatTrangThai(trangThaiTam);

                              Navigator.pop(context); // đóng dialog

                              if (mounted) {
                                setState(() {});
                              } // quay lại trang thiết bị
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2E7D32),

                              minimumSize: const Size.fromHeight(40),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(
                              "Xác nhận",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
