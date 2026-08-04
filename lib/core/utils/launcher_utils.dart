import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<void> goidien(String sdt) async {
    if (sdt.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: sdt.trim());
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Không thể mở ứng dụng gọi điện với số: $sdt');
      }
    } catch (e) {
      debugPrint('Lỗi kích hoạt gọi điện $e');
    }
  }

  static Future<void> nhantin(String sdt) async {
    if (sdt.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'sms', path: sdt.trim());
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        debugPrint('Không thể mở ứng dụng SMS với số: $sdt');
      }
    } catch (e) {
      debugPrint('Lỗi kích hoạt nhắn tin SMS: $e');
    }
  }

  static Future<void> zalo(String sdt) async {
    if (sdt.isEmpty) return;
    final String urlZalo = "https://zalo.me/${sdt.trim()}";
    final Uri lauchUri = Uri.parse(urlZalo);
    try {
      if (await canLaunchUrl(lauchUri)) {
        await launchUrl(lauchUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Không thể mở zalo với số điện thoại: $sdt');
      }
    } catch (e) {
      debugPrint('Lỗi kích hoạt ứng dụng Zalo: $e');
    }
  }
}
