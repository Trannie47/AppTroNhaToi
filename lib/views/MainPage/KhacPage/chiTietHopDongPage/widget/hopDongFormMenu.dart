import 'package:AppTroNhaToi/views/MainPage/KhacPage/HopDongForm/hopDongForm.dart';
import 'package:flutter/material.dart';
import '../../../../../models/hop_dong.dart';
import '../../../../../modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';

class HopDongFormMenu extends StatelessWidget {
  final ChiTietHopDongViewModel vm;
  const HopDongFormMenu({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xffE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),

          _item(
            context: context,
            icon: Icons.edit_document,
            iconColor: const Color(0xff4F46E5),
            title: 'Cập nhật hợp đồng',
            onTap: () async{
              final navigator = Navigator.of(context);
              navigator.pop();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HopDongForm(hopDong: vm.hopDong),
                ),
              );

              if (result != null) {
                if (result is HopDong) {
                  vm.updateHopDongData(result);
                } else if (result == true) {
                  navigator.pop(true);
                }
              }
            },
          ),

          const Divider(height: 1, color: Color(0xffF0F0F0)),

          _item(
            context: context,
            icon: Icons.update,
            iconColor: const Color(0xff2E7D32),
            title: 'Gia hạn hợp đồng',
            onTap: () {
              Navigator.pop(context);

            },
          ),
        ],
      ),
    );
  }

  Widget _item({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    Color textColor = const Color(0xff1D2433),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
