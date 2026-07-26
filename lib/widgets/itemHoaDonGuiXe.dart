import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemHoaDonGuiXe extends StatelessWidget {
  final HoaDonGuiXe hoaDon;
  final PhuongTien? phuongTien;

  const ItemHoaDonGuiXe({
    super.key,
    required this.hoaDon,
    this.phuongTien,
  });

  @override
  Widget build(BuildContext context) {
    int trangThai = hoaDon.trangThai ?? 0;

    String textTrangThai = "Chưa thu";
    Color mauText = const Color(0xffF08A24);
    Color mauNen = const Color(0xffFFF1E5);

    // Phân chia 2 trạng thái: Đã thu (1) và Chưa thu (0)
    if (trangThai == 1) {
      textTrangThai = "Đã thu";
      mauText = const Color(0xff2D7A3A);
      mauNen = const Color(0xffE7F7EC);
    } else {
      textTrangThai = "Chưa thu";
      mauText = const Color(0xffF08A24);
      mauNen = const Color(0xffFFF1E5);
    }

    // Lấy số tiền từ hóa đơn, nếu trống thì lấy giá gửi của phương tiện
    final double soTien = double.tryParse((hoaDon.soTien ?? phuongTien?.giaGui ?? 0).toString()) ?? 0;    final String tenXe = phuongTien?.hangXe ?? "Xe máy";
    final String bienSo = phuongTien?.bienSo ?? "";
    final String thangNam = hoaDon.thangNam ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bienSo.isNotEmpty ? "$tenXe ($bienSo)" : tenXe,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1C1E),
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      "Tháng $thangNam",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff8E8E93),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      " • ",
                      style: TextStyle(color: Color(0xffC7C7CC)),
                    ),
                    Text(
                      "${formatMoney(soTien)} đ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2D7A3A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: mauNen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              textTrangThai,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: mauText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}