import 'package:flutter/material.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';

class FormRoomTypePage extends StatefulWidget {
  final LoaiPhong? loaiPhong;

  const FormRoomTypePage({super.key, this.loaiPhong});

  @override
  State<FormRoomTypePage> createState() => _FormRoomTypePageState();
}

class _FormRoomTypePageState extends State<FormRoomTypePage> {
  late TextEditingController tenLoaiPhongController;
  late TextEditingController dienTichController;
  late TextEditingController soNguoiController;
  late TextEditingController giaTienController;

  bool isMayLanh = false;

  @override
  void initState() {
    super.initState();

    tenLoaiPhongController = TextEditingController(
      text: widget.loaiPhong?.tenLoaiPhong ?? "",
    );

    dienTichController = TextEditingController(
      text: widget.loaiPhong?.dienTich.toString() ?? "",
    );

    soNguoiController = TextEditingController(
      text: widget.loaiPhong?.soNguoiToiDa.toString() ?? "",
    );

    giaTienController = TextEditingController(
      text: widget.loaiPhong?.giaTien.toStringAsFixed(0) ?? "",
    );

    isMayLanh = widget.loaiPhong?.isMayLanh ?? false;
  }

  @override
  void dispose() {
    tenLoaiPhongController.dispose();
    dienTichController.dispose();
    soNguoiController.dispose();
    giaTienController.dispose();
    super.dispose();
  }

  void saveLoaiPhong() {
    LoaiPhong loaiPhong = LoaiPhong(
      tenLoaiPhong: tenLoaiPhongController.text,
      dienTich: double.tryParse(dienTichController.text) ?? 0,
      soNguoiToiDa: int.tryParse(soNguoiController.text) ?? 0,
      giaTien: double.tryParse(giaTienController.text) ?? 0,
      isMayLanh: isMayLanh,
      maLoaiPhong: 12,
    );

    Navigator.pop(context, loaiPhong);
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.loaiPhong != null;

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
                onPressed: saveLoaiPhong,
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
                  onPressed: () {},
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
            /// THÔNG TIN
            _section(
              title: "Thông tin loại phòng",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TÊN
                  const Text(
                    "Tên loại phòng",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: tenLoaiPhongController,
                    decoration: InputDecoration(
                      hintText: "VD: Tiêu chuẩn, VIP, Phòng đôi...",
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
                    "Tên hiển thị khi chọn loại lúc thêm phòng",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  /// DIỆN TÍCH + SỐ NGƯỜI
                  Row(
                    children: [
                      Expanded(
                        child: _inputBox(
                          title: "Diện tích",
                          controller: dienTichController,
                          hintText: " VD : 2",
                          suffix: "m²",
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _inputBox(
                          title: "Số người tối đa",
                          controller: soNguoiController,
                          suffix: "người",
                          hintText: " VD : 5",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// GIÁ TIỀN
                  _inputBox(
                    title: "Giá thuê",
                    controller: giaTienController,
                    suffix: "đ/tháng",
                    hintText: " VD : 2000000",
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Giá mặc định khi lập hợp đồng cho phòng thuộc loại này",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// TIỆN NGHI
            _section(
              title: "Tiện nghi",
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Có máy lạnh",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Phòng được trang bị máy lạnh sẵn",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  Switch(
                    value: isMayLanh,
                    // nền khi bật
                    activeTrackColor: const Color(0xFF2D7A3A),

                    // nút tròn trắng
                    activeColor: Colors.white,

                    // nền khi tắt
                    inactiveTrackColor: Colors.grey.shade300,

                    // nút tròn trắng lúc tắt
                    inactiveThumbColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        isMayLanh = value;
                      });
                    },
                  ),
                ],
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

  Widget _inputBox({
    required String title,
    required TextEditingController controller,
    required String suffix,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

        const SizedBox(height: 10),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F3F3),

            hintText: hintText,

            // 👇 LUÔN HIỆN
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                widthFactor: 1,
                child: Text(
                  suffix,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
