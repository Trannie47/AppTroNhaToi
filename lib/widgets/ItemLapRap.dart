import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:flutter/material.dart';

class ItemLapRap extends StatelessWidget {
  final LapRap lapRap;
  final int trangThai; // 0: bình thường, 1: đang sửa, 2: hỏng

  final VoidCallback? onClick;
  final VoidCallback? edit;
  final VoidCallback? delete;

  const ItemLapRap({
    super.key,
    required this.lapRap,
    this.trangThai = 0,
    this.onClick,
    this.edit,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffEEEEEE)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _backgroundColor(),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(_icon(), color: _statusColor(), size: 25),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${formatDate(lapRap.ngayLap)} - #${lapRap.id ?? ''}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1C1C1E),
                        ),
                      ),

                      // const SizedBox(height: 4),

                      // Text(
                      //   lapRap.ghiChu ?? "",
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Color(0xff8F8F8F),
                      //   ),
                      // ),
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
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            if ((lapRap.ghiChu ?? "").isNotEmpty) ...[
              const SizedBox(height: 12),

              Container(height: 1, color: const Color(0xffF2F2F2)),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lapRap.ghiChu!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6A6A6A),
                  ),
                ),
              ),
            ],

            if (edit != null || delete != null) ...[
              const SizedBox(height: 14),

              Row(
                children: [
                  const Spacer(),

                  if (edit != null)
                    GestureDetector(
                      onTap: edit,
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xffF08A24),
                      ),
                    ),

                  if (edit != null && delete != null) const SizedBox(width: 16),

                  if (delete != null)
                    GestureDetector(
                      onTap: delete,
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _icon() {
    switch (trangThai) {
      case 0:
        return Icons.check_circle_outline_rounded;
      case 1:
        return Icons.build_circle_outlined;
      case 2:
        return Icons.report_problem_outlined;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _statusText() {
    switch (trangThai) {
      case 0:
        return "Bình thường";
      case 1:
        return "Đang sửa";
      case 2:
        return "Hỏng";
      default:
        return "Không xác định";
    }
  }

  Color _statusColor() {
    switch (trangThai) {
      case 0:
        return const Color(0xff2D7A3A);
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _backgroundColor() {
    switch (trangThai) {
      case 0:
        return const Color(0xffEDF8F0);
      case 1:
        return const Color(0xffEEF6FF);
      case 2:
        return const Color(0xffFDF2F2);
      default:
        return const Color(0xffF4F4F4);
    }
  }
}
