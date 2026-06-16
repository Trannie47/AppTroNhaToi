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
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(
            left: 18,
            top: 8,
            bottom: 8,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),
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
                fontSize: 22,
              ),
            ),

            Text(
              "${widget.thietBi.tenThietBi} · ${widget.tenPhong}",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// THÔNG TIN SỰ CỐ
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _input(
                    title: "Ngày sửa chữa",
                    hint: "dd/MM/yyyy",
                    controller: vm.txtNgaySuaChua,
                    errorText: vm.errNgaySuaChua,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      MaskedInputFormatter(
                        '##/##/####',
                      )
                    ],
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                      ),
                      onPressed: () async {
                        await vm.chonNgay(
                          context,
                          vm.txtNgaySuaChua,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _input(
                    title: "Nguyên nhân / Triệu chứng",
                    controller: vm.txtNguyenNhan,
                    errorText: vm.errNguyenNhan,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// TẠO HÓA ĐƠN
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [

                  const Expanded(
                    child: Text(
                      "Tạo hóa đơn",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Switch(
                    value: vm.taoHoaDon,
                    activeColor: const Color(0xff2D7A3A),
                    onChanged: (value) {
                      vm.doiTrangThaiTaoHoaDon(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (vm.taoHoaDon)
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
                      "Thông tin hóa đơn",
                      style: TextStyle(
                        color: Color(0xff2D7A3A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _input(
                      title: "Ngày lập hóa đơn",
                      hint: "dd/MM/yyyy",
                      controller: vm.txtNgayHoaDon,
                      errorText: vm.errNgayHoaDon,

                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskedInputFormatter(
                          '##/##/####',
                        ),
                      ],
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        onPressed: () async {
                          await vm.chonNgay(
                            context,
                            vm.txtNgayHoaDon,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    _input(
                      title: "Giá tiền sửa chữa",
                      hint: "0",
                      controller: vm.txtChiPhi,
                      errorText: vm.errChiPhi,
                      keyboardType: TextInputType.number,
                      suffixText: "Vnd",
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Loại sửa chữa",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4A4A4A),
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: vm.loaiSuaChua,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                      ),
                      hint: const Text(
                        "Chọn loại sửa chữa",
                      ),
                      items: vm.dsLoaiSuaChua
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          vm.loaiSuaChua = value;
                        });
                      },
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Trạng thái",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff4A4A4A),
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: vm.trangThai,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                      ),
                      hint: const Text(
                        "Chọn trạng thái",
                      ),
                      items: vm.dsTrangThai
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          vm.trangThai = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          20,
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2D7A3A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () {

              if (vm.kiemTraDuLieu()) {

                SuaChua suaChua = SuaChua(
                  phongID: widget.phongID,
                  nguyenNhan: vm.txtNguyenNhan.text,
                  ngaySuaChua: vm.chuyenNgay(
                    vm.txtNgaySuaChua.text,
                  ),
                );

                Navigator.pop(
                  context,
                  suaChua,
                );
              }

              setState(() {});
            },
            child: const Text(
              "Lưu phiếu sửa chữa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override

  Widget _input({
    required String title,
    String? hint,
    required TextEditingController controller,
    String? errorText,
    Widget? suffixIcon,
    String? suffixText,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff4A4A4A),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,

          decoration: InputDecoration(
            hintText: hint,
            errorText: null,

            suffixIcon: suffixIcon,

            suffixText: suffixText,

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 18,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xffE5E5E5),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff2D7A3A),
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }
}




