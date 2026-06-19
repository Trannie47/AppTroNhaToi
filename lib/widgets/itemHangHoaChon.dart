import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemHangHoaChon extends StatelessWidget {
  final HangHoa hangHoa;
  final int soLuong;
  final VoidCallback? onTang;
  final VoidCallback? onGiam;
  final ValueChanged<int>? onChanged;

  const ItemHangHoaChon({
    super.key,
    required this.hangHoa,
    required this.soLuong,
    this.onTang,
    this.onGiam,
    this.onChanged,
  });

  String formatTien(double tien) {
    return tien
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          /// Tên + giá
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hangHoa.tenHangHoa ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${formatTien(hangHoa.giaBan ?? 0)}đ/${hangHoa.donViTinh}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),

          /// -
          if (onGiam != null) ...[
            GestureDetector(
              onTap: onGiam,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF0F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.remove, color: Colors.red, size: 18),
              ),
            ),
          ] else
            const SizedBox(width: 28),

          const SizedBox(width: 10),

          /// số lượng
          SizedBox(
            width: 50,
            height: 36,
            child: TextFormField(
              key: ValueKey(soLuong),
              initialValue: soLuong.toString(),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: onChanged != null,
              onChanged: (value) {
                onChanged?.call(int.tryParse(value) ?? soLuong);
              },
            ),
          ),

          const SizedBox(width: 10),

          /// +
          if (onTang != null) ...[
            GestureDetector(
              onTap: onTang,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xffEAF5EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xff2D7A3A),
                  size: 18,
                ),
              ),
            ),
          ] else
            const SizedBox(width: 28),
        ],
      ),
    );
  }
}
