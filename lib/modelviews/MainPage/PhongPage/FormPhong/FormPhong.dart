import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:flutter/material.dart';

class FormPhongViewModel extends ChangeNotifier {
  late TextEditingController nameController;
  late TextEditingController descController;

  int selectedType = 0;
  String selectedStatus = "";

  List<LoaiPhong> roomTypes = [
    LoaiPhong(
      maLoaiPhong: 1,
      tenLoaiPhong: "Tiêu chuẩn",
      dienTich: 18,
      isMayLanh: false,
      soNguoiToiDa: 2,
      giaTien: 3200000,
    ),
    LoaiPhong(
      maLoaiPhong: 2,
      tenLoaiPhong: "VIP",
      dienTich: 25,
      isMayLanh: true,
      soNguoiToiDa: 2,
      giaTien: 4500000,
    ),
  ];

  FormPhongViewModel(Phong? room) {
    nameController = TextEditingController(text: room?.tenPhong ?? "");
    descController = TextEditingController(text: room?.moTa ?? "");
    selectedStatus = room?.trangThai.toString() ?? "0";
    selectedType = room?.maLoaiPhong ?? 0;
  }

  void selectStatus(String status) {
    selectedStatus = status;
    notifyListeners();
  }

  void selectType(int index) {
    selectedType = index;
    notifyListeners();
  }

  void addRoomType(LoaiPhong loaiPhong) {
    roomTypes.add(loaiPhong);
    selectedType = roomTypes.length - 1;
    notifyListeners();
  }

  Phong buildPhong(int? phongID) {
    return Phong(
      phongID: phongID ?? 0,
      tenPhong: nameController.text,
      trangThai: int.parse(selectedStatus),
      moTa: descController.text,
      maLoaiPhong: selectedType,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
}
