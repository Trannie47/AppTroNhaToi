import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/utils/string_formatter.dart';
import 'package:flutter/material.dart';

class ItemNguoiThue extends StatelessWidget {
  final NguoiThue nguoiThue;

  final bool isSelected;

  final Function()? onTap;

  const ItemNguoiThue({
    super.key,
    required this.nguoiThue,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    /// KIỂM TRA Ở GHÉP

    /// MÀU AVATAR
    Color avatarBg = const Color(0xffDDE8FF);

    Color avatarText = const Color(0xff2F61E7);

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),

        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: null,
        ),

        child: Row(
          children: [
            /// AVATAR
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,

              child: Text(
                vietTat(nguoiThue.hoTen ?? ""),

                style: TextStyle(
                  color: avatarText,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// THÔNG TIN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  /// HỌ TÊN
                  Text(
                    nguoiThue.hoTen ?? "",

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff222222),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// SDT + CCCD
                  Text(
                    // "${nguoiThue.sdt} · CCCD: ${nguoiThue.cccd}", --- IGNORE ---
                    // nếu có cả 2 mới đặt dấu . ở giữa nếu chỉ có 1 trong 2 thì không cần dấu .
                    "${nguoiThue.sdt ?? ""}${nguoiThue.cccd != null && nguoiThue.sdt != null ? " · " : ""}CCCD: ${nguoiThue.cccd ?? ""}",

                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9B9B9B),
                    ),
                  ),
                ],
              ),
            ),

            /// ICON
            onTap != null
                ? Icon(Icons.chevron_right_rounded, color: Color(0xffC7C7CC))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
