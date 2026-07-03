import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/FormPhong/FormPhong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_models/phong_view_model.dart';
import '../../../../../widgets/app_confirm_dialog.dart';

class MoreOptionsSheet extends StatelessWidget {
  final ItemPhong room;
  const MoreOptionsSheet({super.key,required this.room});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Thanh gạch ngang nhỏ trên đỉnh sheet
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.edit_outlined, color: Color(0xFF2D7A3A)),
            title: const Text('Chỉnh sửa thông tin phòng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FormPhong(room: room)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.devices_other_rounded, color: Color(0xFF2D7A3A)),
            title: const Text('Xem thiết bị trong phòng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);

            },
          ),

          ListTile(
            leading: const Icon(Icons.build_outlined, color: Colors.orange),
            title: const Text('Báo cáo sửa chữa/Sự cố', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(height: 0.5),

          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Xóa phòng trọ này', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red)),
            onTap: () {
              if (room.dsHopDong.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Không thể xóa! Phòng đang có dữ liệu Hợp đồng liên kết. Vui lòng thanh lý hoặc xử lý hợp đồng trước!"),
                    backgroundColor: Color(0xFF1E293B),
                  ),
                );
                return;
              }
              Navigator.pop(context,"DELETE"); // Nếu trống thì đóng menu
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

}