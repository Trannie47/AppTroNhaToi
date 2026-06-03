import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

class ItemPhuongTien extends StatelessWidget {
  final PhuongTien phuongTien;

  final VoidCallback? delete;

  final VoidCallback? edit;

  const ItemPhuongTien({
    super.key,
    required this.phuongTien,
    this.delete,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    bool coBienSo = phuongTien.bienSo?.trim().isNotEmpty ?? false;

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xffEEEEEE)),
      ),

      child: Column(
        children: [
          /// DÒNG TRÊN
          Row(
            children: [
              /// ICON
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: const Color(0xffEEF5EF),

                  borderRadius: BorderRadius.circular(14),
                ),

                alignment: Alignment.center,

                child: Icon(
                  phuongTien.loaiXe == 0
                      ? Icons.two_wheeler_rounded
                      : phuongTien.loaiXe == 2
                      ? Icons.pedal_bike_rounded
                      : Icons.directions_car_filled_rounded,

                  size: 24,

                  color: const Color(0xff5D8E63),
                ),
              ),

              const SizedBox(width: 14),

              /// THÔNG TIN
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TÊN XE
                    Text(
                      phuongTien.hangXe ?? "",

                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,

                        color: Color(0xff1C1C1E),
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// BIỂN SỐ
                    Text(
                      coBienSo
                          ? "${phuongTien.bienSo} · ${phuongTien.mauSac ?? ""}"
                          : "Không BKS · ${phuongTien.mauSac ?? ""}",

                      style: const TextStyle(
                        fontSize: 12,

                        color: Color(0xff9B9B9B),
                      ),
                    ),
                  ],
                ),
              ),

              /// GIÁ
              Text(
                "${formatMoney(phuongTien.giaGui ?? 0)}/tháng",

                style: const TextStyle(
                  fontSize: 15,

                  fontWeight: FontWeight.w800,

                  color: Color(0xff2D7A3A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// DÒNG DƯỚI bỏ laoij xe
          if (delete != null || edit != null)
            Row(
              children: [
                const Spacer(),

                /// SỬA
                if (edit != null)
                  GestureDetector(
                    onTap: edit,

                    child: const Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,

                          size: 15,

                          color: Color(0xffF08A24),
                        ),

                        SizedBox(width: 4),

                        Text(
                          "Sửa",

                          style: TextStyle(
                            fontSize: 11,

                            fontWeight: FontWeight.w500,

                            color: Color(0xffF08A24),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (edit != null && delete != null) const SizedBox(width: 14),

                /// XÓA
                if (delete != null)
                  GestureDetector(
                    onTap: delete,

                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,

                          size: 15,

                          color: Colors.red,
                        ),

                        SizedBox(width: 4),

                        Text(
                          "Xóa",

                          style: TextStyle(
                            fontSize: 11,

                            fontWeight: FontWeight.w500,

                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
