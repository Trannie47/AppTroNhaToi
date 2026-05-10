import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/HomePage/FormLoaiPhong/FormLoaiPhong.dart';
import 'package:AppTroNhaToi/widget/itemLoaiPhongSelectBox.dart';
import 'package:flutter/material.dart';

class FormPhong extends StatefulWidget {
  final Phong? room;

  const FormPhong({super.key, this.room});

  @override
  State<FormPhong> createState() => _FormPhongState();
}

class _FormPhongState extends State<FormPhong> {
  late TextEditingController nameController;
  late TextEditingController descController;

  int selectedType = 0;
  int selectedStatus = 0;

  final List<LoaiPhong> roomTypes = [
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

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.room?.tenPhong ?? "");

    descController = TextEditingController(text: widget.room?.moTa ?? "");

    selectedStatus = widget.room?.trangThai ?? 0;
    selectedType = widget.room?.maLoaiPhong ?? 0;
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  void saveRoom() {
    Phong room = Phong(
      phongID: widget.room?.phongID ?? 0,
      tenPhong: nameController.text,
      trangThai: selectedStatus,
      moTa: descController.text,
      maLoaiPhong: selectedType,
    );

    Navigator.pop(context, room);
  }

  //Tiến đến trang tạo mới loại phòng nếu có thêm mới thì sẽ cập nhật lại danh sách loại phòng
  void goToFormRoomType() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormLoaiPhong()),
    );

    if (result != null && result is LoaiPhong) {
      setState(() {
        roomTypes.add(result);
        selectedType = roomTypes.length - 1;
      });
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
          onPressed: () {
            Navigator.pop(context);
          },
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

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "VD: 101, A01, Phòng 1...",
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
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

                  Row(
                    children: [
                      Expanded(
                        child: _statusItem(
                          title: "Còn trống",
                          color: Colors.green,
                          selected: selectedStatus == 0,
                          onTap: () {
                            setState(() {
                              selectedStatus = 0;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statusItem(
                          title: "Đang thuê",
                          color: Colors.orange,
                          selected: selectedStatus == 1,
                          onTap: () {
                            setState(() {
                              selectedStatus = 1;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statusItem(
                          title: "Đang sửa chữa",
                          color: Colors.red,
                          selected: selectedStatus == 2,
                          onTap: () {
                            setState(() {
                              selectedStatus = 2;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// LOẠI PHÒNG
            _section(
              title: "Loại phòng",
              child: Column(
                children: [
                  ...List.generate(roomTypes.length, (index) {
                    final item = roomTypes[index];
                    bool selected = selectedType == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = index;
                        });
                      },
                      child: itemLoaiPhongSelectBox(item, selected),
                    );
                  }),

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
                          Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF2D7A3A),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Thêm loại phòng mới",
                            style: TextStyle(
                              color: Color(0xFF2D7A3A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// MÔ TẢ
            _section(
              title: "Mô tả",
              child: TextField(
                controller: descController,
                maxLines: 5,
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
