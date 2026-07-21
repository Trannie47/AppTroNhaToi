import 'package:AppTroNhaToi/Provider/phuong_tien_provider.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';

class PhuongTienFormViewModel extends ChangeNotifier {
  final PhuongTien? phuongTienSua;

  final txtHangXe = TextEditingController();
  final txtBienSo = TextEditingController();
  final txtMauSac = TextEditingController();
  final txtGiaGui = TextEditingController();

  int loaiXe = 0;
  int? selectedPhongId;
  String? selectedTenPhong;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isEditing => phuongTienSua != null;

  PhuongTienFormViewModel({
    this.phuongTienSua,
  }) {
    if (phuongTienSua != null) {
      txtHangXe.text = phuongTienSua!.hangXe ?? "";
      txtBienSo.text = phuongTienSua!.bienSo ?? "";
      txtMauSac.text = phuongTienSua!.mauSac ?? "";
      txtGiaGui.text = (phuongTienSua!.giaGui ?? 0).toInt().toString();
      loaiXe = phuongTienSua!.loaiXe;
      selectedPhongId = phuongTienSua!.phongId;
      selectedTenPhong = phuongTienSua!.tenPhong;
    }
  }

  void changeLoaiXe(int value) {
    loaiXe = value;
    notifyListeners();
  }

  void selectPhong(int? pId, String? tPhong) {
    selectedPhongId = pId;
    selectedTenPhong = tPhong;
    notifyListeners();
  }

  Future<bool> savePhuongTien({
    required PhuongTienProvider provider,
    required int idnt,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final giaGuiVal = double.tryParse(txtGiaGui.text.trim()) ?? 0.0;

    final xeData = PhuongTien(
      ID: phuongTienSua?.ID ?? 0,
      bienSo: txtBienSo.text.trim(),
      hangXe: txtHangXe.text.trim(),
      mauSac: txtMauSac.text.trim(),
      giaGui: giaGuiVal,
      loaiXe: loaiXe,
      idnt: idnt,
      phongId: selectedPhongId,
      tenPhong: selectedTenPhong,
    );

    bool success = false;
    if (isEditing) {
      success = await provider.updatePhuongTien(phuongTienSua!.ID, xeData);
    } else {
      success = await provider.createPhuongTien(xeData);
    }

    if (!success) {
      _errorMessage = provider.errorMessage ?? "Đã có lỗi xảy ra, vui lòng thử lại!";
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  @override
  void dispose() {
    txtHangXe.dispose();
    txtBienSo.dispose();
    txtMauSac.dispose();
    txtGiaGui.dispose();
    super.dispose();
  }
}