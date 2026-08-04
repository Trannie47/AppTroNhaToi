import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../Provider/hop_dong_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/DTO/HopDongDTO.dart';

class GiaHanHopDongViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final HopDongDTO hopDongDTO;

  GiaHanHopDongViewModel(this._hopDongProvider, this.hopDongDTO);

  final txtNgayHetHanMoi = TextEditingController();
  final txtGhiChu = TextEditingController();

  DateTime? ngayHetHanMoiSelected;
  List<File> listImagePhuLuc = [];
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  String? errorMessage;
  String? errNgayHetHanMoi;

  int selectedMonthOption = 6;

  void init() {
    chonNhanhThang(6);
  }

  bool kiemTraHopDongKhaDungGiaHan() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final ngayHetHanCu = DateTime(
      hopDongDTO.ngayHetHan.year,
      hopDongDTO.ngayHetHan.month,
      hopDongDTO.ngayHetHan.day,
    );

    // Tính số ngày còn lại
    final soNgayConLai = ngayHetHanCu.difference(today).inDays;

    // Nếu còn trên 30 ngày -> Không cho gia hạn
    if (soNgayConLai > 30) {
      errorMessage =
          "Hợp đồng còn $soNgayConLai ngày nữa mới hết hạn. Chỉ được gia hạn khi còn từ 30 ngày trở xuống!";
      return false;
    }
    return true;
  }

  void chonNhanhThang(int soThang) {
    selectedMonthOption = soThang;
    final ngayHetHanCu = hopDongDTO.ngayHetHan;

    // Tính ngày hết hạn mới = Ngày cũ + số tháng
    ngayHetHanMoiSelected = DateTime(
      ngayHetHanCu.year,
      ngayHetHanCu.month + soThang,
      ngayHetHanCu.day,
    );

    txtNgayHetHanMoi.text = formatDate(ngayHetHanMoiSelected!);
    errNgayHetHanMoi = null;
    notifyListeners();
  }

  Future<void> chonNgay(BuildContext context) async {
    final ngayHetHanCu = hopDongDTO.ngayHetHan;

    // Mốc tối thiểu phải gia hạn từ 3 tháng trở lên
    final minDate = DateTime(
      ngayHetHanCu.year,
      ngayHetHanCu.month + 3,
      ngayHetHanCu.day,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          (ngayHetHanMoiSelected != null &&
              ngayHetHanMoiSelected!.isAfter(minDate))
          ? ngayHetHanMoiSelected!
          : minDate,
      firstDate: minDate, // Khóa không cho chọn ít hơn 3 tháng
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      ngayHetHanMoiSelected = picked;
      txtNgayHetHanMoi.text = formatDate(picked);
      errNgayHetHanMoi = null;

      // Check xem ngày chọn có trùng mốc 3, 6, 12 tháng không để highlight nút
      _checkHighlightMatch(ngayHetHanCu, picked);

      notifyListeners();
    }
  }

  // Kiểm tra xem ngày người dùng chọn từ lịch có khớp tròn 3, 6, 12 tháng không
  void _checkHighlightMatch(DateTime ngayCu, DateTime ngayMoi) {
    final d3 = DateTime(ngayCu.year, ngayCu.month + 3, ngayCu.day);
    final d6 = DateTime(ngayCu.year, ngayCu.month + 6, ngayCu.day);
    final d12 = DateTime(ngayCu.year, ngayCu.month + 12, ngayCu.day);

    if (ngayMoi.year == d3.year &&
        ngayMoi.month == d3.month &&
        ngayMoi.day == d3.day) {
      selectedMonthOption = 3;
    } else if (ngayMoi.year == d6.year &&
        ngayMoi.month == d6.month &&
        ngayMoi.day == d6.day) {
      selectedMonthOption = 6;
    } else if (ngayMoi.year == d12.year &&
        ngayMoi.month == d12.month &&
        ngayMoi.day == d12.day) {
      selectedMonthOption = 12;
    } else {
      selectedMonthOption = 0; // Tùy chỉnh ngày riêng
    }
  }

  // Quản lý chọn & xóa ảnh
  Future<void> selectImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      listImagePhuLuc.addAll(images.map((x) => File(x.path)));
      notifyListeners();
    }
  }

  void deleteImage(int index) {
    listImagePhuLuc.removeAt(index);
    notifyListeners();
  }

  //Validate dữ liệu trước khi gọi API
  bool kiemTraDuLieu() {
    errNgayHetHanMoi = null;
    if (ngayHetHanMoiSelected == null) {
      errNgayHetHanMoi = "Vui lòng chọn ngày hết hạn mới";
      notifyListeners();
      return false;
    }

    final ngayHetHanCu = hopDongDTO.ngayHetHan;
    final minDate = DateTime(
      ngayHetHanCu.year,
      ngayHetHanCu.month + 3,
      ngayHetHanCu.day,
    );

    if (ngayHetHanMoiSelected!.isBefore(minDate)) {
      errNgayHetHanMoi = "Thời hạn gia hạn tối thiểu phải từ 3 tháng trở lên";
      notifyListeners();
      return false;
    }

    return true;
  }

  //Gọi API gia hạn
  Future<bool> giaHanHopDong() async {
    if (!kiemTraDuLieu()) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _hopDongProvider.renewHopDong(
        hopDongId: hopDongDTO.hopDongID,
        ngayHetHanMoi: ngayHetHanMoiSelected!,
        ghiChu: txtGhiChu.text.trim().isNotEmpty ? txtGhiChu.text.trim() : null,
        files: listImagePhuLuc.isNotEmpty ? listImagePhuLuc : null,
      );
      await _hopDongProvider.getListHD();
      isLoading = false;
      notifyListeners();
      return true; // Trả về true báo thành công
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  bool get coThayDoi => listImagePhuLuc.isNotEmpty || txtGhiChu.text.isNotEmpty;

  @override
  void dispose() {
    txtNgayHetHanMoi.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}
