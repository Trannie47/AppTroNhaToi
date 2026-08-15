import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/models/item_phong_model.dart';
import 'package:flutter/material.dart';

class ItemPhieuLuanChuyen extends StatelessWidget {
  final ItemPhongModel phongCu;
  final PhieuLuanChuyen item;

  final VoidCallback? edit;

  final VoidCallback? delete;

  final VoidCallback? hoanThanh;

  final VoidCallback? onClick;

  const ItemPhieuLuanChuyen({
    super.key,
    required this.item,
    required this.phongCu,
    this.edit,
    this.delete,
    this.hoanThanh,
    this.onClick,
  });

  bool get _daHetHieuLuc {
    if (item.denNgay == null) return false;

    final homNay = DateTime.now();
    final ngayHomNay = DateTime(homNay.year, homNay.month, homNay.day);
    final denNgay = DateTime(
      item.denNgay!.year,
      item.denNgay!.month,
      item.denNgay!.day,
    );

    return !denNgay.isAfter(ngayHomNay); // denNgay <= hôm nay
  }

  // Phiếu chưa tới ngày bắt đầu -> chưa có gì để "hoàn thành sớm" cả.
  bool get _chuaBatDau {
    if (item.tuNgay == null) return false;

    final homNay = DateTime.now();
    final ngayHomNay = DateTime(homNay.year, homNay.month, homNay.day);
    final tuNgay = DateTime(
      item.tuNgay!.year,
      item.tuNgay!.month,
      item.tuNgay!.day,
    );

    return tuNgay.isAfter(ngayHomNay);
  }

  //Chỉ hiện nút "Hoàn thành sớm" khi phiếu đang thực sự trong thời gian
  bool get _coTheHoanThanhSom => !_daHetHieuLuc && !_chuaBatDau;

  @override
  Widget build(BuildContext context) {
    final hienNutHoanThanh = hoanThanh != null && _coTheHoanThanhSom;
    final hienNutHanhDong =
        !_daHetHieuLuc && (edit != null || delete != null || hienNutHoanThanh);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F3FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Color(0xff1976D2),
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.hopDongId ?? "Chưa có hợp đồng",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.denNgay != null
                                  ? "${formatDate(item.tuNgay)} - ${formatDate(item.denNgay)}"
                                  : formatDate(item.tuNgay),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (onClick != null)
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                ],
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F9FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Phòng cũ",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            phongCu.tenPhong,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xff1976D2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Phòng mới",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.phongMoi?.tenPhong ?? "--",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Chi phí: ${formatMoney(item.chiPhi ?? 0)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              if ((item.lyDoLuanChuyen ?? "").isNotEmpty) ...[
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.grey,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lý do",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(item.lyDoLuanChuyen!),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              if ((item.ghiChu ?? "").isNotEmpty) ...[
                const SizedBox(height: 12),

                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ghi chú",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item.ghiChu!),
                    ],
                  ),
                ),
              ],

              if (hienNutHanhDong) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Spacer(),

                    if (edit != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: edit,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Sửa",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (edit != null && hienNutHoanThanh)
                      const SizedBox(width: 8),

                    if (hienNutHoanThanh)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: hoanThanh,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: Color(0xff2D7A3A),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Hoàn thành sớm",
                                style: TextStyle(color: Color(0xff2D7A3A)),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if ((edit != null || hienNutHoanThanh) && delete != null)
                      const SizedBox(width: 8),

                    if (delete != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: delete,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text("Xóa", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
