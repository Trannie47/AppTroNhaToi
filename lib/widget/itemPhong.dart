import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhong extends StatelessWidget {
  final Phong phong;
  final LoaiPhong loaiPhong;
  final VoidCallback? onTap;

  const ItemPhong({
    super.key,
    required this.phong,
    required this.loaiPhong,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String statusText = "";
    Color statusColor = Colors.green;
    Color statusBg = const Color(0xFFEAF5ED);

    switch (phong.trangThai) {
      // Còn trống
      case 0:
        statusText = "Còn trống";
        statusColor = const Color(0xFF2D7A3A);
        statusBg = const Color(0xFFEAF5ED);
        break;

      // Đang thuê
      case 1:
        statusText = "Đang thuê";
        statusColor = const Color(0xFFE68600);
        statusBg = const Color(0xFFFFF3E8);
        break;

      // Đang sửa chữa
      case 2:
        statusText = "Sửa chữa";
        statusColor = Colors.red;
        statusBg = const Color(0xFFFFECEC);
        break;
    }

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Column(
          children: [
            /// HEADER
            Row(
              children: [
                /// ICON
                Container(
                  width: 62,
                  height: 62,

                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5ED),
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Center(
                    child: Text(
                      phong.tenPhong,
                      style: const TextStyle(
                        color: Color(0xFF2D7A3A),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                /// INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phòng ${phong.tenPhong}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${loaiPhong.tenLoaiPhong} · ${loaiPhong.dienTich.toInt()} m²",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                /// STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Divider(color: Colors.grey.shade200, height: 1),

            const SizedBox(height: 14),

            /// FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// GIÁ
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Colors.grey,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,

                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),

                            children: [
                              const TextSpan(text: "Giá: "),

                              TextSpan(
                                text: "${formatMoney(loaiPhong.giaTien)}/tháng",

                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// NGƯỜI
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,

                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),

                            children: [
                              const TextSpan(text: "Tối đa "),

                              TextSpan(
                                text: "${loaiPhong.soNguoiToiDa} người",

                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// MÁY LẠNH
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.ac_unit,
                        color: loaiPhong.isMayLanh
                            ? Colors.black
                            : Colors.grey.shade400,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          loaiPhong.isMayLanh ? "Máy lạnh" : "Không ML",

                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: loaiPhong.isMayLanh
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
