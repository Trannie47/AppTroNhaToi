import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemLichSuMuaThietBi extends StatelessWidget {
  final LichSuMuaThietBi lichSu;

  final VoidCallback onClick;

  final VoidCallback? onRepair;

  const ItemLichSuMuaThietBi({
    super.key,
    required this.lichSu,
    required this.onClick,
    this.onRepair,
  });

  bool get _duocSua {
    if (lichSu.ngayMua == null) return false;

    final now = DateTime.now();

    return lichSu.ngayMua!.month == now.month &&
        lichSu.ngayMua!.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(18),
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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xff2D7A3A),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("dd/MM/yyyy").format(lichSu.ngayMua!),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "SL: ${lichSu.soLuong} · Đơn giá ${NumberFormat("#,###").format(lichSu.donGia)}đ",
                    style: const TextStyle(
                      color: Color(0xff8B8B8B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            if (onRepair != null)
              IconButton(
                tooltip: "Sửa",
                icon: const Icon(Icons.edit_outlined, color: Color(0xff2D7A3A)),
                onPressed: () {
                  if (!_duocSua) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Chỉ được sửa lịch sử mua trong tháng hiện tại.",
                        ),
                      ),
                    );
                    return;
                  }

                  onRepair!.call();
                },
              ),

            const Icon(Icons.chevron_right, color: Color(0xffD2D2D2)),
          ],
        ),
      ),
    );
  }
}
