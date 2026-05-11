import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

class ItemNguoiOGhep extends StatelessWidget {
  final NguoiThuePhong nguoiThue;

  final Function()? onTap;

  const ItemNguoiOGhep({
    super.key,
    required this.nguoiThue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: const Color(0xffFAFAFA),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [

            /// AVATAR
            Container(
              width: 42,
              height: 42,

              decoration: const BoxDecoration(
                color: Color(0xffEEE5FF),
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,

              child: Text(
                _vietTat(
                  nguoiThue.nguoiThue.hoTen ?? "",
                ),

                style: const TextStyle(
                  color: Color(0xff7C4DFF),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// INFO
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// TÊN
                  Text(
                    nguoiThue.nguoiThue.hoTen ?? "",

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C1C1E),
                    ),
                  ),

                  const SizedBox(height: 3),

                  /// SDT + CCCD
                  Text(
                    "${nguoiThue.nguoiThue.sdt} · CCCD: ${nguoiThue.nguoiThue.cccd}",

                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  String _vietTat(String name) {
    List<String> arr = name.trim().split(" ");

    if (arr.length >= 2) {
      return "${arr[0][0]}${arr[1][0]}"
          .toUpperCase();
    }

    return arr[0][0].toUpperCase();
  }
}