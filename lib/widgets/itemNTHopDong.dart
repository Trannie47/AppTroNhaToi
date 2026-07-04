import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:flutter/material.dart';

class ItemNTHopDong extends StatelessWidget {
  final HopDongDTO hopDong;
  final VoidCallback? onTap;

  const ItemNTHopDong({
    super.key,
    required this.hopDong,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xffE8EEF9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                vietTat(hopDong.nguoithue.hoTen),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff3467EB),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    hopDong.nguoithue.hoTen,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Mã HĐ: ${hopDong.hopDongID}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Phòng ${hopDong.phongID}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff2E7D32),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 1,
                        height: 14,
                        color: const Color(0xffD9D9D9),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "${hopDong.giaPhongThucTe?.toStringAsFixed(0)}đ/tháng",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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