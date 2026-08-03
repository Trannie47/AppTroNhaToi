//Tạo widgets item SelectBox cho Loại Phòng
import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

Widget itemLoaiPhongSelectBox(LoaiPhong item, bool selected) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFFEAF5ED) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: selected ? const Color(0xFF2D7A3A) : Colors.grey.shade300,
        width: 1.5,
      ),
    ),
    child: Row(
      children: [
        Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? const Color(0xFF2D7A3A) : Colors.grey,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.tenLoaiPhong,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected ? const Color(0xFF2D7A3A) : Colors.black,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "${item.dienTich} m² · ${item.soNguoiToiDa} người",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 8),

              Text(
                item.isMayLanh ? "Có máy lạnh" : "Không máy lạnh",
                style: const TextStyle(
                  color: Color(0xFF2D7A3A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Text(
          formatMoney(item.giaTien),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: selected ? const Color(0xFF2D7A3A) : Colors.black,
          ),
        ),
      ],
    ),
  );
}
