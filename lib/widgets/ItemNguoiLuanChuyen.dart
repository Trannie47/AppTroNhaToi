import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ItemNguoiLuanChuyenModel.dart';
import 'package:flutter/material.dart';

class ItemNguoiLuanChuyen extends StatelessWidget {
  final ItemNguoiLuanChuyenModel item;
  final bool isSelected;
  final Function()? onTap;

  const ItemNguoiLuanChuyen({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color mauChinh = item.isNguoiThueChinh
        ? const Color(0xff2F61E7)
        : const Color(0xff2D7A3A);
    final Color mauNen = item.isNguoiThueChinh
        ? const Color(0xffDDE8FF)
        : const Color(0xffE8F3EA);

    final phieu = item.phieuLuanChuyen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? mauChinh : const Color(0xffF5F5F5),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: mauNen, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                vietTat(item.hoTen ?? ""),
                style: TextStyle(
                  color: mauChinh,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.hoTen ?? "Chưa có tên",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff222222),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: mauNen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.isNguoiThueChinh ? "Đại diện" : "Ở ghép",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: mauChinh,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.sdt ?? "---",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff9B9B9B),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.swap_horiz_rounded,
                        size: 14,
                        color: Color(0xff9B9B9B),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${phieu.phongMoi?.tenPhong ?? "--"}  ·  ${formatDate(phieu.tuNgay)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff9B9B9B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (onTap != null)
              const Padding(
                padding: EdgeInsets.only(top: 2, left: 4),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xffC7C7CC),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
