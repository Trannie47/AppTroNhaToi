import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePage.dart';
import 'package:flutter/material.dart';

class ThemPhuongTienPage extends StatefulWidget {

  final NguoiThue nguoiThue;

  final Function(PhuongTien)? onSave;
  final PhuongTien? phuongTienSua;

  const ThemPhuongTienPage({
    super.key,
    required this.nguoiThue,
    this.onSave,
    this.phuongTienSua,
  });

  @override
  State<ThemPhuongTienPage> createState() =>
      _ThemPhuongTienPageState();
}

class _ThemPhuongTienPageState
    extends State<ThemPhuongTienPage> {

  final txtHangXe =
  TextEditingController();

  final txtBienSo =
  TextEditingController();

  final txtMauSac =
  TextEditingController();

  final txtGiaGui =
  TextEditingController();

  int loaiXe = 0;

  @override
  void initState() {

    super.initState();

    if(widget.phuongTienSua != null) {

      final xe =
      widget.phuongTienSua!;

      txtHangXe.text =
          xe.hangXe ?? "";

      txtBienSo.text =
          xe.bienSo ?? "";

      txtMauSac.text =
          xe.mauSac ?? "";

      txtGiaGui.text =
          (xe.giaGui ?? 0)
              .toString();

      loaiXe =
          xe.loaiXe ?? 0;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF7F9F7),

      body: SafeArea(

        child: Column(

          children: [

            /// HEADER
            Container(

              height: 72,

              color: Colors.white,

              padding:
              const EdgeInsets.fromLTRB(
                16,
                6,
                16,
                16,
              ),

              child: Row(

                children: [

                  GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(

                      width: 40,
                      height: 40,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(19),
                      ),

                      alignment:
                      Alignment.center,

                      child: const Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                        size: 16,
                        color:
                        Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Phương tiện",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.w700,
                            letterSpacing:
                            -0.3,
                            color:
                            Color(0xff1C1C1E),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(

                          widget.nguoiThue.hoTen
                              ?? "",

                          style:
                          const TextStyle(
                            fontSize: 12,
                            color: Color(
                              0xff8E8E93,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(

              child: ListView(

                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  140,
                ),

                children: [

                  /// THÔNG TIN XE
                  Container(

                    padding:
                    const EdgeInsets.all(
                      13,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),

                      boxShadow: [

                        BoxShadow(
                          color:
                          Colors.black
                              .withOpacity(
                            0.03,
                          ),
                          blurRadius: 12,
                          offset:
                          const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        const Text(

                          "Thông tin xe",

                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w700,
                            color: Color(
                              0xff2D7A3A,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        /// LOẠI XE
                        _title("Loại xe"),

                        const SizedBox(
                          height: 8,
                        ),

                        Row(

                          children: [

                            _itemLoaiXe(
                              title:
                              "Xe máy",
                              value: 0,
                              icon:
                              Icons
                                  .two_wheeler_rounded,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            _itemLoaiXe(
                              title: "Ô tô",
                              value: 1,
                              icon:
                              Icons
                                  .directions_car_filled_rounded,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            _itemLoaiXe(
                              title:
                              "Xe đạp",
                              value: 2,
                              icon:
                              Icons
                                  .pedal_bike_rounded,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _title("Hãng xe"),

                        _input(
                          controller:
                          txtHangXe,
                          hint:
                          "VD: Honda, Yamaha...",
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _title("Biển số xe"),

                        _input(
                          controller:
                          txtBienSo,
                          hint:
                          "VD: 59B1-123.45",
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        const Text(

                          "Xe đạp hoặc không có biển số thì để trống",

                          style: TextStyle(
                            fontSize: 11,
                            color: Color(
                              0xffA0A0A0,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _title("Màu sắc"),

                        _input(
                          controller:
                          txtMauSac,
                          hint:
                          "VD: Đen, trắng...",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PHÍ GỬI XE
                  Container(

                    padding:
                    const EdgeInsets.all(
                      16,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(
                        24,
                      ),
                      border: Border.all(
                        color: const Color(0xffE8EEE8),
                        width: 0.5,
                      ),


                      boxShadow: [

                        BoxShadow(
                          color:
                          Colors.black
                              .withOpacity(
                            0.03,
                          ),
                          blurRadius: 12,
                          offset:
                          const Offset(
                            0,
                            4,
                          ),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        const Text(

                          "Phí gửi xe",

                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w700,
                            color: Color(
                              0xff2D7A3A,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        _title(
                          "Giá gửi xe mặc định",
                        ),

                        Container(

                          height: 56,

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            16,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            const Color(
                              0xffF8F8F8,
                            ),

                            borderRadius:
                            BorderRadius.circular(
                              16,
                            ),

                            border:
                            Border.all(
                              color:
                              const Color(
                                0xffEAEAEA,
                              ),
                            ),
                          ),

                          child: Row(

                            children: [

                              Expanded(

                                child:
                                TextField(

                                  controller:
                                  txtGiaGui,

                                  keyboardType:
                                  TextInputType.number,

                                  decoration:
                                  const InputDecoration(
                                    border:
                                    InputBorder.none,

                                    hintText:
                                    "0",
                                  ),
                                ),
                              ),

                              const Text(

                                "đ/tháng",

                                style:
                                TextStyle(
                                  fontSize:
                                  13,
                                  color:
                                  Color(
                                    0xff9E9E9E,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const Text(

                          "Giá này sẽ tự điền khi tạo hóa đơn hàng tháng",

                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: Color(
                              0xffA0A0A0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BUTTON
      bottomNavigationBar: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            18,
          ),

          child: SizedBox(

            height: 56,

            child: ElevatedButton(

              onPressed: () {

                final xe =
                PhuongTien(

                  ID:
                  DateTime.now()
                      .millisecondsSinceEpoch,

                  bienSo:
                  txtBienSo.text,

                  hangXe:
                  txtHangXe.text,

                  mauSac:
                  txtMauSac.text,

                  giaGui:
                  double.tryParse(
                    txtGiaGui.text,
                  ),

                  loaiXe: loaiXe,

                  idnt:
                  widget.nguoiThue.idnt,
                );

                if(widget.onSave != null) {

                  widget.onSave!(xe);
                }

                Navigator.pop(context);
              },

              style:
              ElevatedButton.styleFrom(

                elevation: 0,

                backgroundColor:
                const Color(
                  0xff2D7A3A,
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),

              child: const Text(

                "Lưu phương tiện",

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemLoaiXe({
    required String title,
    required int value,
    required IconData icon,
  }) {

    final isSelected =
        loaiXe == value;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {

            loaiXe = value;
          });
        },

        child: AnimatedContainer(

          duration:
          const Duration(
            milliseconds: 180,
          ),

          height: 50,

          decoration: BoxDecoration(

            color:
            isSelected
                ? const Color(
              0xffE8F5EA,
            )
                : Colors.white,

            borderRadius:
            BorderRadius.circular(
              16,
            ),

            border: Border.all(

              color:
              isSelected
                  ? const Color(
                0xff2D7A3A,
              )
                  : const Color(
                0xffEAEAEA,
              ),
            ),
          ),

          child: Row(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(

                icon,

                size: 18,

                color:
                isSelected
                    ? const Color(
                  0xff2D7A3A,
                )
                    : const Color(
                  0xff9E9E9E,
                ),
              ),

              const SizedBox(width: 6),

              Text(

                title,

                style: TextStyle(

                  fontSize: 13,

                  fontWeight:
                  FontWeight.w600,

                  color:
                  isSelected
                      ? const Color(
                    0xff2D7A3A,
                  )
                      : const Color(
                    0xff7A7A7A,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),

      child: Text(

        text,

        style: const TextStyle(
          fontSize: 13,
          fontWeight:
          FontWeight.w600,
          color:
          Color(0xff1C1C1E),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController
    controller,
    String? hint,
  }) {

    return SizedBox(

      height: 56,

      child: TextField(

        controller: controller,

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            fontSize: 14,
            color:
            Color(0xff9E9E9E),
          ),

          filled: true,

          fillColor:
          const Color(
            0xffF8F8F8,
          ),

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
              16,
            ),

            borderSide:
            const BorderSide(
              color:
              Color(0xffEAEAEA),
            ),
          ),

          enabledBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
              16,
            ),

            borderSide:
            const BorderSide(
              color:
              Color(0xffEAEAEA),
            ),
          ),

          focusedBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(
              16,
            ),

            borderSide:
            const BorderSide(
              color:
              Color(0xff2D7A3A),
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}