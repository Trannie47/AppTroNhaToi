import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:flutter/material.dart';

class ItemLichSuSuaChua extends StatelessWidget {
  final SuaChua suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;
  final String? tenPhong;
  final VoidCallback? onClick;

  const ItemLichSuSuaChua({
    super.key,
    required this.suaChua,
    this.hoaDonSuaChua,
    this.onClick,
    this.tenPhong,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suaChua.nguyenNhan ??
                        ""
                            "- ${tenPhong ?? ""}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hoaDonSuaChua == null
                        ? "${formatDate(suaChua.ngaySuaChua)} - Đang sửa"
                        : "${formatDate(suaChua.ngaySuaChua)} · Chi phí ${formatMoney(hoaDonSuaChua!.giaTien)}",
                    style: TextStyle(
                      color: hoaDonSuaChua == null ? Colors.red : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            if (onClick != null)
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
