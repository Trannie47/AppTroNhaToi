import 'package:AppTroNhaToi/view_models/nguoithue_view_model.dart';
import 'package:AppTroNhaToi/view_models/phong_view_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'views/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //runApp(const MyApp());
  runApp(
      MultiProvider(
        providers: [
          //Khai báo ở đây để làm Global, mặc định Flutter chạy chế độ Lazy (khi nào gọi mới đẻ)
          ChangeNotifierProvider(create: (_) => NguoithueViewModel()),
          ChangeNotifierProvider(create: (_)=> PhongViewModel())
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

      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const HomePage(),
    );
  }
}