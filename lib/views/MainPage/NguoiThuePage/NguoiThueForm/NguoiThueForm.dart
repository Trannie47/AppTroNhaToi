import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/views/MainPage/NguoiThuePage/qr_cccd_scanner_page/qr_cccd_scanner_page.dart';
import 'package:flutter/material.dart';

class NguoiThueForm extends StatefulWidget {
  final NguoiThue? nguoiThue;

  const NguoiThueForm({super.key, this.nguoiThue});

  @override
  State<NguoiThueForm> createState() => _NguoiThueFormState();
}

class _NguoiThueFormState extends State<NguoiThueForm> {
  late NguoiThueFormViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = NguoiThueFormViewModel(nguoiThueInput: widget.nguoiThue);

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  //Function mở trang quét QR code CCCD
  Future<void> _openQRScanner() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => const QRCCCDScannerPage(),
    );

    if (result != null && result.isNotEmpty) {
      vm.parseCCCDQR(result);
    }
  }

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

          child: Container(height: 1, color: const Color(0xffF1F1F1)),
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

        decoration: const BoxDecoration(color: Color(0xffF7F9FC)),

        child: SizedBox(
          height: 52,

          child: ElevatedButton(
            onPressed: () async {
              if (vm.formKey.currentState!.validate()) {
                await vm.luuNguoiThue(context);
              }
            },

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

      body: Form(
        key: vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),

          child: Column(
            children: [
              // /// SEARCH
              GestureDetector(
                onTap: () {
                  _openQRScanner();
                },

                child: Container(
                  height: 72,

                  margin: const EdgeInsets.only(bottom: 16),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2B2854), Color(0xFF4A468B)],
                    ),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Row(
                    children: [
                      SizedBox(width: 16),

                      Icon(Icons.qr_code_scanner, color: Colors.white),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Quét mã QR trên thẻ CCCD",

                              style: TextStyle(
                                color: Colors.white,

                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              "Tự động điền nhanh họ tên, ngày sinh, địa chỉ...",

                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),

                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              /// THÔNG TIN CÁ NHÂN
              _section(
                title: "Thông tin cá nhân",

                child: Column(
                  children: [
                    _input(
                      title: "Họ và tên",
                      hint: "Nhập họ và tên đầy đủ",
                      controller: vm.txtHoTen,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Vui lòng nhập họ tên";
                        }
                        return null;
                      },
                    ),

                    _input(
                      title: "Số điện thoại",
                      hint: "VD: 0901 234 567",
                      controller: vm.txtSDT,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập số điện thoại";
                        }

                        if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
                          return "Số điện thoại phải gồm đúng 10 số";
                        }

                        return null;
                      },
                    ),

                    _input(
                      title: "Số CCCD ( Căn cước công dân)",
                      hint: "Nhập số CCCD/CMND",
                      controller: vm.txtCCCD,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập CCCD";
                        }

                        if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                          return "CCCD phải gồm đúng 12 số";
                        }

                        return null;
                      },
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

                                TextFormField(
                                  controller: vm.txtNgaySinh,

                                  validator: (value) {

                                    if (value == null || value.isEmpty) {
                                      return "Vui lòng nhập ngày sinh";
                                    }

                                    try {

                                      List<String> arr = value.split('/');

                                      if (arr.length != 3) {
                                        return "Ngày sinh không hợp lệ";
                                      }

                                      DateTime ngaySinh = DateTime(
                                        int.parse(arr[2]),
                                        int.parse(arr[1]),
                                        int.parse(arr[0]),
                                      );

                                      if (ngaySinh.day != int.parse(arr[0]) ||
                                          ngaySinh.month != int.parse(arr[1]) ||
                                          ngaySinh.year != int.parse(arr[2])) {
                                        return "Ngày sinh không hợp lệ";
                                      }

                                      int tuoi = DateTime.now().year - ngaySinh.year;

                                      if (DateTime.now().month < ngaySinh.month ||
                                          (DateTime.now().month == ngaySinh.month &&
                                              DateTime.now().day < ngaySinh.day)) {
                                        tuoi--;
                                      }

                                      if (tuoi < 0 || tuoi > 120) {
                                        return "Tuổi không hợp lệ";
                                      }

                                    } catch (_) {
                                      return "Ngày sinh không hợp lệ";
                                    }

                                    return null;
                                  },

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

                                    if (newText != vm.txtNgaySinh.text) {
                                      vm.txtNgaySinh.value = TextEditingValue(
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
                                          vm.txtNgaySinh.text =
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

                                FormField<bool>(
                                  validator: (value) {
                                    if (vm.gioiTinh == null) {
                                      return "Vui lòng chọn giới tính";
                                    }
                                    return null;
                                  },

                                  builder: (state) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),

                                          decoration: BoxDecoration(
                                            color: const Color(0xffF8F8F8),
                                            borderRadius: BorderRadius.circular(14),
                                          ),

                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<bool>(
                                              value: vm.gioiTinh,

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
                                                  vm.gioiTinh = value;
                                                });

                                                state.didChange(value);
                                              },
                                            ),
                                          ),
                                        ),

                                        if (state.hasError)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              state.errorText!,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    _input(
                      title: "Quê quán",
                      hint: "Tỉnh / Thành phố",
                      controller: vm.txtQueQuan,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Vui lòng nhập quê quán";
                        }

                        return null;
                      },
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

                    TextFormField(
                      controller: vm.txtGhiChu,
                      maxLines: 2,

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
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
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
    String? Function(String?)? validator,
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

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,

            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(
                color: Color(0xffB5B5B5),
                fontSize: 13,
              ),

              errorStyle: const TextStyle(color: Colors.red, fontSize: 11),

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

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),

          if (subTitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subTitle,
              style: const TextStyle(fontSize: 11, color: Color(0xffB5B5B5)),
            ),
          ],
        ],
      ),
    );
  }
}
