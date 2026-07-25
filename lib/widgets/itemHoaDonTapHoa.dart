import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/TapHoaPage/HoaDonTapHoaModel.dart';
import 'package:flutter/material.dart';

class ItemHoaDonTapHoa extends StatelessWidget {
  final HoaDonTapHoaModel hoaDonTapHoaModel;
  final String? tenNguoiThue;

  final VoidCallback? onChiTiet;
  final VoidCallback? onSua;
  final VoidCallback? onXoa;

  const ItemHoaDonTapHoa({
    super.key,
    required this.hoaDonTapHoaModel,
    this.tenNguoiThue,
    this.onChiTiet,
    this.onSua,
    this.onXoa,
  });

  @override
  Widget build(BuildContext context) {
    final bool laKhachVangLai =
        tenNguoiThue == null || tenNguoiThue!.trim().isEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onChiTiet,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            /// Nội dung bên trái
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Mã hóa đơn
                  Text(
                    "${hoaDonTapHoaModel.hoaDon.maHoaDon}",
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),
                  if ((hoaDonTapHoaModel.hoaDon.tongTien ?? 0) -
                          hoaDonTapHoaModel.daThu >
                      0)
                    Text(
                      "${tenNguoiThue ?? 'Khách vãng lai'} - ${formatMoney((hoaDonTapHoaModel.hoaDon.tongTien ?? 0) - hoaDonTapHoaModel.daThu)}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    Text(
                      "${tenNguoiThue ?? 'Khách vãng lai'} - ${formatMoney(hoaDonTapHoaModel.hoaDon.tongTien ?? 0)}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 5),

                  Text(
                    (hoaDonTapHoaModel.daThu ==
                                hoaDonTapHoaModel.hoaDon.tongTien) ||
                            laKhachVangLai
                        ? "Đã thu"
                        : "Chưa thu",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (hoaDonTapHoaModel.daThu == hoaDonTapHoaModel.hoaDon.tongTien ||
                laKhachVangLai)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 24)
            else ...[
              if (onSua != null) const SizedBox(width: 10),

              if (onSua != null)
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF5EC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onSua,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xff2D7A3A),
                      size: 20,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
