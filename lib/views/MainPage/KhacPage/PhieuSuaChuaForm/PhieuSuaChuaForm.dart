import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaFormViewModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhieuSuaChuaForm extends StatefulWidget {
  final ThietBi thietBi;
  final int? phongID;
  final String tenPhong;

  const PhieuSuaChuaForm({
    super.key,
    required this.thietBi,
    this.phongID,
    required this.tenPhong,
  });

  @override
  State<PhieuSuaChuaForm> createState() => _PhieuSuaChuaFormState();
}

class _PhieuSuaChuaFormState extends State<PhieuSuaChuaForm> {
  final vm = PhieuSuaChuaViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),

            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        titleSpacing: 0,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Lập phiếu sửa chữa",

              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

            Text(
              "${widget.thietBi.tenThietBi} · ${widget.tenPhong}",

              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Thông tin sự cố",

                    style: TextStyle(
                      color: Color(0xff2D7A3A),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _input(
                    title: "Ngày sửa chữa",

                    hint: "dd/MM/yyyy",

                    controller: vm.txtNgaySuaChua,

                    errorText: vm.errNgaySuaChua,

                    keyboardType: TextInputType.number,

                    inputFormatters: [MaskedInputFormatter('##/##/####')],

                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined, size: 20),

                      onPressed: () async {
                        await vm.chonNgay(context, vm.txtNgaySuaChua);

                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  _input(
                    title: "Nguyên nhân / Triệu chứng",

                    controller: vm.txtNguyenNhan,

                    errorText: vm.errNguyenNhan,

                    maxLines: 4,
                  ),

                  const SizedBox(height: 16),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    title: const Text(
                      "Đã sửa xong",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4A4A4A),
                      ),
                    ),

                    value: vm.daSuaXong,

                    activeColor: const Color(0xff2E7D32),

                    onChanged: (value) {
                      setState(() {
                        vm.doiTrangThaiSuaXong(value);
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  _input(
                    title: "Chi phí sửa chữa",

                    hint: "0",

                    controller: vm.txtChiPhi,

                    errorText: vm.errChiPhi,

                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),

        child: SizedBox(
          height: 54,

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2E7D32),

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            onPressed: () {
              if (vm.kiemTraDuLieu()) {
                SuaChua suaChua = SuaChua(
                  phongID: widget.phongID,

                  nguyenNhan: vm.txtNguyenNhan.text,

                  ngaySuaChua: vm.chuyenNgay(vm.txtNgaySuaChua.text),
                );

                print(suaChua);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lưu phiếu sửa chữa thành công"),
                  ),
                );
                Navigator.pop(context, suaChua);
              }

              setState(() {});
            },

            child: const Text(
              "Lưu phiếu sửa chữa",

              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    vm.dispose();

    super.dispose();
  }

  Widget _input({
    required String title,
    String? hint,
    required TextEditingController controller,
    String? errorText,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff4A4A4A),
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: maxLines == 1 ? 65 : 99,

          child: TextField(
            controller: controller,

            maxLines: maxLines == 1 ? 1 : null,

            expands: maxLines > 1,

            keyboardType: keyboardType,

            inputFormatters: inputFormatters,

            decoration: InputDecoration(
              hintText: hint,

              suffixIcon: suffixIcon,

              filled: true,

              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

                borderSide: const BorderSide(color: Color(0xffE5E5E5)),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

                borderSide: const BorderSide(color: Color(0xff2D7A3A)),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),

        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),

            child: Text(
              errorText,

              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
