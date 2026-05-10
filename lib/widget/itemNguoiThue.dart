import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:flutter/material.dart';

class ItemNguoiThue extends StatelessWidget {
  final NguoiThuePhong nguoiThue;

  final bool isSelected;
  final VoidCallback? onTap;

  const ItemNguoiThue({
    super.key,
    required this.nguoiThue,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    /// KIỂM TRA VAI TRÒ
    bool isOGhep =
        nguoiThue.nguoiThue.ghiChu != null &&
        nguoiThue.nguoiThue.ghiChu!.trim().isNotEmpty;

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
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? const Color(0xff2F61E7)
                : const Color(0xffEAEAEA),
            width: 1,
          ),
        ),

        child: Row(
          children: [
            /// AVATAR
            Container(
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),

              alignment: Alignment.center,

              child: Text(
                _vietTat(nguoiThue.nguoiThue.hoTen ?? ""),

                style: TextStyle(
                  color: avatarText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(width: 14),

            /// THÔNG TIN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HỌ TÊN
                  Text(
                    nguoiThue.nguoiThue.hoTen ?? "",

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff222222),
                    ),
                  ),

                  const SizedBox(height: 3),

                  /// SDT + CCCD
                  Text(
                    "${nguoiThue.nguoiThue.sdt} · CCCD: ${nguoiThue.nguoiThue.cccd}",

                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff9B9B9B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// PHÒNG + VAI TRÒ
                  Row(
                    children: [
                      Text(
                        nguoiThue.phong?.tenPhong ?? "",

                        style: const TextStyle(
                          fontSize: 14,
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
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: statusText,
                          ),
                        ),
                      ),
                    ],
                  ),
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

  String _vietTat(String name) {
    List<String> arr = name.trim().split(" ");

    if (arr.length >= 2) {
      return "${arr[0][0]}${arr[1][0]}".toUpperCase();
    }

    return arr[0][0].toUpperCase();
  }
}
