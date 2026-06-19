import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/hang_hoa.dart';
import 'package:flutter/material.dart';

class ItemHangHoa extends StatelessWidget {
  final HangHoa hangHoa;
  final VoidCallback? onSua;
  final VoidCallback? onXoa;
  final VoidCallback? onTap;

  const ItemHangHoa({
    super.key,
    required this.hangHoa,
    this.onSua,
    this.onXoa,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              /// Icon hàng hóa
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xffEDF5EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.grid_view_rounded,
                  color: Color(0xff2D7A3A),
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              /// Tên hàng hóa + giá
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hangHoa.tenHangHoa ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${formatMoney(hangHoa.giaBan)}/${hangHoa.donViTinh ?? ""}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// Nút sửa
              if (onSua != null) ...[
                InkWell(
                  onTap: onSua,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF5EE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xff2D7A3A),
                    ),
                  ),
                ),
              ] else
                const SizedBox(width: 46),

              const SizedBox(width: 10),

              /// Nút xóa
              if (onXoa != null) ...[
                InkWell(
                  onTap: onXoa,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF0F0),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),
              ] else if (onTap != null) ...[
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ] else
                SizedBox(width: 46),
            ],
          ),
        ),
      ),
    );
  }
}
