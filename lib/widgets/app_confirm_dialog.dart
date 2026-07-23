import 'package:flutter/material.dart';

class AppConfirmDialog extends StatelessWidget{
  final String title;
  final String content;
  final String textConfirm;
  final String textCancel;
  final VoidCallback onConfirm;
  final bool isDangerous; // check xem hành động cần xác nhận này có nguy hiểm không, nếu true thì hiện màu đỏ còn false thì hiện màu xanh
  final IconData? customIcon; // Icon tùy chỉnh (nếu không truyền sẽ dùng mặc định)
  final Color? confirmColor;
  AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.textConfirm= "Xác nhận",
    this.textCancel="Hủy",
    required this.onConfirm,
    this.isDangerous =true,
    this.customIcon,
    this.confirmColor,
});
  @override
  Widget build(BuildContext context) {
    // Tự động đổi màu chủ đạo dựa theo tính chất nguy hiểm của hành động
    final mainColor = confirmColor ??
        (isDangerous ? const Color(0xFFEF4444) : const Color(0xFF2D7A3A));
    final iconBgColor = mainColor.withOpacity(0.12);
    final iconData = customIcon ?? (isDangerous ? Icons.delete_forever_rounded : Icons.check_circle_outline_rounded);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconBgColor,
              child: Icon(iconData, color: mainColor, size: 28),
            ),
            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        textCancel,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        onConfirm();
                      },
                      child: Text(
                        textConfirm,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


