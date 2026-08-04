import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ItemPhieuThuTapHoa extends StatefulWidget {
  final PhieuThuHdTh? phieuThu;

  final ValueChanged<PhieuThuHdTh>? onXacNhan;
  final double soTienConThieu;

  const ItemPhieuThuTapHoa({
    super.key,
    this.phieuThu,
    this.onXacNhan,
    required this.soTienConThieu,
  });

  @override
  State<ItemPhieuThuTapHoa> createState() => _ItemPhieuThuTapHoaState();
}

class _ItemPhieuThuTapHoaState extends State<ItemPhieuThuTapHoa> {
  late TextEditingController txtNguoiDong;
  late TextEditingController txtSoTien;
  late bool daXacNhan;

  final _formatter = NumberFormat("#,##0", "vi_VN");
  @override
  void initState() {
    super.initState();

    txtNguoiDong = TextEditingController(
      text: widget.phieuThu?.nguoiDong ?? "",
    );

    txtSoTien = TextEditingController(
      text: widget.phieuThu?.soTien == null
          ? ""
          : _formatter.format(widget.phieuThu!.soTien),
    );

    daXacNhan = widget.phieuThu?.maPhieuThu != null;
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    Icon? suffixIcon,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  void xacNhan() {
    final phieuThu = (widget.phieuThu ?? PhieuThuHdTh()).copyWith(
      maPhieuThu: widget.phieuThu?.maPhieuThu,
      maHoaDon: widget.phieuThu?.maHoaDon,
      ngayThu: DateTime.now(),
      nguoiDong: txtNguoiDong.text.trim(),
      soTien:
          double.tryParse(
            txtSoTien.text.replaceAll(".", "").replaceAll(",", ""),
          ) ??
          0,
    );

    widget.onXacNhan?.call(phieuThu);

    setState(() {
      daXacNhan = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.phieuThu?.maPhieuThu != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "#${widget.phieuThu!.maPhieuThu}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 22),

          buildTextField(
            title: "Người đóng",
            controller: txtNguoiDong,
            enabled: !daXacNhan,
          ),

          const SizedBox(height: 18),

          buildTextField(
            title: "Số tiền",
            controller: txtSoTien,
            keyboardType: TextInputType.number,
            suffixIcon: Icon(Icons.attach_money, color: Colors.grey),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DinhDangGiaVN(),
            ],
            enabled: !daXacNhan,
          ),

          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: daXacNhan
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Đã xác nhận",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      //Kiểm tra nếu nhập số tiền lớn hơn số tiền còn thiếu thì hiển thị thông báo lỗi
                      if ((double.tryParse(
                                txtSoTien.text
                                    .replaceAll(".", "")
                                    .replaceAll(",", ""),
                              ) ??
                              0) >
                          widget.soTienConThieu) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Số tiền không được lớn hơn số tiền còn thiếu: ${widget.soTienConThieu.toStringAsFixed(0)}",
                            ),
                          ),
                        );
                        return;
                      }
                      if (txtSoTien.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Vui lòng nhập số tiền."),
                          ),
                        );
                        return;
                      }

                      if ((double.tryParse(
                                txtSoTien.text
                                    .replaceAll(".", "")
                                    .replaceAll(",", ""),
                              ) ??
                              0) <=
                          0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Số tiền phải lớn hơn 0."),
                          ),
                        );
                        return;
                      }

                      xacNhan();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      "Xác nhận",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2D7A3A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    txtNguoiDong.dispose();
    txtSoTien.dispose();
    super.dispose();
  }
}
