import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/Provider/loai_phong_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../modelviews/MainPage/PhongPage/loaiPhongModelViewsForm/FormLoaiPhong.dart';

class FormLoaiPhong extends StatefulWidget {
  final Function(LoaiPhong)? onAdd;
  final LoaiPhong? loaiPhong;

  const FormLoaiPhong({
    super.key,
    this.loaiPhong,
    this.onAdd,
  });

  @override
  State<FormLoaiPhong> createState() => _FormLoaiPhongState();
}

class _FormLoaiPhongState extends State<FormLoaiPhong> {
  late FormLoaiPhongViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = FormLoaiPhongViewModel(
      context.read<LoaiPhongProvider>(),
      widget.loaiPhong,
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void xuLyLuuVaTiepTuc() async {
    if (!vm.kiemTraDuLieu()) return;
    final result = await vm.saveLoaiPhongProcess();
    if (!mounted) return;

    if (result != null) {
      widget.onAdd?.call(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm mới loại phòng thành công!"),
          backgroundColor: Colors.green,
        ),
      );
      vm.clear();
    } else {
      _showErrorSnackbar(vm.messageError ?? "Đã có lỗi xảy ra!");
    }
  }

  void xuLyLuuLoaiPhong() async {
    if (!vm.kiemTraDuLieu()) return;
    final result = await vm.saveLoaiPhongProcess();
    if (!mounted) return;

    if (result != null) {
      widget.onAdd?.call(result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm mới loại phòng thành công!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, result);
    } else {
      _showErrorSnackbar(vm.messageError ?? "Đã có lỗi xảy ra!");
    }
  }

  void _showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.loaiPhong != null;
    final isSaving = vm.isSaving;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF6F7F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isEdit ? "Chỉnh sửa loại phòng" : "Thêm loại phòng",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7A3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: isSaving ? null : xuLyLuuLoaiPhong,
                    child: Text(
                      isEdit ? "Lưu thay đổi" : "Lưu loại phòng",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!isEdit)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isSaving ? null : xuLyLuuVaTiepTuc,
                      child: const Text(
                        "Lưu & thêm loại phòng khác",
                        style: TextStyle(
                          color: Color(0xFF2D7A3A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _section(
                  title: "Thông tin loại phòng",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tên loại phòng", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: vm.tenLoaiPhongController,
                        decoration: InputDecoration(
                          hintText: "VD: Tiêu chuẩn, VIP, Phòng đôi...",
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          errorText: vm.errTenLoaiPhong,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Tên hiển thị khi chọn loại lúc thêm phòng", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _inputBox(
                              title: "Diện tích",
                              controller: vm.dienTichController,
                              hintText: "VD : 25",
                              suffix: "m²",
                              errorText: vm.errDienTich,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _inputBox(
                              title: "Số người tối đa",
                              controller: vm.soNguoiController,
                              suffix: "người",
                              hintText: "VD : 2",
                              errorText: vm.errSoNguoi,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _inputBox(
                        title: "Giá thuê",
                        controller: vm.giaTienController,
                        suffix: "đ/tháng",
                        hintText: "VD : 2000000",
                        errorText: vm.errGiaTien,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 10),
                      const Text("Giá mặc định khi lập hợp đồng cho phòng thuộc loại này", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _section(
                  title: "Tiện nghi",
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Có máy lạnh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text("Phòng được trang bị máy lạnh sẵn", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Switch(
                        value: vm.isMayLanh,
                        activeTrackColor: const Color(0xFF2D7A3A),
                        activeColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                        inactiveThumbColor: Colors.white,
                        onChanged: vm.toggleMayLanh,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSaving)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  elevation: 5,
                  shape: CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7A3A)),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF2D7A3A), fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _inputBox({
    required String title,
    required TextEditingController controller,
    required String suffix,
    String? hintText,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
            hintText: hintText,
            errorMaxLines: 2,
            errorText: errorText,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                widthFactor: 1,
                child: Text(suffix, style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}