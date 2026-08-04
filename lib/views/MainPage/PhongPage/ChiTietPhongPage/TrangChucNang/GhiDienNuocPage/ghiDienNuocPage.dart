import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:AppTroNhaToi/Provider/dien_nuoc_provider.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/TrangChucNang/GhiDienNuocPage/ghiDienNuocPageViewModel.dart';

class GhiDienNuocPage extends StatelessWidget {
  final int phongId;
  final String tenPhong;

  const GhiDienNuocPage({
    super.key,
    required this.phongId,
    required this.tenPhong,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final provider = ctx.read<DienNuocProvider>();
        final vm = GhiDienNuocPageViewModel(provider);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final now = DateTime.now();
          final currentThangNam =
              '${now.month.toString().padLeft(2, '0')}/${now.year}';
          vm.init(phongId, currentThangNam);
        });
        return vm;
      },
      child: _GhiDienNuocView(phongId: phongId, tenPhong: tenPhong),
    );
  }
}

class _GhiDienNuocView extends StatelessWidget {
  final int phongId;
  final String tenPhong;

  const _GhiDienNuocView({required this.phongId, required this.tenPhong});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GhiDienNuocPageViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, vm),
                Expanded(child: _buildBody(context, vm)),
              ],
            ),
          ),
          if (vm.isSubmitting)
            AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black.withOpacity(0.45),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Đang xử lý...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, GhiDienNuocPageViewModel vm) {
    final thangNamHienThi = DateFormat('MM/yyyy').format(vm.selectedDate);
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ghi điện nước',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Phòng $tenPhong '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, GhiDienNuocPageViewModel vm) {
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
            ElevatedButton.icon(
              onPressed: () {
                final formatThangNam =
                    "${vm.selectedDate.month.toString().padLeft(2, '0')}/${vm.selectedDate.year}";
                vm.init(phongId, formatThangNam);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4B7A47),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTopInfoCard(context, vm),
          const SizedBox(height: 16),
          _buildDienCard(context, vm),
          const SizedBox(height: 16),
          _buildNuocCard(context, vm),
          const SizedBox(height: 24),
          _buildSaveButton(context, vm),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  //mở bảng chọn ngày tháng
  Widget _buildTopInfoCard(BuildContext context, GhiDienNuocPageViewModel vm) {
    final ngayHienThi = DateFormat('dd/MM/yyyy').format(vm.selectedDate);

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: vm.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
          helpText: 'Chọn ngày ghi nhận số điện nước',
        );
        if (picked != null) {
          await vm.changeSelectedDate(picked);
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
                Text(
                  'Ngày ghi chỉ số',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff4B7A47),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.calendar_today, size: 16, color: Color(0xff4B7A47)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ngayHienThi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff4B7A47),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDienCard(BuildContext context, GhiDienNuocPageViewModel vm) {
    return _buildMeterCard(
      context: context,
      title: 'Chỉ số điện (kWh)',
      unit: 'kWh',
      headerColor: const Color(0xff2D7A3A),
      newBorderColor: const Color(0xff2D7A3A),
      cuController: vm.dienCuController,
      moiController: vm.dienMoiController,
      cuImageFile: vm.anhDienCuFile,
      moiImageFile: vm.anhDienMoiFile,
      imageUrlCu: vm.urlAnhDienCu,
      imageUrlMoi: vm.urlAnhDienMoi,
      onPickCu: () => vm.pickImage('dienCu'),
      onPickMoi: () => vm.pickImage('dienMoi'),
    );
  }

  Widget _buildNuocCard(BuildContext context, GhiDienNuocPageViewModel vm) {
    return _buildMeterCard(
      context: context,
      title: 'Chỉ số nước (m³)',
      unit: 'm³',
      headerColor: const Color(0xff1565C0),
      newBorderColor: const Color(0xff4F46E5),
      cuController: vm.nuocCuController,
      moiController: vm.nuocMoiController,
      cuImageFile: vm.anhNuocCuFile,
      moiImageFile: vm.anhNuocMoiFile,
      imageUrlCu: vm.urlAnhNuocCu,
      imageUrlMoi: vm.urlAnhNuocMoi,
      onPickCu: () => vm.pickImage('nuocCu'),
      onPickMoi: () => vm.pickImage('nuocMoi'),
    );
  }

  Widget _buildMeterCard({
    required BuildContext context,
    required String title,
    required String unit,
    required Color headerColor,
    required Color newBorderColor,
    required TextEditingController cuController,
    required TextEditingController moiController,
    required File? cuImageFile,
    required File? moiImageFile,
    required String? imageUrlCu,
    required String? imageUrlMoi,
    required VoidCallback onPickCu,
    required VoidCallback onPickMoi,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildInputColumn(
                    label: 'Chỉ số cũ',
                    controller: cuController,
                    unit: unit,
                    borderColor: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputColumn(
                    label: 'Chỉ số mới',
                    controller: moiController,
                    unit: unit,
                    borderColor: newBorderColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                _buildImageBox(
                  context: context,
                  title: 'Ảnh tháng cũ',
                  imageFile: cuImageFile,
                  imageUrl: imageUrlCu,
                  onTap: onPickCu,
                ),
                const SizedBox(width: 12),
                _buildImageBox(
                  context: context,
                  title: 'Ảnh tháng mới',
                  imageFile: moiImageFile,
                  imageUrl: imageUrlMoi,
                  onTap: onPickMoi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputColumn({
    required String label,
    required TextEditingController controller,
    required String unit,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // lọc ko cho nhập những kí tự ngoài kí tự số
                  ],
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(unit, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  // hiển thị ảnh local hoặc ảnh online linh hoạt
  Widget _buildImageBox({
    required BuildContext context,
    required String title,
    required File? imageFile,
    required String? imageUrl,
    required VoidCallback onTap,
  }) {
    // Xác định hình thức hiển thị ảnh
    DecorationImage? imageDecoration;
    if (imageFile != null) {
      imageDecoration = DecorationImage(
        image: FileImage(imageFile),
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageDecoration = DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.add_a_photo,
                  size: 16,
                  color: Color(0xff4B7A47),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              if (imageFile != null) {
                _xemAnhTo(context, file: imageFile);
              } else if (imageUrl != null && imageUrl.isNotEmpty) {
                _xemAnhTo(context, url: imageUrl);
              } else {
                onTap();
              }
            },
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                image: imageDecoration,
              ),
              child: imageDecoration == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.grey.shade400,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Chưa có ảnh',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                            ),
                          ),
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

  //Hàm xem ảnh phóng to
  void _xemAnhTo(BuildContext context, {File? file, String? url}) {
    ImageProvider imageProvider;
    if (file != null) {
      imageProvider = FileImage(file);
    } else {
      imageProvider = NetworkImage(url!);
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: Image(image: imageProvider, fit: BoxFit.contain),
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

  Widget _buildSaveButton(BuildContext context, GhiDienNuocPageViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => vm.createDienNuoc(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff4B7A47),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          vm.mode == 'UPDATE'
              ? 'Cập nhật chỉ số điện nước'
              : 'Lưu chỉ số điện nước',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
