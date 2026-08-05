import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhong extends StatelessWidget {
  final Phong phong;
  final LoaiPhong loaiPhong;
  final int soNguoiHienTai;
  final Function()? onTap;

  const ItemPhong({
    super.key,
    required this.phong,
    required this.loaiPhong,
    this.soNguoiHienTai = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String textTrangThai = "Đang thuê";
    Color bgTrangThai = const Color(0xffFFF1E1);
    Color textColorTrangThai = const Color(0xffFF8A00);

    if (phong.trangThai == 0) {
      textTrangThai = "Phòng trống";
      bgTrangThai = const Color(0xffE8F7EC);
      textColorTrangThai = const Color(0xff2D7A3A);
    } else if (phong.trangThai == 1) {
      textTrangThai = "Đang thuê";
      bgTrangThai = const Color(0xffFFF1E1);
      textColorTrangThai = const Color(0xffFF8A00);
    } else if (phong.trangThai == 2) {
      textTrangThai = "Đang sửa";
      bgTrangThai = const Color(0xffFFEAEA);
      textColorTrangThai = Colors.red;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Cho phép co giãn theo chiều ngang màn hình
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(
          14,
        ), // Padding đều 4 phía giúp thoáng layout
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffECECEC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// BOX P101
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF3EB),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    "P${phong.tenPhong}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2D7A3A),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TÊN PHÒNG
                      Text(
                        "Phòng ${phong.tenPhong}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff111111),
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "${loaiPhong.tenLoaiPhong} · ${loaiPhong.dienTich.toInt()} m²",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xff9A9A9A),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgTrangThai,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    textTrangThai,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColorTrangThai,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12), // Khoảng cách giữa phần top và bottom

            Wrap(
              spacing: 14, // Khoảng cách ngang giữa các item
              runSpacing: 6, // Khoảng cách dọc nếu bị rớt xuống dòng mới
              children: [
                // GIÁ
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      formatMoney(loaiPhong.giaTien),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff444444),
                      ),
                    ),
                  ],
                ),

                //NGƯỜI
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 13,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      phong.trangThai == 1
                          ? "$soNguoiHienTai/${loaiPhong.soNguoiToiDa} người"
                          : "Tối đa ${loaiPhong.soNguoiToiDa} người",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff444444),
                      ),
                    ),
                  ],
                ),

                //MÁY LẠNH
                if (loaiPhong.isMayLanh)
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                          fontWeight: FontWeight.w600,
                          color: Color(0xff444444),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
