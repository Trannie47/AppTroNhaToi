import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:flutter/material.dart';

import '../core/utils/currency_formatter.dart';

class ItemNTHopDong extends StatelessWidget {
  final HopDongDTO hopDong;
  final VoidCallback? onTap;

  const ItemNTHopDong({super.key, required this.hopDong, this.onTap});

  // Hợp đồng vẫn đang trangThai == 1 (hiệu lực) nhưng ngày hết hạn đã tới
  // hoặc đã qua rồi mà chủ trọ chưa gia hạn/kết thúc -> cảnh báo đỏ.
  bool get _isQuaHan {
    if (hopDong.trangThai != 1) return false;
    return _soNgayConLai <= 0;
  }

  bool get _isSapHetHan {
    if (hopDong.trangThai != 1) return false;
    final soNgayConLai = _soNgayConLai;
    return soNgayConLai > 0 && soNgayConLai <= 30;
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
    final quaHan = _isQuaHan;
    final sapHetHan = _isSapHetHan;
    final ngayConLai = _soNgayConLai;

    // Lấy thông tin tên đại diện và tổng số thành viên trong hợp đồng
    final tenDaiDien = hopDong.nguoithue.hoTen;
    final soLuongThanhVien = 1 + hopDong.nguoiOGhepConHieuLuc.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: quaHan
              ? Border.all(color: const Color(0xFFE53935), width: 1.2)
              : sapHetHan
              ? Border.all(color: const Color(0xFFFFA726), width: 1.2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
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
                vietTat(tenDaiDien),
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
                        tenDaiDien,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff111111),
                        ),
                      ),
                      if (quaHan)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ngayConLai == 0
                                ? "Hết hạn hôm nay"
                                : "Đã quá hạn ${-ngayConLai} ngày",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (sapHetHan)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Còn $ngayConLai ngày",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFD97706),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Mã hợp đồng và huy hiệu số lượng thành viên được làm nổi bật
                  Row(
                    children: [
                      Text(
                        "Mã HĐ: ${hopDong.hopDongID}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 11,
                              color: Color(0xFF1976D2),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "$soLuongThanhVien người",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

            const Icon(Icons.chevron_right_rounded, color: Color(0xffC7C7CC)),
          ],
        ),
      ),
    );
  }
}
