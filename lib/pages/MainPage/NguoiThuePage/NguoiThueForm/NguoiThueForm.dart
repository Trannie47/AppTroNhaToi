import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ThemNguoiThuePage extends StatefulWidget {
  const ThemNguoiThuePage({super.key});

  @override
  State<ThemNguoiThuePage> createState() => _ThemNguoiThuePageState();
}

class _ThemNguoiThuePageState extends State<ThemNguoiThuePage> {
  final TextEditingController txtSearch = TextEditingController();

  final TextEditingController txtHoTen = TextEditingController();

  final TextEditingController txtSDT = TextEditingController();

  final TextEditingController txtCCCD = TextEditingController();

  final TextEditingController txtNgaySinh = TextEditingController();

  final TextEditingController txtQueQuan = TextEditingController();

  final TextEditingController txtPhong = TextEditingController();

  final TextEditingController txtVaiTro = TextEditingController();

  final TextEditingController txtGhiChu = TextEditingController();

  bool? gioiTinh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        toolbarHeight: 61,

        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        titleSpacing: 10,
        leadingWidth: 46,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),

          child: Container(
            height: 1,
            color: const Color(0xffF1F1F1),
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.only(left: 10),

          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 36,
              height: 36,

              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: Color(0xff1C1C1E),
              ),
            ),
          ),
        ),

        title: const Text(
          "Thêm người thuê",

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xff1C1C1E),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),

        decoration: const BoxDecoration(
          color: Color(0xffF7F9FC),
        ),

        child: SizedBox(
          height: 52,

          child: ElevatedButton(
            onPressed: () {},

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2D7A3A),
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            child: const Text(
              "Lưu người thuê",

              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),

        child: Column(
          children: [
            // /// SEARCH
            // _searchBox(),
            //
            // const SizedBox(height: 7),

            /// THÔNG TIN CÁ NHÂN
            _section(
              title: "Thông tin cá nhân",

              child: Column(
                children: [
                  _input(
                    title: "Họ và tên",
                    hint: "Nhập họ và tên đầy đủ",
                    controller: txtHoTen,
                  ),

                  _input(
                    title: "Số điện thoại",
                    hint: "VD: 0901 234 567",
                    controller: txtSDT,
                    keyboardType: TextInputType.phone,
                  ),

                  _input(
                    title: "CCCD",
                    hint: "Nhập số CCCD/CMND",
                    controller: txtCCCD,
                    keyboardType: TextInputType.number,
                    subTitle: "Dùng để xác thực và tạo hợp đồng",
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Ngày sinh",

                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1C1C1E),
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(
                                controller: txtNgaySinh,

                                keyboardType: TextInputType.datetime,

                                onTapOutside: (_) {
                                  FocusScope.of(context).unfocus();
                                },

                                onChanged: (value) {
                                  String text = value.replaceAll("/", "");

                                  if (text.length > 8) {
                                    text = text.substring(0, 8);
                                  }

                                  String newText = "";

                                  for (int i = 0; i < text.length; i++) {
                                    if (i == 2 || i == 4) {
                                      newText += "/";
                                    }

                                    newText += text[i];
                                  }

                                  if (newText != txtNgaySinh.text) {
                                    txtNgaySinh.value = TextEditingValue(
                                      text: newText,

                                      selection: TextSelection.collapsed(
                                        offset: newText.length,
                                      ),
                                    );
                                  }
                                },

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),

                                decoration: InputDecoration(
                                  hintText: "dd/mm/yyyy",

                                  hintStyle: const TextStyle(
                                    color: Color(0xffB5B5B5),
                                    fontSize: 13,
                                  ),

                                  suffixIcon: IconButton(
                                    onPressed: () async {

                                      DateTime? picked = await showDatePicker(
                                        context: context,

                                        initialDate: DateTime.now(),

                                        firstDate: DateTime(1950),

                                        lastDate: DateTime.now(),
                                      );
                                      if (picked != null) {
                                        txtNgaySinh.text =
                                        "${picked.day.toString().padLeft(2, '0')}/"
                                            "${picked.month.toString().padLeft(2, '0')}/"
                                            "${picked.year}";
                                      }
                                    },

                                    icon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Color(0xff999999),
                                      size: 20,
                                    ),
                                  ),

                                  filled: true,
                                  fillColor: const Color(0xffF8F8F8),

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 13,
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Giới tính",

                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1C1C1E),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14),

                                decoration: BoxDecoration(
                                  color: const Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<bool>(
                                    value: gioiTinh,

                                    isExpanded: true,

                                    hint: const Text(
                                      "Chọn giới tính",

                                      style: TextStyle(
                                        color: Color(0xffB5B5B5),
                                        fontSize: 13,
                                      ),
                                    ),

                                    items: const [
                                      DropdownMenuItem(
                                        value: true,
                                        child: Text("Nam"),
                                      ),

                                      DropdownMenuItem(
                                        value: false,
                                        child: Text("Nữ"),
                                      ),
                                    ],

                                    onChanged: (value) {
                                      setState(() {
                                        gioiTinh = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  _input(
                    title: "Quê quán",
                    hint: "Tỉnh / Thành phố",
                    controller: txtQueQuan,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// PHÂN CÔNG PHÒNG
            _section(
              title: "Phân công phòng",

              child: Column(
                children: [
                  _input(
                    title: "Phòng thuê",
                    hint: "",
                    controller: txtPhong,
                  ),

                  _input(
                    title: "Vai trò",
                    hint: "",
                    controller: txtVaiTro,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// GHI CHÚ
            _section(
              title: "Ghi chú",

              child: Column(
                children: [
                  const SizedBox(height: 12),

                  TextField(
                    controller: txtGhiChu,
                    maxLines: 5,

                    decoration: InputDecoration(
                      hintText: "",

                      filled: true,
                      fillColor: const Color(0xffF8F8F8),

                      contentPadding: const EdgeInsets.all(14),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
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
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff2D7A3A),
            ),
          ),

          child,
        ],
      ),
    );
  }

  Widget _input({
    required String title,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? subTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff1C1C1E),
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,
            keyboardType: keyboardType,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(
                color: Color(0xffB5B5B5),
                fontSize: 13,
              ),

              filled: true,
              fillColor: const Color(0xffF8F8F8),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          if (subTitle != null) ...[
            const SizedBox(height: 6),

            Text(
              subTitle,

              style: const TextStyle(
                fontSize: 11,
                color: Color(0xffB5B5B5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}