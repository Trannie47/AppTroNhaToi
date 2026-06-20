import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/FormPhong/FormPhongViewModel.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';
import 'package:AppTroNhaToi/view_models/phong_view_model.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/FormLoaiPhong/FormLoaiPhong.dart';
import 'package:AppTroNhaToi/widgets/itemLoaiPhongSelectBox.dart';
import 'package:flutter/material.dart';

import '../../../../view_models/loaiphong_view_model.dart';

class FormPhong extends StatefulWidget {
  final Phong? room;

  const FormPhong({super.key, this.room});

  @override
  State<FormPhong> createState() => _FormPhongState();
}

class _FormPhongState extends State<FormPhong> {
  late FormPhongViewModel vm;
  late LoaiPhongViewModel  loaiPhongViewModel;
  late PhongViewModel phongViewModel;

  @override
  void initState() {
    super.initState();
    loaiPhongViewModel= LoaiPhongViewModel();
    phongViewModel= PhongViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loaiPhongViewModel.getListLoaiPhong();
    });
    vm = FormPhongViewModel(widget.room);

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void saveRoom() {
    if (!phongViewModel.kiemTraDuLieu()) {
       print("Sai dữ liệu");
      return;
    }
    phongViewModel.saveRoom();

    //Navigator.pop(context, room);

  }

  void goToFormRoomType() async {
    final result = await Navigator.push(
      context,
        MaterialPageRoute(
          builder: (context) => FormLoaiPhong(
            onAdd: (loaiPhong) {
              vm.addRoomType(loaiPhong);
            },
          ),
        )
        );

    if (result != null && result is List<LoaiPhong>) {

      for (var item in result) {
        vm.addRoomType(item);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.room != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Chỉnh sửa phòng" : "Thêm phòng trọ",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D7A3A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: saveRoom,
            child: Text(
              isEdit ? "Lưu thay đổi" : "Lưu phòng trọ",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// THÔNG TIN PHÒNG
            _section(
              title: "Thông tin phòng",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tên phòng",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: loaiPhongViewModel,
                    builder: (context, _) {
                      return TextField(
                        controller: phongViewModel.nameController,
                        decoration: InputDecoration(
                          hintText: "VD: 101, A01, Phòng 1...",
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          errorText: phongViewModel.errTenPhong,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tên dùng để hiển thị và tìm kiếm phòng",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Trạng thái",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),

                  AnimatedBuilder(
                    animation: phongViewModel,
                    builder: (context, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: _statusItem(
                              title: "Còn trống",
                              color: Colors.green,
                              selected: phongViewModel.trangThai == 0,
                              onTap: () => phongViewModel.setTrangThai(0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statusItem(
                              title: "Đang thuê",
                              color: Colors.orange,
                              selected: phongViewModel.trangThai == 1,
                              onTap: () => phongViewModel.setTrangThai(1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statusItem(
                              title: "Đang sửa chữa",
                              color: Colors.red,
                              selected: phongViewModel.trangThai == 2,
                              onTap: () => phongViewModel.setTrangThai(2),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            //Xử lý các trạng thái khi gọi api load Loại phòng lên
            _section(
                title: "Loại phòng",
                child: AnimatedBuilder(
                  animation: loaiPhongViewModel,
                    builder: (context, _) {
                      final state = loaiPhongViewModel.loaiphongState;

                      switch (state) {
                        //Load phòng lên
                        case LoaiPhongLoading():
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7A3A)),
                              ),
                            ),
                          );
                          //Load Loại phòng lên gặp lỗi
                        case LoaiPhongError():
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 28),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Lỗi: ${state.messageError}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.withOpacity(0.08),
                                      foregroundColor: Colors.red.shade700,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () => loaiPhongViewModel.getListLoaiPhong(),
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text(
                                      "Thử lại",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        //Load phòng thành công
                        case LoaiPhongSuccess():
                          final danhSachLoai = state.listLoaiPhong;

                          if (danhSachLoai.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  "Chưa có loại phòng nào dưới hệ thống.",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            );
                          }

                          return AnimatedBuilder(
                            animation: phongViewModel,
                            builder: (context, _) {
                              return Column(
                                children: [
                                  ...List.generate(danhSachLoai.length, (index) {
                                    final item = danhSachLoai[index];

                                    bool selected = phongViewModel.idLoaiPhong == index;

                                    return GestureDetector(
                                      onTap: () {
                                        phongViewModel.setIdLoaiPhong(index);
                                      },
                                      child: itemLoaiPhongSelectBox(item, selected),
                                    );
                                  }),
                                  const SizedBox(height: 12),

                                  // Nút thêm loại phòng mới giữ nguyên...
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: const Color(0xFFB6DDBE)),
                                    ),
                                    child: InkWell(
                                      onTap: goToFormRoomType,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_circle_outline, color: Color(0xFF2D7A3A)),
                                          SizedBox(width: 8),
                                          Text("Thêm loại phòng mới", style: TextStyle(color: Color(0xFF2D7A3A), fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                      }

                    }
                )
            ),

            const SizedBox(height: 16),

            /// MÔ TẢ
            _section(
              title: "Mô tả",
              child: TextField(
                controller: phongViewModel.descController,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D7A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _statusItem({
    required String title,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? color : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
