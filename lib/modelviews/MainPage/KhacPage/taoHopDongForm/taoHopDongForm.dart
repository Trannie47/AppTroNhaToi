import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class TaoHopDongForm extends StatefulWidget {
  const TaoHopDongForm({super.key});

  @override
  State<TaoHopDongForm> createState() => _TaoHopDongPageState();
}

class _TaoHopDongPageState extends State<TaoHopDongForm> {
  final txtPhong = TextEditingController();
  final txtNguoiThue = TextEditingController();

  final txtNgayKy = TextEditingController();
  final txtNgayHetHan = TextEditingController();

  final txtTongGiaPhong = TextEditingController();
  final txtGiaHopDong = TextEditingController();
  final txtGiaDeXuat = TextEditingController();

  final txtTienCoc = TextEditingController();
  final txtGhiChu = TextEditingController();

  Future<void> chonNgay(
      TextEditingController controller,
      ) async {
    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );


    if (ngay != null) {
      controller.text =
      "${ngay.day.toString().padLeft(2, '0')}/"
          "${ngay.month.toString().padLeft(2, '0')}/"
          "${ngay.year}";
    }
  }

  DateTime? chuyenNgay(String ngay) {
    try {
      final tach = ngay.split('/');

      return DateTime(
        int.parse(tach[2]),
        int.parse(tach[1]),
        int.parse(tach[0]),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    txtPhong.dispose();
    txtNguoiThue.dispose();
    txtNgayKy.dispose();
    txtNgayHetHan.dispose();
    txtTongGiaPhong.dispose();
    txtGiaHopDong.dispose();
    txtGiaDeXuat.dispose();
    txtTienCoc.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 61,
        leading: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: Material(
              color: const Color(0xffF3F3F3),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Tạo hợp đồng",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _section(
              title: "Thông tin thuê",
              child: Column(
                children: [
                  _label("Phòng thuê"),
                  _textfield(
                    controller: txtPhong,
                    hint: "Nhập phòng thuê",
                  ),

                  const SizedBox(height: 16),

                  _label("Người thuê chính"),
                  _textfield(
                    controller: txtNguoiThue,
                    hint: "Nhập người thuê",
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _label("Ngày ký"),
                            _dateField(txtNgayKy),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            _label("Ngày hết hạn"),
                            _dateField(txtNgayHetHan),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _section(
              title: "Thiết lập giá thuê",
              child: Column(
                children: [
                  _label("Tổng giá phòng"),
                  _textfield(
                    controller: txtTongGiaPhong,
                    hint: "Nhập tổng giá phòng",
                    keyboardType:
                    TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  _label("Giá thuê của hợp đồng"),
                  _textfield(
                    controller: txtGiaHopDong,
                    hint: "Nhập giá thuê hợp đồng",
                    keyboardType:
                    TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  _label(
                    "Giá thuê đề xuất cho người đang ở",
                  ),
                  _textfield(
                    controller: txtGiaDeXuat,
                    hint: "Nhập giá đề xuất",
                    keyboardType:
                    TextInputType.number,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _section(
              title: "Cọc & ghi chú",
              child: Column(
                children: [
                  _label("Tiền cọc"),
                  _textfield(
                    controller: txtTienCoc,
                    hint: "Nhập tiền cọc",
                    keyboardType:
                    TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  _label("Ghi chú"),
                  _textfield(
                    controller: txtGhiChu,
                    hint: "Nhập ghi chú",
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {

                  final ngayKy =
                  chuyenNgay(txtNgayKy.text);

                  final ngayHetHan =
                  chuyenNgay(txtNgayHetHan.text);

                  if (ngayKy == null ||
                      ngayHetHan == null) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Vui lòng nhập ngày hợp lệ",
                        ),
                      ),
                    );
                    return;
                  }

                  if (!ngayHetHan.isAfter(ngayKy)) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Ngày hết hạn phải lớn hơn ngày ký",
                        ),
                      ),
                    );
                    return;
                  }

                  print("Lưu hợp đồng");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xff2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tạo hợp đồng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xffC62828),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Hủy bỏ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2E7D32),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _textfield({
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xffF7F7F7),
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateField(
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskedInputFormatter(
          '##/##/####',
        ),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_month,
          ),
          onPressed: () {
            chonNgay(controller);
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xffEAEAEA),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xff2D7A3A),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}