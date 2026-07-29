import 'package:AppTroNhaToi/Provider/cau_hinh_gia_provider.dart';
import 'package:AppTroNhaToi/Provider/dien_nuoc_provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_gui_xe_provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_phong_provider.dart';
import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_luu_tru_tam_thoi_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_thu_hang_thang_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/hang_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/thong_ke_provider.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hang_thang.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Provider/hop_dong_provider.dart';
import 'Provider/loai_phong_provider.dart';
import 'Provider/phieu_thu_dien_nuoc_provider.dart';
import 'Provider/phuong_tien_provider.dart';
import 'Provider/thong_bao_provider.dart';
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
        ChangeNotifierProvider(create: (_) => DienNuocProvider()),
        ChangeNotifierProvider(create: (_) => PhuongTienProvider()),
        ChangeNotifierProvider(create: (_) => LapRapProvider()),
        ChangeNotifierProvider(create: (_) => NguoiLuuTruTamThoiProvider()),
        ChangeNotifierProvider(create: (_) => CauHinhGiaProvider()),
        ChangeNotifierProvider(create: (_) => HoadonPhongProvider()),
        ChangeNotifierProvider(create: (_) => PhieuThuHangThangProvider()),
        ChangeNotifierProvider(create: (_) => PhieuThuDienNuocProvider()),
        ChangeNotifierProvider(create: (_) => HoaDonGuiXeProvider()),
        //File Service được khởi tạo ở đây
        ChangeNotifierProvider(create: (_) => HangHoaProvider()),
        // ChangeNotifierProvider(create: (_) => HoaDonTapHoaProvider()),
        ChangeNotifierProvider(create: (_) => NguoiThueProvider()),
        // ChangeNotifierProvider(create: (_) => ThietBiProvider()),
        //ChangeNotifierProvider(create: (_) => ThongKeProvider()),
        ChangeNotifierProvider(
          create: (_) => ThongKeProvider()
            ..getThongKe(thang: DateTime.now().month, nam: DateTime.now().year),
        ),
        ChangeNotifierProvider(create: (_) => ThietBiProvider()..fetchAll()),
        ChangeNotifierProvider(
          create: (_) => HoaDonTapHoaProvider()..fetchAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThongBaoProvider()..startPolling(),
        ),
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
