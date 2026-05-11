import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/utils/string_formatter.dart';
import 'package:flutter/material.dart';

class ItemNguoiThue extends StatelessWidget {
  final NguoiThue nguoiThue;
  final Phong? phong;
  final bool isSelected;
  final Function()? onTap;

  const ItemNguoiThue({
    super.key,
    required this.nguoiThue,
    this.isSelected = false,
    this.onTap,
    this.phong,
  });

  @override
  Widget build(BuildContext context) {
    /// KIỂM TRA VAI TRÒ
    bool isOGhep =
        nguoiThue.ghiChu != null && nguoiThue.ghiChu!.trim().isNotEmpty;

    String vaiTro = isOGhep ? "Ở ghép" : "Chính";

    /// MÀU AVATAR
    Color avatarBg = const Color(0xffDDE8FF);
    Color avatarText = const Color(0xff2F61E7);

    /// MÀU STATUS
    Color statusBg = const Color(0xffE7F5EA);
    Color statusText = const Color(0xff2D8B47);

    /// NẾU Ở GHÉP
    if (isOGhep) {
      avatarBg = const Color(0xffEEE5FF);
      avatarText = const Color(0xff7C4DFF);

      statusBg = const Color(0xffF2F2F2);
      statusText = Colors.grey.shade700;
    }

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: phong != null
            ? EdgeInsets.only(bottom: 10)
            : EdgeInsets.symmetric(vertical: 10),
        height: phong != null ? 87 : 60,
        padding: EdgeInsets.symmetric(
          horizontal: phong != null ? 16 : 4,
          vertical: 6,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: phong != null
              ? Border.all(
                  color: isSelected
                      ? const Color(0xff2F61E7)
                      : const Color(0xffEAEAEA),
                  width: 1,
                )
              : null,
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

                  const SizedBox(height: 3),

                  /// SDT + CCCD
                  Text(
                    "${nguoiThue.sdt} · CCCD: ${nguoiThue.cccd}",

                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9B9B9B),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// PHÒNG + VAI TRÒ
                  //Nếu đầu vào phòng thì hiển thị không có thì không hiện
                  if (phong != null) ...{
                    Row(
                      children: [
                        Text(
                          phong?.tenPhong ?? "",

                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff555555),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),

                          width: 1,
                          height: 14,

                          color: const Color(0xffDDDDDD),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: Text(
                            vaiTro,

                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ),

            /// ICON
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade300,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
