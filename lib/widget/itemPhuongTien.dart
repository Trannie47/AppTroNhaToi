import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhuongTien extends StatelessWidget {
  final PhuongTien phuongTien;

  const ItemPhuongTien({super.key, required this.phuongTien});

  @override
  Widget build(BuildContext context) {
    bool coBienSo = phuongTien.bienSo?.trim().isNotEmpty ?? false;

    return Row(
      children: [
        /// ICON
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),

          alignment: Alignment.center,

          child: Icon(
            phuongTien.loaiXe == 1
                ? Icons.directions_car_rounded
                : phuongTien.loaiXe == 2
                ? Icons.directions_bike_rounded
                : Icons.radio_button_checked_rounded,

            size: 22,

            color: const Color(0xff7A7A7A),
          ),
        ),

        const SizedBox(width: 14),

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

              const SizedBox(height: 2),

              Text(
                coBienSo
                    ? "${phuongTien.bienSo} · ${phuongTien.mauSac ?? ""}"
                    : "Không BKS · ${phuongTien.mauSac ?? ""}",

                style: const TextStyle(fontSize: 11, color: Color(0xff888888)),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        /// PRICE
        Text(
          formatMoney(phuongTien.giaGui ?? 0),

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xff2D7A3A),
          ),
        ),
      ],
    );
  }
}
