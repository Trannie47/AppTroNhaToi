import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:flutter/material.dart';

class ItemHangHoa extends StatelessWidget {
  final HangHoa hangHoa;
  final String tonKho;
  final VoidCallback onSua;
  final VoidCallback onXoa;

  const ItemHangHoa({
    super.key,
    required this.hangHoa,
    required this.tonKho,
    required this.onSua,
    required this.onXoa,
  });

  String formatTien(double? giaTien) {
    if (giaTien == null) return "0";

    return giaTien
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xffEDF5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xff2D7A3A),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hangHoa.tenHangHoa ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Tồn kho: $tonKho ${hangHoa.donViTinh ?? ""}",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "${formatTien(hangHoa.giaBan)}đ/${hangHoa.donViTinh ?? ""}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onSua,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEDF5EE),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Chỉnh sửa",
                      style: TextStyle(
                        color: Color(0xff2D7A3A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onXoa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFF0F0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Xóa",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}