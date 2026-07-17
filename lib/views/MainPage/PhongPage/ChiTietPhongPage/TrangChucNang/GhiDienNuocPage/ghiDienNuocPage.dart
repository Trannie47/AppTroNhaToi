import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/Provider/dien_nuoc_provider.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/TrangChucNang/GhiDienNuocPage/ghiDienNuocPageViewModel.dart';
import '../../../../../../core/utils/date_formatter.dart';

class GhiDienNuocPage extends StatelessWidget {
  final int phongID;
  final String tenPhong;

  const GhiDienNuocPage({
    super.key,
    required this.phongID,
    required this.tenPhong,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = context.read<DienNuocProvider>();
        final vm = GhiDienNuocPageViewModel(provider);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final now = DateTime.now();
          final currentThangNam = "${now.month.toString().padLeft(2, '0')}/${now.year}";
          vm.init(phongID, currentThangNam);
        });
        return vm;
      },
      child: _GhiDienNuocView(phongID: phongID, tenPhong: tenPhong),
    );
  }
}

class _GhiDienNuocView extends StatefulWidget {
  final int phongID;
  final String tenPhong;

  const _GhiDienNuocView({
    required this.phongID,
    required this.tenPhong,
  });

  @override
  State<_GhiDienNuocView> createState() => _GhiDienNuocViewState();
}

class _GhiDienNuocViewState extends State<_GhiDienNuocView> {
  void _xemAnhTo(File? image) {
    if (image == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: Image.file(image, fit: BoxFit.contain),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Consumer<GhiDienNuocPageViewModel>(
                builder: (context, vm, child) {
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
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              final formatThangNam = "${vm.selectedDate.month.toString().padLeft(2, '0')}/${vm.selectedDate.year}";
                              vm.init(widget.phongID, formatThangNam);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff4B7A47)),
                            child: const Text("Thử lại", style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopInfo(vm),
                        const SizedBox(height: 16),
                        _buildDienCard(vm),
                        const SizedBox(height: 16),
                        _buildNuocCard(vm),
                        const SizedBox(height: 16),
                        _buildSaveButton(vm),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ghi điện nước",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Phòng ${widget.tenPhong}",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfo(GhiDienNuocPageViewModel vm) {
    final ngayHienTai = formatDate(vm.selectedDate);

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await chonNgayChuan(
          context,
          initialDate: vm.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          vm.changeSelectedDate(widget.phongID, picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffE8F5E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ngày ghi chỉ số", style: TextStyle(fontSize: 13, color: Color(0xff4B7A47))),
                Icon(Icons.calendar_today, size: 18, color: Color(0xff4B7A47)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ngayHienTai,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff4B7A47)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDienCard(GhiDienNuocPageViewModel vm) {
    final bool isLocked = vm.trangThaiDienNuoc == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Chỉ số điện (kWh)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff2D7A3A)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chỉ số cũ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isLocked ? const Color(0xffF5F5F5) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: vm.dienCuController,
                                readOnly: isLocked,
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey.shade600 : Colors.black,
                                ),
                              ),
                            ),
                            Text("kWh", style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vm.isFirstTime ? "Số đầu kỳ bàn giao" : "Tháng trước",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chỉ số mới", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isLocked ? const Color(0xffF5F5F5) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xff2D7A3A)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: vm.dienMoiController,
                                readOnly: isLocked,
                                decoration: const InputDecoration(
                                  hintText: "Nhập số",
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey.shade600 : Colors.black,
                                ),
                              ),
                            ),
                            Text("kWh", style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildImageBox(
                  title: "Ảnh tháng cũ",
                  image: vm.anhDienCu,
                  isNew: false,
                  onViewTap: () => _xemAnhTo(vm.anhDienCu),
                ),
                const SizedBox(width: 12),
                _buildImageBox(
                  title: "Ảnh tháng mới",
                  image: vm.anhDienMoi,
                  isNew: !isLocked,
                  onAddTap: () => vm.pickImage('dienMoi'),
                  onViewTap: () => _xemAnhTo(vm.anhDienMoi),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNuocCard(GhiDienNuocPageViewModel vm) {
    final bool isLocked = vm.trangThaiDienNuoc == 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Chỉ số nước (m³)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff2D7A3A)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chỉ số cũ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isLocked ? const Color(0xffF5F5F5) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: vm.nuocCuController,
                                readOnly: isLocked,
                                decoration: const InputDecoration(
                                  hintText: "0",
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey.shade600 : Colors.black,
                                ),
                              ),
                            ),
                            Text("m³", style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vm.isFirstTime ? "Số đầu kỳ bàn giao" : "Tháng trước",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Chỉ số mới", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isLocked ? const Color(0xffF5F5F5) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xff4F46E5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: vm.nuocMoiController,
                                readOnly: isLocked,
                                decoration: const InputDecoration(
                                  hintText: "Nhập số",
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey.shade600 : Colors.black,
                                ),
                              ),
                            ),
                            Text("m³", style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildImageBox(
                  title: "Ảnh tháng cũ",
                  image: vm.anhNuocCu,
                  isNew: false,
                  onViewTap: () => _xemAnhTo(vm.anhNuocCu),
                ),
                const SizedBox(width: 12),
                _buildImageBox(
                  title: "Ảnh tháng mới",
                  image: vm.anhNuocMoi,
                  isNew: !isLocked,
                  onAddTap: () => vm.pickImage('nuocMoi'),
                  onViewTap: () => _xemAnhTo(vm.anhNuocMoi),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBox({
    required String title,
    required File? image,
    required bool isNew,
    VoidCallback? onAddTap,
    VoidCallback? onViewTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              if (isNew)
                GestureDetector(
                  onTap: onAddTap,
                  child: const Icon(Icons.add_a_photo, size: 16, color: Color(0xff4B7A47)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onViewTap,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                image: image != null
                    ? DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: image == null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, color: Colors.grey.shade300, size: 36),
                    const SizedBox(height: 4),
                    Text("Chưa có ảnh", style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                  ],
                ),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(GhiDienNuocPageViewModel vm) {
    final bool isLocked = vm.trangThaiDienNuoc == 1;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLocked ? Colors.grey : const Color(0xff4B7A47),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: isLocked ? null : () {
          // lưu chỉ số
        },
        child: Text(
          isLocked
              ? "Kỳ này đã lập hóa đơn (Không thể sửa)"
              : (vm.mode == "UPDATE" ? "Cập nhật chỉ số điện nước" : "Lưu chỉ số điện nước"),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}