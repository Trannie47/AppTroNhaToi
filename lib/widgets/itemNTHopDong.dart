import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:flutter/material.dart';

import '../core/utils/currency_formatter.dart';

class ItemNTHopDong extends StatelessWidget {
  final HopDongDTO hopDong;
  final VoidCallback? onTap;

  const ItemNTHopDong({
    super.key,
    required this.hopDong,
    this.onTap,
  });

  bool get _isSapHetHan {
    if (hopDong.trangThai != 1) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ngayHetHan = DateTime(
      hopDong.ngayHetHan.year,
      hopDong.ngayHetHan.month,
      hopDong.ngayHetHan.day,
    );

    final soNgayConLai = ngayHetHan.difference(today).inDays;
    return soNgayConLai >= 0 && soNgayConLai <= 30;
  }

  int get _soNgayConLai {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ngayHetHan = DateTime(
      hopDong.ngayHetHan.year,
      hopDong.ngayHetHan.month,
      hopDong.ngayHetHan.day,
    );
    return ngayHetHan.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final sapHetHan = _isSapHetHan;
    final ngayConLai = _soNgayConLai;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: sapHetHan
              ? Border.all(color: const Color(0xFFFFA726), width: 1.2)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                style: const TextStyle(
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
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        hopDong.nguoithue.hoTen,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff111111),
                        ),
                      ),
                      if (sapHetHan)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ngayConLai == 0 ? "Hôm nay hết hạn" : "Còn $ngayConLai ngày",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFD97706),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
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

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
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
                          "Phòng ${hopDong.phong.tenPhong}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff2E7D32),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${formatMoney(hopDong.giaPhongThucTe)}/tháng",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

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