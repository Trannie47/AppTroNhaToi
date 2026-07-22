import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';
import 'package:flutter/material.dart';

import '../core/utils/currency_formatter.dart';

class ItemCongNo extends StatelessWidget {
  final ThuCongNoFormModel congNo;

  const ItemCongNo({super.key, required this.congNo});

  @override
  Widget build(BuildContext context) {
    final ten = congNo.nguoiThue.hoTen ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Text(
              ten.isNotEmpty ? ten.substring(0, ten.length >= 2 ? 2 : 1) : "?",
              style: const TextStyle(color: Colors.green),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ten.isEmpty ? "Chưa có tên" : ten,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            formatMoneyShort(congNo.tongCongNoTapHoa),
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
