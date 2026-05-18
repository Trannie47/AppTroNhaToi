import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhong extends StatelessWidget {

  final Phong phong;

  final LoaiPhong loaiPhong;

  final Function()? onTap;

  const ItemPhong({
    super.key,
    required this.phong,
    required this.loaiPhong,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String textTrangThai = "Đang thuê";

    Color bgTrangThai =
    const Color(0xffFFF1E1);

    Color textColorTrangThai =
    const Color(0xffFF8A00);

    if (phong.trangThai == 0) {

      textTrangThai = "Phòng trống";

      bgTrangThai =
      const Color(0xffE8F7EC);

      textColorTrangThai =
      const Color(0xff2D7A3A);

    } else if (phong.trangThai == 2) {

      textTrangThai = "Đã hủy";

      bgTrangThai =
      const Color(0xffFFEAEA);

      textColorTrangThai =
          Colors.red;

    } else if (phong.trangThai == 3) {

      textTrangThai = "Đang sửa";

      bgTrangThai =
      const Color(0xffECECEC);

      textColorTrangThai =
          Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 361,

        height: 112,

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          border: Border.all(
            color: const Color(
              0xffECECEC,
            ),
          ),
        ),

        child: Column(
          children: [

            /// TOP
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// BOX P101
                Container(
                  width: 46,
                  height: 46,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color:
                    const Color(0xffEAF3EB),

                    borderRadius:
                    BorderRadius.circular(
                      13,
                    ),
                  ),

                  child: Text(
                    phong.tenPhong,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w700,

                      color:
                      Color(0xff2D7A3A),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// TÊN PHÒNG
                      Text(
                        "Phòng ${phong.tenPhong.replaceAll("P", "")}",

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,

                          color:
                          Color(0xff111111),
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// LOẠI PHÒNG
                      Text(
                        "${loaiPhong.tenLoaiPhong} · ${loaiPhong.dienTich.toInt()} m²",

                        style: const TextStyle(
                          fontSize: 13,

                          color:
                          Color(0xff9A9A9A),
                        ),
                      ),
                    ],
                  ),
                ),

                /// STATUS
                Container(
                  width: 72.55,

                  height: 21,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: bgTrangThai,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    textTrangThai,

                    style: TextStyle(
                      fontSize: 11,

                      fontWeight:
                      FontWeight.w600,

                      color: textColorTrangThai,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// BOTTOM
            SizedBox(
              width: 361,

              height: 28,

              child: Row(
                children: [

                  /// GIÁ
                  Row(
                    children: [

                      Icon(
                        Icons.attach_money,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 2),

                      Text(
                        formatMoney(
                          loaiPhong.giaTien,
                        ),

                        style: const TextStyle(
                          fontSize: 11,

                          fontWeight:
                          FontWeight.w600,

                          color:
                          Color(0xff444444),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// NGƯỜI
                  Row(
                    children: [

                      Icon(
                        Icons.person_outline,
                        size: 13,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "Tối đa ${loaiPhong.soNguoiToiDa} người",

                        style: const TextStyle(
                          fontSize: 11,

                          fontWeight:
                          FontWeight.w600,

                          color:
                          Color(0xff444444),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  /// MÁY LẠNH
                  if (loaiPhong.isMayLanh)
                    Row(
                      children: [

                        Icon(
                          Icons.ac_unit,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          "Máy lạnh",

                          style: TextStyle(
                            fontSize: 11,

                            fontWeight:
                            FontWeight.w600,

                            color:
                            Color(0xff444444),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}