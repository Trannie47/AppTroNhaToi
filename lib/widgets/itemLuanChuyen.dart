import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/chi_tiet_luan_chuyen.dart';
import 'package:flutter/material.dart';

class ItemLuanChuyen extends StatelessWidget {
  final ChiTietLuanChuyen item;

  final VoidCallback? edit;

  final VoidCallback? delete;

  const ItemLuanChuyen({
    super.key,
    required this.item,
    this.edit,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xffEEEEEE),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.swap_horiz_rounded,
                  color: _statusColor(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.hopDong?.hopDongID ?? "Chưa có hợp đồng",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Phòng hiện tại: ${item.hopDong?.phong?.tenPhong ?? "--"}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _statusText(),
                  style: TextStyle(
                    color: _statusColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(height: 1),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.home_work_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  "Phòng chuyển đến: ${item.phongMoi?.tenPhong ?? "--"}",
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  formatDate(item.ngayLuanChuyen),
                ),
              ),
            ],
          ),

          if ((item.ghiChu ?? "").isNotEmpty) ...[
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.ghiChu!,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ],

          if (edit != null || delete != null) ...[
            const SizedBox(height: 16),

            Row(
              children: [
                const Spacer(),

                if (edit != null)
                  InkWell(
                    onTap: edit,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Sửa",
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (edit != null && delete != null)
                  const SizedBox(width: 18),

                if (delete != null)
                  InkWell(
                    onTap: delete,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Xóa",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _statusText() {
    switch (item.trangThaiLuanChuyen) {
      case 0:
        return "Chưa chuyển";
      case 1:
        return "Đang chuyển";
      case 2:
        return "Hoàn tất";
      default:
        return "Không xác định";
    }
  }

  Color _statusColor() {
    switch (item.trangThaiLuanChuyen) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return const Color(0xff2D7A3A);
      default:
        return Colors.grey;
    }
  }

  Color _backgroundColor() {
    switch (item.trangThaiLuanChuyen) {
      case 0:
        return const Color(0xffFFF5E9);
      case 1:
        return const Color(0xffEEF6FF);
      case 2:
        return const Color(0xffEDF8F0);
      default:
        return const Color(0xffF4F4F4);
    }
  }
}