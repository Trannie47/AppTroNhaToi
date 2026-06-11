import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Cố định khoảng cách giữa các item cho đều và đẹp
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Đổ bóng nhẹ cho card nhìn nổi bật và hiện đại hơn
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          // Nếu item được chọn thì lên viền xanh, không thì viền xám nhạt tinh tế
          border: Border.all(
            color: isSelected
                ? const Color(0xff2F61E7)
                : const Color(0xffF5F5F5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xffDDE8FF),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                vietTat(nguoiThue.hoTen ?? ""),
                style: const TextStyle(
                  color: Color(0xff2F61E7),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hiển thị Họ Tên
                  Text(
                    nguoiThue.hoTen ?? "Chưa có tên",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Hiển thị Số điện thoại và CCCD
                  Text(
                    "${nguoiThue.sdt ?? "---"} · CCCD: ${nguoiThue.cccd ?? "---"}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9B9B9B),
                    ),
                  ),
                ],
              ),
            ),

            // Mũi tên dẫn đường sang màn hình chi tiết
            if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xffC7C7CC),
              ),
          ],
        ),
      ),
    );
  }
}