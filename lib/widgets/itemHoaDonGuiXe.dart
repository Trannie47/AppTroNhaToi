import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemHoaDonGuiXe extends StatelessWidget {
  final HoaDonGuiXe hoaDon;
  final PhuongTien phuongTien;

  final Function()? onTap;

  const ItemHoaDonGuiXe({
    super.key,
    required this.hoaDon,
    required this.phuongTien,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    int trangThai = hoaDon.trangThai ?? 0;

    String textTrangThai = "";

    Color mauText = Colors.black;

    Color mauNen = Colors.white;

    switch (trangThai) {
      /// ĐÃ THU
      case 1:
        textTrangThai = "Đã thu";

        mauText = const Color(0xff2D7A3A);

        mauNen = const Color(0xffE7F7EC);

        break;

      /// KHÔNG CÒN Ở
      case 2:
        textTrangThai = "Không còn ở";

        mauText = Colors.grey;

        mauNen = const Color(0xffF1F1F1);

        break;

      /// hủy hóa đơn
      case 3:
        textTrangThai = "Đã hủy";

        mauText = Colors.red;

        mauNen = const Color(0xffFDECEC);

        break;

      /// CHƯA THU
      default:
        textTrangThai = "Chưa thu";

        mauText = const Color(0xffF08A24);

        mauNen = const Color(0xffFFF1E5);
    }

    return GestureDetector(
      onTap: onTap,

      child: Row(
        children: [
          /// THÔNG TIN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// THÁNG
                Text(
                  hoaDon.thangNam ?? "",

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1C1E),
                  ),
                ),

                const SizedBox(height: 3),

                /// TIỀN + SỐ XE
                Text(
                  "Tổng thu : ${formatMoney(phuongTien.giaGui ?? 0)} VND",

                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffA0A0A0),
                  ),
                ),
              ],
            ),
          ),

          /// TRẠNG THÁI
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
