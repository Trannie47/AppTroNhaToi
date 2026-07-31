import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/SuaChuaDTO.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietThietBiPage/chiTietThietBiPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuMuaThietBiPage/LichSuMuaThietBiPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/LichSuSuaChuaPage/LichSuSuaChuaPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiForm/thietBiForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietLichSuMuaThietBiPage/chiTietLichSuMuaThietBiPage.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietLichSuSuaChuaPage/chiTietLichSuSuaChuaPage.dart';
import 'package:AppTroNhaToi/widgets/itemLichSuMuaThietBi.dart';
import 'package:AppTroNhaToi/widgets/itemLichSuSuaChua.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChiTietThietBiPage extends StatefulWidget {
  final ThietBi thietBi;
  final int SoLuongMua;
  final int SoLuongLapDat;
  const ChiTietThietBiPage({
    super.key,
    required this.thietBi,
    required this.SoLuongMua,
    required this.SoLuongLapDat,
  });

  @override
  State<ChiTietThietBiPage> createState() => _ChiTietThietBiPageState();
}

class _ChiTietThietBiPageState extends State<ChiTietThietBiPage> {
  late ChiTietThietBiPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ChiTietThietBiPageViewModel(
      thietBi: widget.thietBi,
      thietBiProvider: context.read<ThietBiProvider>(),
      suaChuaProvider: context.read<SuaChuaProvider>(),
      lichSuMuaThietBiProvider: context.read<LichSuMuaThietBiProvider>(),
      soLuongLapDat: widget.SoLuongLapDat,
    );

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

  Future<void> _moLichSuSuaChua() async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => SuaChuaProvider())],
          child: LichSuSuaChuaPage(thietBi: widget.thietBi),
        ),
      ),
    );

    vm.reloadLichSuSuaChua();
  }

  Future<void> moChiTietLichSuSuaChua(LichSuSuaChuaPageModel item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<SuaChuaProvider>(),
          child: ChiTietLichSuSuaChuaPage(
            suaChua: item.suaChua!,
            hoaDonSuaChua: item.hoaDonSuaChua,
            thietBi: vm.thietBi,
            tenPhong: item.tenPhong,
          ),
        ),
      ),
    );

    // Nếu muốn load lại khi quay về
    await vm.reloadLichSuSuaChua();
  }

  Future<void> _moLichSuMuaThietBi() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LichSuMuaThietBiProvider()),
          ],
          child: LichSuMuaThietBiPage(thietBi: widget.thietBi),
        ),
      ),
    );

    vm.reloadLichSuMuaThietBi();
  }

  Future<void> moChiTietLichSuMuaThietBi(LichSuMuaThietBi item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LichSuMuaThietBiProvider()),
          ],
          child: ChiTietLichSuMuaThietBiPage(
            lichSuMua: item,
            thietBi: widget.thietBi,
          ),
        ),
      ),
    );

    vm.reloadLichSuMuaThietBi();
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
                    vm.hienMenu = !vm.hienMenu;
                  });
                },
              ),
            ),
          ),
        ],
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (vm.hienMenu) {
            setState(() {
              vm.hienMenu = false;
            });
          }
        },
        child: Stack(
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

                        _rowThongTin(
                          "Tên thiết bị",
                          vm.thietBi.tenThietBi ?? "",
                        ),

                        _rowThongTin("Loại", vm.thietBi.loai ?? ""),

                        _rowThongTin(
                          "Trạng thái",
                          vm.trangThai,
                          mau: dangSua ? Colors.red : const Color(0xff2D7A3A),
                        ),
                        _rowThongTin("Số lượng còn lại", "${vm.soLuongConLai}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text(
                                "Lịch sử mua thiết bị",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2D7A3A),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: _moLichSuMuaThietBi,
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
                        ),

                        const SizedBox(height: 16),

                        Column(
                          children: List.generate(vm.lichSuMuaThietBi.length, (
                            index,
                          ) {
                            final item = vm.lichSuMuaThietBi[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ItemLichSuMuaThietBi(
                                lichSu: item,

                                // Xem chi tiết
                                onClick: () => moChiTietLichSuMuaThietBi(item),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 16,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
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
                                onPressed: () {
                                  _moLichSuSuaChua();
                                },

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
                        ),

                        const SizedBox(height: 16),

                        Column(
                          spacing: 10,
                          children: List.generate(vm.lichSuSuaChua.length, (
                            index,
                          ) {
                            final LichSuSuaChuaPageModel item =
                                vm.lichSuSuaChua[index];
                            return ItemLichSuSuaChua(
                              suaChua: item.suaChua,
                              hoaDonSuaChua: item.hoaDonSuaChua,
                              onClick: () => moChiTietLichSuSuaChua(item),
                            );
                          }),
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

                      onPressed: _showXoaDialog,

                      child: const Text(
                        "Ẩn thiết bị",

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
            if (vm.hienMenu)
              Positioned(top: 12, right: 16, child: _buildMenu()),
          ],
        ),
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
                      fontSize: 12,
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
                  vm.hienMenu = false;
                });

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThietBiForm(thietBi: vm.thietBi),
                  ),
                );

                if (result is ThietBi) {
                  setState(() {
                    vm.thietBi = result;
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
                  vm.hienMenu = false;
                });

                await Future.delayed(const Duration(milliseconds: 150));

                if (mounted) {
                  _showCapNhatTrangThai();
                }
              },
            ),
            if (widget.SoLuongLapDat == 0)
              _menuItem(
                icon: Icons.delete_outline,

                iconColor: Colors.red,

                iconBg: const Color(0xffFFECEC),

                title: "Ẩn thiết bị",

                subTitle: "Không thể hoàn tác",

                titleColor: Colors.red,

                onTap: () {
                  setState(() {
                    vm.hienMenu = false;
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: context.read<SuaChuaProvider>(),
                        child: PhieuSuaChuaForm(thietBi: vm.thietBi),
                      ),
                    ),
                  );

                  if (result is SuaChuaDTO) {
                    vm.capNhatTrangThai("Đang sửa");

                    vm.themLichSuSuaChua(result);

                    setState(() {});
                  }
                },

                child: const Text(
                  "Lập phiếu SC",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
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

          title: const Text("Ẩn thiết bị"),

          content: Text(
            "Bạn có chắc chắn muốn ẩn '${vm.thietBi.tenThietBi}' ?\n\nHành động này không thể hoàn tác.",
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

              onPressed: () async {
                Navigator.pop(context); // đóng dialog trước

                final ok = await vm.xoaThietBi();

                if (!mounted) return;

                if (ok) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text("Đã ẩn thiết bị thành công")),
                  );
                  Navigator.of(this.context).pop(true); // quay lại trang trước
                } else {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text("Không thể ẩn thiết bị. Vui lòng thử lại."),
                    ),
                  );
                }
              },

              child: const Text("Ẩn", style: TextStyle(color: Colors.white)),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final ok = await vm.capNhatTrangThai(
                                trangThaiTam,
                              );

                              if (ok) {
                                Navigator.pop(context);
                                if (mounted) {
                                  setState(() {});
                                }
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
                                fontSize: 16,
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
