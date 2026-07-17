import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AppTroNhaToi/Provider/dien_nuoc_provider.dart';

class GhiDienNuocPageViewModel extends ChangeNotifier {
  final DienNuocProvider _provider;

  GhiDienNuocPageViewModel(this._provider);

  bool isLoading = false;
  String? errorMessage;
  String? mode;
  bool isFirstTime = false;

  int trangThaiDienNuoc = 0;
  DateTime selectedDate = DateTime.now();

  File? anhDienCu;
  File? anhDienMoi;
  File? anhNuocCu;
  File? anhNuocMoi;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController dienCuController = TextEditingController();
  final TextEditingController dienMoiController = TextEditingController();
  final TextEditingController nuocCuController = TextEditingController();
  final TextEditingController nuocMoiController = TextEditingController();

  Future<void> init(int phongId, String thangNam) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final parts = thangNam.split('/');
      if (parts.length == 2) {
        final month = int.tryParse(parts[0]) ?? DateTime.now().month;
        final year = int.tryParse(parts[1]) ?? DateTime.now().year;
        if (month == DateTime.now().month && year == DateTime.now().year) {
          selectedDate = DateTime.now();
        } else {
          selectedDate = DateTime(year, month, 1);
        }
      }

      await _provider.getInitData(phongId, thangNam);

      if (_provider.errorMessage != null) {
        errorMessage = _provider.errorMessage;
        return;
      }

      mode = _provider.mode;
      isFirstTime = _provider.isFirstTime;
      final data = _provider.currentDienNuoc;

      if (data != null) {
        trangThaiDienNuoc = data.trangThai ?? 0;

        dienCuController.text = data.chiSoDienCu?.toString() ?? '0';
        nuocCuController.text = data.chiSoNuocCu?.toString() ?? '0';

        if (mode == "UPDATE") {
          dienMoiController.text = (data.chiSoDienMoi == null || data.chiSoDienMoi == 0) ? '' : data.chiSoDienMoi.toString();
          nuocMoiController.text = (data.chiSoNuocMoi == null || data.chiSoNuocMoi == 0) ? '' : data.chiSoNuocMoi.toString();
        } else {
          dienMoiController.clear();
          nuocMoiController.clear();
        }
      } else {
        trangThaiDienNuoc = 0;
        dienMoiController.clear();
        nuocMoiController.clear();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //khi thay đổi ngày thì gọi lại api để init lại dữ liệu trên UI
  Future<void> changeSelectedDate(int phongId, DateTime newDate) async {
    selectedDate = newDate;
    final formatThangNam = "${newDate.month.toString().padLeft(2, '0')}/${newDate.year}";
    await init(phongId, formatThangNam);
  }

  Future<void> pickImage(String type) async {
    if (trangThaiDienNuoc == 1) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      if (type == 'dienMoi') anhDienMoi = file;
      if (type == 'nuocMoi') anhNuocMoi = file;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    dienCuController.dispose();
    dienMoiController.dispose();
    nuocCuController.dispose();
    nuocMoiController.dispose();
    super.dispose();
  }
}