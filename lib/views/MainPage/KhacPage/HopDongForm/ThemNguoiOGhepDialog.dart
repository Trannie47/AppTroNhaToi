import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/hopDongForm/HopDongFormViewModel.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/hopDongForm/ThemNguoiOGhepDialogViewModel.dart';

class ThemNguoiOGhepDialog extends StatelessWidget {
  final HopDongFormViewModel formViewModel;

  const ThemNguoiOGhepDialog({super.key, required this.formViewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ThemNguoiOGhepDialogViewModel(formViewModel: formViewModel),
      child: Consumer<ThemNguoiOGhepDialogViewModel>(
        builder: (context, vm, child) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: const Text(
              "Thêm người ở ghép",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CCCD / Mã định danh",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.cccdController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      decoration: _dialogInputDecoration(
                        hint: "Nhập CCCD hoặc mã định danh",
                        errorText: vm.errCccd,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Họ tên",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.hoTenController,
                      decoration: _dialogInputDecoration(
                        hint: "VD: Nguyễn Thị B",
                        errorText: vm.errHoTen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Số điện thoại",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.sdtController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: _dialogInputDecoration(
                        hint: "VD: 0901234567",
                        errorText: vm.errSdt,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mối quan hệ với đại diện",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: vm.quanHeController,
                      decoration: _dialogInputDecoration(
                        hint: "VD: Vợ, Con, Bạn ở cùng...",
                        errorText: vm.errQuanHe,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (vm.submit()) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Thêm", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _dialogInputDecoration({required String hint, String? errorText}) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      errorMaxLines: 2,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: const Color(0xffF7F7F7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff2D7A3A), width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
    );
  }
}
