import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/FormPhong/FormPhong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../view_models/phong_view_model.dart';

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

              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FormPhong(room: room)),
              );
              if(result != null && result is ItemPhong){
                context.read<PhongViewModel>().updateRoomInList(result);
              }
              Navigator.pop(context);
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
              Navigator.pop(context);

            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

}