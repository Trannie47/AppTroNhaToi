import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AppTroNhaToi/Provider/dien_nuoc_provider.dart';
import 'package:AppTroNhaToi/models/dien_nuoc.dart';

class GhiDienNuocPageViewModel extends ChangeNotifier {
  final DienNuocProvider _provider;

  GhiDienNuocPageViewModel(this._provider);

  int? phongId;
  String? thangNam;
  DateTime selectedDate = DateTime.now();

  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  String? submitErrorMessage;

  String? mode;
  bool isFirstTime = false;

  String? urlAnhDienCu;
  String? urlAnhDienMoi;
  String? urlAnhNuocCu;
  String? urlAnhNuocMoi;

  String? anhDienCuPath;
  String? anhDienMoiPath;
  String? anhNuocCuPath;
  String? anhNuocMoiPath;

  File? anhDienCuFile;
  File? anhDienMoiFile;
  File? anhNuocCuFile;
  File? anhNuocMoiFile;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController dienCuController = TextEditingController();
  final TextEditingController dienMoiController = TextEditingController();
  final TextEditingController nuocCuController = TextEditingController();
  final TextEditingController nuocMoiController = TextEditingController();

  Future<void> init(
    int phongId,
    String thangNam, {
    bool updateDateFromRecord = true,
  }) async {
    this.phongId = phongId;
    this.thangNam = thangNam;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _provider.getInitData(phongId, thangNam);

      mode = _provider.mode;
      isFirstTime = _provider.isFirstTime;
      final data = _provider.currentDienNuoc;

      if (data != null) {
        dienCuController.text = data.chiSoDienCu?.toString() ?? '0';
        nuocCuController.text = data.chiSoNuocCu?.toString() ?? '0';

        if (mode == "UPDATE") {
          dienMoiController.text =
              (data.chiSoDienMoi == null || data.chiSoDienMoi == 0)
              ? ''
              : data.chiSoDienMoi.toString();
          nuocMoiController.text =
              (data.chiSoNuocMoi == null || data.chiSoNuocMoi == 0)
              ? ''
              : data.chiSoNuocMoi.toString();
          //Load ngày lên khi mở màn lần đầu, ko đè ngày khi chủ trọ tự chọn ngày
          if (updateDateFromRecord && data.ngayGhi != null) {
            selectedDate = DateTime.parse(
              data.ngayGhi!,
            ).toLocal(); //để chuyển múi giờ Server về múi giờ điện thoại
          }
        } else {
          dienMoiController.clear();
          nuocMoiController.clear();
        }

        // Đổ link ảnh online từ server vào biến trạng thái
        urlAnhDienCu = data.anhDienCu;
        urlAnhDienMoi = data.anhDienMoi;
        urlAnhNuocCu = data.anhNuocCu;
        urlAnhNuocMoi = data.anhNuocMoi;

        // Reset file local cũ để tránh bị chồng chéo dữ liệu khi đổi tháng
        _clearLocalFiles();
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _clearLocalFiles() {
    anhDienCuPath = null;
    anhDienMoiPath = null;
    anhNuocCuPath = null;
    anhNuocMoiPath = null;
    anhDienCuFile = null;
    anhDienMoiFile = null;
    anhNuocCuFile = null;
    anhNuocMoiFile = null;
  }

  //Vì bộ khóa của điẹn nước là PhongID,thangnam,lan  nên mỗi lần chủ trọ bấm vào tháng khác thì sẽ là ghi chỉ số mới cho tháng đó vậy nên sẽ phải load lại trang
  Future<void> changeSelectedDate(DateTime pickedDate) async {
    final newThangNam =
        "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
    //nếu trùng tháng/năm hiện tại (chỉ đổi ngày trong tháng)
    // Thì KHÔNG gọi API, KHÔNG reset để giữ nguyên chỉ số đang nhập
    if (newThangNam == this.thangNam) {
      selectedDate = pickedDate;
      notifyListeners();
      return;
    }

    // Nếu KHÁC tháng/năm (chủ trọ chủ động chuyển sang hẳn kỳ tháng khác)
    // Thì mới cập nhật ngày và load lại dữ liệu lịch sử của tháng mới đó
    selectedDate = pickedDate;
    if (phongId != null) {
      await init(phongId!, newThangNam, updateDateFromRecord: false);
    }
  }

  //Chọn ảnh từ máy
  Future<void> pickImage(String type, {bool fromCamera = false}) async {
    final XFile? image = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    final file = File(image.path);
    final path = image.path;

    switch (type) {
      case 'dienCu':
        anhDienCuPath = path;
        anhDienCuFile = file;
        break;
      case 'dienMoi':
        anhDienMoiPath = path;
        anhDienMoiFile = file;
        break;
      case 'nuocCu':
        anhNuocCuPath = path;
        anhNuocCuFile = file;
        break;
      case 'nuocMoi':
        anhNuocMoiPath = path;
        anhNuocMoiFile = file;
        break;
    }
    notifyListeners();
  }

  // Gửi dữ liệu lưu lên Server
  Future<void> createDienNuoc(BuildContext context) async {
    final dienMoi = int.tryParse(dienMoiController.text.trim());
    final nuocMoi = int.tryParse(nuocMoiController.text.trim());
    final dienCu = int.tryParse(dienCuController.text.trim()) ?? 0;
    final nuocCu = int.tryParse(nuocCuController.text.trim()) ?? 0;

    if (dienMoi == null || nuocMoi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ chỉ số mới!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (dienMoi < dienCu) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Chỉ số điện mới không được nhỏ hơn chỉ số cũ!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (nuocMoi < nuocCu) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Chỉ số nước mới không được nhỏ hơn chỉ số cũ!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    isSubmitting = true;
    submitErrorMessage = null;
    notifyListeners();

    try {
      final dienNuoc = DienNuoc(
        phongId: phongId,
        thangNam: thangNam,
        lanGhi: mode == "UPDATE"
            ? (_provider.currentDienNuoc?.lanGhi ?? 1)
            : null,
        chiSoDienCu: int.tryParse(dienCuController.text.trim()) ?? 0,
        chiSoDienMoi: dienMoi,
        chiSoNuocCu: int.tryParse(nuocCuController.text.trim()) ?? 0,
        chiSoNuocMoi: nuocMoi,
        ngayGhi: DateTime.utc(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        ).toIso8601String(),
      );
      if (mode == "UPDATE") {
        await _provider.updateDienNuoc(
          dienNuoc,
          anhDienCuPath: anhDienCuPath,
          anhDienMoiPath: anhDienMoiPath,
          anhNuocCuPath: anhNuocCuPath,
          anhNuocMoiPath: anhNuocMoiPath,
        );
      } else {
        await _provider.createDienNuoc(
          dienNuoc,
          anhDienCuPath: anhDienCuPath,
          anhDienMoiPath: anhDienMoiPath,
          anhNuocCuPath: anhNuocCuPath,
          anhNuocMoiPath: anhNuocMoiPath,
        );
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            mode == "UPDATE" ? "Cập nhật thành công!" : "Lưu thành công!",
          ),
          backgroundColor: const Color(0xff4B7A47),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      submitErrorMessage = e.toString().replaceAll('Exception: ', '');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(submitErrorMessage ?? "Lỗi hệ thống!"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isSubmitting = false;
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
