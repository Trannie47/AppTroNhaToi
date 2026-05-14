import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhuongTien extends StatelessWidget {
  final PhuongTien phuongTien;
  final VoidCallback? delete;

  const ItemPhuongTien({
    super.key,
    required this.phuongTien,
    this.delete,
  });

  @override
  Widget build(BuildContext context) {
    bool coBienSo = phuongTien.bienSo?.trim().isNotEmpty ?? false;

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              /// ICON
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: const Color(0xffEEF5EF),
                  borderRadius: BorderRadius.circular(12),
                ),

                alignment: Alignment.center,

                child: Icon(
                  phuongTien.loaiXe == 1
                      ? Icons.directions_car_rounded
                      : phuongTien.loaiXe == 2
                      ? Icons.directions_bike_rounded
                      : Icons.radio_button_checked_rounded,

                  size: 22,

                  color: const Color(0xff5D8E63),
                ),
              ),

              const SizedBox(width: 12),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      phuongTien.hangXe ?? "",

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1C1C1E),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      coBienSo
                          ? "${phuongTien.bienSo} · ${phuongTien.mauSac ?? ""}"
                          : "Không BKS · ${phuongTien.mauSac ?? ""}",

                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xff8E8E93),
                      ),
                    ),
                  ],
                ),
              ),

              /// PRICE
              Text(
                "${formatMoney(phuongTien.giaGui ?? 0)}/tháng",

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff2D7A3A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          if (delete != null)... {
          Row(
                children: [
                  Text(
                    phuongTien.loaiXe == 1
                        ? "Loại: Xe máy"
                        : phuongTien.loaiXe == 2
                        ? "Loại: Xe đạp điện"
                        : "Loại: Khác",

                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xffA1A1A1),
                    ),
                  ),

                  const Spacer(),


                    GestureDetector(
                      onTap: delete,

                      child: const Text(
                        "Xóa xe",

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              )
          }
        ],
      
          
      ),
    );
  }
}