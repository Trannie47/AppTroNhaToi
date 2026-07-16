import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/hang_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Provider/hop_dong_provider.dart';
import 'Provider/loai_phong_provider.dart';
import 'views/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        //Khai báo ở đây để làm Global, mặc định Flutter chạy chế độ Lazy (khi nào gọi mới đẻ)
        ChangeNotifierProvider(create: (_) => PhongProvider()),
        ChangeNotifierProvider(create: (_) => LoaiPhongProvider()),
        ChangeNotifierProvider(create: (_) => HopDongProvider()),
        //File Service được khởi tạo ở đây
        ChangeNotifierProvider(create: (_) => HangHoaProvider()),
        ChangeNotifierProvider(create: (_) => HoaDonTapHoaProvider()),
        ChangeNotifierProvider(create: (_) => NguoiThueProvider()),
        ChangeNotifierProvider(create: (_) => ThietBiProvider()),
        ChangeNotifierProvider(create: (_) => ThongKeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: const Locale('vi', 'VN'),

      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(useMaterial3: false, platform: TargetPlatform.iOS),

      home: const HomePage(),
    );
  }
}
