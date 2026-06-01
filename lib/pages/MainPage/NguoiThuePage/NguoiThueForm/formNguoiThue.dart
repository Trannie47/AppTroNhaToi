import 'package:flutter/material.dart';

class FormNguoiThue extends StatelessWidget {

  final TextEditingController txtHoTen;

  final TextEditingController txtSDT;

  final TextEditingController txtCCCD;

  final TextEditingController txtNgaySinh;

  final TextEditingController txtQueQuan;

  final TextEditingController txtPhong;

  final TextEditingController txtVaiTro;

  final TextEditingController txtGhiChu;

  final bool? gioiTinh;

  final Function(bool?) onChangedGioiTinh;

  const FormNguoiThue({

    super.key,

    required this.txtHoTen,

    required this.txtSDT,

    required this.txtCCCD,

    required this.txtNgaySinh,

    required this.txtQueQuan,

    required this.txtPhong,

    required this.txtVaiTro,

    required this.txtGhiChu,

    required this.gioiTinh,

    required this.onChangedGioiTinh,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        /// THÔNG TIN CÁ NHÂN
        _section(

          title: "Thông tin cá nhân",

          child: Column(

            children: [

              _textField(

                label: "Họ và tên",

                hint: "Nhập họ và tên đầy đủ",

                controller: txtHoTen,
              ),

              const SizedBox(height: 12),

              _textField(

                label: "Số điện thoại",

                hint: "VD: 0901 234 567",

                controller: txtSDT,
              ),

              const SizedBox(height: 5),

              const Align(

                alignment: Alignment.centerLeft,

                child: Text(

                  "Mã QR CCCD không chứa số điện thoại , vui lòng tự nhập !",

                  style: TextStyle(

                    fontSize: 11,

                    color: Color(0xff8E8E93),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  _textField(

                    label: "Số CCCD ( Căn cước công dân)",

                    hint: "Nhập số CCCD/CMND",

                    controller: txtCCCD,
                  ),


                ],
              ),

              const SizedBox(height: 12),

              Row(

                children: [

                  Expanded(

                    child: _dateField(),
                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    child: _dropdownGioiTinh(),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              _textField(

                label: "Quê quán",

                hint: "Tỉnh / Thành phố",

                controller: txtQueQuan,
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// GHI CHÚ
        _section(

          title: "Ghi chú",


          child: TextField(

            controller: txtGhiChu,


            maxLines: 2,

            decoration: InputDecoration(
              hintText: "Nghề nghiệp, ghi chú thêm...",

              hintStyle: const TextStyle(
                color: Color(0xffB7B7B7),
                fontSize: 14,
              ),
              filled: true,

              fillColor: const Color(0xffFAFAFA),

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              enabledBorder:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color:
                  Color(0xffECECEC),
                ),
              ),

              focusedBorder:
              OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color:
                  Color(0xff2D7A3A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _section({

    required String title,

    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              fontSize: 15,

              fontWeight:
              FontWeight.w700,

              color:
              Color(0xff2D7A3A),
            ),
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _textField({

    required String label,

    required String hint,

    required TextEditingController controller,
  }) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style: const TextStyle(

            fontSize: 13,

            fontWeight:
            FontWeight.w600,

            color:
            Color(0xff333333),
          ),
        ),

        const SizedBox(height: 8),

        TextField(

          controller: controller,

          decoration: InputDecoration(

            hintText: hint,

            hintStyle: const TextStyle(
              fontSize: 14,
              color: Color(0xffB7B7B7),
            ),

            filled: true,

            fillColor:
            const Color(0xffFAFAFA),

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(16),

              borderSide:
              const BorderSide(
                color:
                Color(0xffECECEC),
              ),
            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(16),

              borderSide:
              const BorderSide(
                color:
                Color(0xff2D7A3A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField() {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(

          "Ngày sinh",

          style: TextStyle(

            fontSize: 13,

            fontWeight:
            FontWeight.w600,

            color:
            Color(0xff333333),
          ),
        ),

        const SizedBox(height: 8),

        TextField(

          controller: txtNgaySinh,

          decoration: InputDecoration(

            suffixIcon: const Icon(
              Icons.calendar_today_outlined,
              size: 18,
            ),

            filled: true,

            fillColor:
            const Color(0xffFAFAFA),

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(16),

              borderSide:
              const BorderSide(
                color:
                Color(0xffECECEC),
              ),
            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(16),

              borderSide:
              const BorderSide(
                color:
                Color(0xff2D7A3A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownGioiTinh() {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        const Text(

          "Giới tính",

          style: TextStyle(

            fontSize: 13,

            fontWeight:
            FontWeight.w600,

            color:
            Color(0xff333333),
          ),
        ),

        const SizedBox(height: 8),

        Container(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
          ),

          decoration: BoxDecoration(

            color:
            const Color(0xffFAFAFA),

            borderRadius:
            BorderRadius.circular(16),

            border: Border.all(
              color:
              const Color(0xffECECEC),
            ),
          ),

          child:
          DropdownButtonHideUnderline(

            child:
            DropdownButton<bool>(

              value: gioiTinh,

              isExpanded: true,

              borderRadius:
              BorderRadius.circular(16),

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

              onChanged:
              onChangedGioiTinh,
            ),
          ),
        ),
      ],
    );
  }
}