import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/item_phong_model.dart';
import '../../../../modelviews/MainPage/HomePage/GhiDienNuocHomePage/GhiDienNuocHomePageViewModel.dart';
import '../../PhongPage/ChiTietPhongPage/TrangChucNang/GhiDienNuocPage/ghiDienNuocPage.dart';

class GhiDienNuocHomePage extends StatefulWidget {
  const GhiDienNuocHomePage({super.key});

  @override
  State<GhiDienNuocHomePage> createState() => _GhiDienNuocHomePageState();
}

class _GhiDienNuocHomePageState extends State<GhiDienNuocHomePage> {
  late GhiDienNuocHomePageViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GhiDienNuocHomePageViewModel(context.read<PhongProvider>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.refresh();
    });
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chọn phòng ghi điện nước",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Nhấn vào phòng bất kỳ để nhập chỉ số điện nước",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        body: Consumer<GhiDienNuocHomePageViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff2D7A3A)),
              );
            }

            if (vm.listPhong.isEmpty) {
              return const Center(
                child: Text(
                  "Chưa có phòng trọ nào trong hệ thống!",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.listPhong.length,
              itemBuilder: (context, index) {
                final itemPhong = vm.listPhong[index];
                return _buildItemPhong(context, itemPhong);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemPhong(BuildContext context, ItemPhongModel itemPhong) {
    String textTrangThai = "Đang thuê";
    Color bgTrangThai = const Color(0xffFFF1E1);
    Color textColorTrangThai = const Color(0xffFF8A00);

    if (itemPhong.trangThai == 0) {
      textTrangThai = "Phòng trống";
      bgTrangThai = const Color(0xffE8F7EC);
      textColorTrangThai = const Color(0xff2D7A3A);
    } else if (itemPhong.trangThai == 2) {
      textTrangThai = "Đang sửa";
      bgTrangThai = const Color(0xffFFEAEA);
      textColorTrangThai = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffECECEC)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GhiDienNuocPage(
                  phongId: itemPhong.phongId,
                  tenPhong: itemPhong.tenPhong,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon điện nước bên trái
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF3EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Color(0xff2D7A3A),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Thông tin phòng
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phòng ${itemPhong.tenPhong}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff111111),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${itemPhong.loaiPhong.tenLoaiPhong} · ${formatMoney(itemPhong.loaiPhong.giaTien)}/tháng",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff888888),
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge trạng thái & Nút điều hướng
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: bgTrangThai,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        textTrangThai,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: textColorTrangThai,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          "Ghi số",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xff2D7A3A),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
