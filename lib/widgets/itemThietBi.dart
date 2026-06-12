import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemThietBi extends StatelessWidget {
  final ThietBi thietBi;

  const ItemThietBi({
    super.key,
    required this.thietBi,
  });

  @override
  Widget build(BuildContext context) {
    final bool dangSua =
        thietBi.trangThai?.toLowerCase() == "đang sửa";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: dangSua
            ? Border.all(
          color: const Color(0xffFFD6D6),
        )
            : null,
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: dangSua
                  ? const Color(0xffFFF2F2)
                  : const Color(0xffF5F5F5),

              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              _getIcon(),
              color: dangSua
                  ? Colors.red
                  : const Color(0xff2D7A3A),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  thietBi.tenThietBi ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "${thietBi.loai} · Mua ${DateFormat("MM/yyyy").format(thietBi.ngayMua!)}",
                  style: const TextStyle(
                    color: Color(0xff9A9A9A),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      thietBi.trangThai ?? "",
                      style: TextStyle(
                        color: dangSua
                            ? Colors.red
                            : const Color(0xff2D7A3A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "|",
                      style: TextStyle(
                        color: Color(0xffC8C8C8),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "${NumberFormat("#,###").format(thietBi.giaTri)}đ",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff4F4F4F),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Color(0xffD2D2D2),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (thietBi.loai?.toLowerCase()) {

      case "điều hòa":
        return Icons.ac_unit;

      case "tủ lạnh":
        return Icons.kitchen_outlined;

      case "máy giặt":
        return Icons.local_laundry_service_outlined;

      case "tivi":
        return Icons.tv_outlined;

      case "quạt":
        return Icons.mode_fan_off_outlined;

      case "lò vi sóng":
        return Icons.microwave_outlined;

      case "bình nóng lạnh":
        return Icons.hot_tub_outlined;

      case "bếp điện":
        return Icons.soup_kitchen_outlined;

      case "bếp từ":
        return Icons.soup_kitchen_outlined;

      case "nồi cơm điện":
        return Icons.rice_bowl_outlined;

      case "máy hút mùi":
        return Icons.air_outlined;

      case "đèn":
        return Icons.lightbulb_outline;

      case "camera":
        return Icons.videocam_outlined;

      case "router wifi":
        return Icons.router_outlined;

      case "máy bơm":
        return Icons.water_drop_outlined;

      case "máy nước nóng":
        return Icons.shower_outlined;

      case "khóa cửa điện tử":
        return Icons.lock_outline;

      default:
        return Icons.devices_other_outlined;
    }
  }
}