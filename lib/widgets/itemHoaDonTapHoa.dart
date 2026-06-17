import 'package:AppTroNhaToi/models/hoa_don_tap_hoa.dart';
import 'package:flutter/material.dart';

class ItemHoaDonTapHoa extends StatelessWidget {
  final HoaDonTapHoa hoaDon;
  final VoidCallback? onSua;
  final VoidCallback? onXoa;

  const ItemHoaDonTapHoa({
    super.key,
    required this.hoaDon,
    this.onSua,
    this.onXoa,
  });

  String formatTien(double tien) {
    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          /// Nội dung bên trái
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Mã hóa đơn
                Text(
                  "${hoaDon.maHoaDon}",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Lê Văn Tèo - ${formatTien(hoaDon.tongTien ?? 0)}đ",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Chưa thu",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// Nút sửa
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffEAF5EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onSua,
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xff2D7A3A),
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// Nút xóa
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffFFF0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onXoa,
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}