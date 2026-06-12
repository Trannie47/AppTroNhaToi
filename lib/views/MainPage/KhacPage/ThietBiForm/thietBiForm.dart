import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/thietBiForm/thietBiFormViewModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class ThietBiForm extends StatefulWidget {
  final ThietBi? thietBi;

  const ThietBiForm({super.key, this.thietBi});

  @override
  State<ThietBiForm> createState() => _ThietBiFormState();
}

class _ThietBiFormState extends State<ThietBiForm> {
  late ThietBiFormViewModel vm;

  Widget _input({
    required String title,
    required String hint,
    required TextEditingController controller,
    String? errorText,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,

            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon,
              errorText: errorText,

              errorMaxLines: 2,
              errorStyle: const TextStyle(
                fontSize: 11,
                height: 1.2,),

              filled: true,
              fillColor: const Color(0xffF8F8F8),

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
                borderSide: const BorderSide(
                  color: Color(0xff2E7D32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropDownLoaiThietBi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Loại thiết bị",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: vm.loaiThietBi,

          decoration: InputDecoration(
            errorText: vm.errLoaiThietBi,

            filled: true,
            fillColor: const Color(0xffF8F8F8),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),

          hint: const Text("--Chọn loại thiết bị--"),

          items: vm.dsLoaiThietBi
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),

          onChanged: (value) {
            setState(() {
              vm.loaiThietBi = value;
            });
          },
        ),
      ],
    );
  }


  Widget _dropDownTrangThai() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Trạng thái",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: vm.trangThai,

          decoration: InputDecoration(
            errorText: vm.errTrangThai,

            filled: true,
            fillColor: const Color(0xffF8F8F8),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),

          hint: const Text("--Chọn trạng thái--"),

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
    );
  }


  Widget _dropDownPhong() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Phòng lắp đặt",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<int>(
          value: vm.phongID,

          decoration: InputDecoration(
            errorText: vm.errPhong,

            filled: true,
            fillColor: const Color(0xffF8F8F8),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),

          hint: const Text("--Chọn phòng--"),

          items: const [

            DropdownMenuItem(
              value: 1,
              child: Text("P101"),
            ),

            DropdownMenuItem(
              value: 2,
              child: Text("P102"),
            ),

            DropdownMenuItem(
              value: 3,
              child: Text("P103"),
            ),
          ],

          onChanged: (value) {
            setState(() {
              vm.phongID = value;
            });
          },
        ),
      ],
    );
  }






  @override
  void initState() {
    super.initState();

    vm = ThietBiFormViewModel(thietBiInput: widget.thietBi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 6,
        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),

            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            ),
          ),
        ),

        title: Text(
          widget.thietBi == null ? "Thêm thiết bị" : "Sửa thiết bị",

          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: SizedBox(
          height: 55,

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2E7D32),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            onPressed: () {

              bool hopLe = vm.kiemTraDuLieu();

              setState(() {});

              if (!hopLe) {
                return;
              }

              Navigator.pop(
                context,
                true,
              );
            },

            child: Text(
              widget.thietBi == null ? "Lưu thiết bị" : "Cập nhật thiết bị",

              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Thông tin thiết bị",
                style: TextStyle(
                  color: Color(0xff2D7A3A),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              _input(
                title: "Tên thiết bị",
                hint: "VD: Máy lạnh Daikin 1HP",
                controller: vm.txtTenThietBi,
                errorText: vm.errTenThietBi,
              ),

              const SizedBox(height: 16),

              _dropDownLoaiThietBi(),

              const SizedBox(height: 16),

              _dropDownPhong(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _input(
                      title: "Ngày mua",
                      hint: "dd/MM/yyyy",
                      controller: vm.txtNgayMua,
                      errorText: vm.errNgayMua,

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

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {

                            vm.txtNgayMua.text = formatDate(
                              pickedDate,
                            );

                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _input(
                      title: "Giá trị (đ)",
                      hint: "0",
                      controller: vm.txtGiaTri,
                      keyboardType: TextInputType.number,
                      errorText: vm.errGiaTri,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _dropDownTrangThai(),


            ],
          ),
        ),
      ),
    );
  }
}
