import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemVatTu extends StatelessWidget {
  final String tenVatTu;
  final int tonKho;
  final double giaTien;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemVatTu({
    super.key,
    required this.tenVatTu,
    required this.tonKho,
    required this.giaTien,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE9E9E9)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xffEEF6EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xff4E8A54),
                  size: 18,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenVatTu,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Tồn kho: $tonKho gói",
                      style: const TextStyle(
                        color: Color(0xffA2A2A2),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "${NumberFormat("#,###").format(giaTien)}đ/gói",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onEdit,
                  child: Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xffEEF6EE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Chỉnh sửa",
                        style: TextStyle(
                          color: Color(0xff4E8A54),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onDelete,
                  child: Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Xóa",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
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
