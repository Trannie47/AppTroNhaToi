import 'package:AppTroNhaToi/models/thong_bao.dart';
import 'package:flutter/material.dart';

class ItemThongBao extends StatelessWidget {
  final ThongBao thongBao;

  const ItemThongBao({super.key, required this.thongBao});

  Color _getColor() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thongBaoDate = DateTime(
      thongBao.date.year,
      thongBao.date.month,
      thongBao.date.day,
    );

    if (thongBaoDate.isAfter(today)) {
      return Colors.green; // Tương lai
    } else if (thongBaoDate.isAtSameMomentAs(today)) {
      return Colors.orange; // Hôm nay
    } else {
      return Colors.red; // Quá khứ
    }
  }

  String _getStatus() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thongBaoDate = DateTime(
      thongBao.date.year,
      thongBao.date.month,
      thongBao.date.day,
    );

    if (thongBaoDate.isAfter(today)) {
      return "Sắp đến hạn";
    } else if (thongBaoDate.isAtSameMomentAs(today)) {
      return "Ghi ngay";
    } else {
      return "Khẩn";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final status = _getStatus();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description, color: color),
          ),

          const SizedBox(width: 10),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thongBao.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(thongBao.subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          // BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
