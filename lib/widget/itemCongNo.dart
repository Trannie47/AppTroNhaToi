import 'package:AppTroNhaToi/models/cong_no.dart';
import 'package:flutter/material.dart';

import '../utils/currency_formatter.dart';

class ItemCongNo extends StatelessWidget {
  final CongNo congNo;

  const ItemCongNo({super.key, required this.congNo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Text(
              congNo.name.substring(0, 2),
              style: const TextStyle(color: Colors.green),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  congNo.name.substring(0, 10),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  congNo.room.substring(0, 20),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            formatMoneyShort(congNo.amount),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
