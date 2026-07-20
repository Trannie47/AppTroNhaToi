import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/ThietBiPage/thietBiPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiForm/thietBiForm.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietThietBiPage/chiTietThietBiPage.dart';
import 'package:AppTroNhaToi/widgets/itemThietBi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThietBiPage extends StatefulWidget {
  const ThietBiPage({super.key});

  @override
  State<ThietBiPage> createState() => _ThietBiPageState();
}

class _ThietBiPageState extends State<ThietBiPage> {
  late ThietBiPageViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ThietBiPageViewModel(context.read<ThietBiProvider>());
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    //Khi frame hiện tại mở thì nó sẽ call dữ liệu lại chống update 2 lần
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final thietBiProvider = context.watch<ThietBiProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 6,
        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(
            left: 18, // dịch sang phải khoảng 0.5 cm
            top: 8,
            bottom: 8,
          ),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),

            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        title: const Text(
          "Thiết bị",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: ElevatedButton.icon(
              onPressed: () async {
                ThietBi? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ThietBiForm()),
                );

                if (result != null) {
                  await vm.refresh();
                }
              },

              icon: const Icon(Icons.add, size: 18),
              label: const Text("Thêm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        child: Column(
          children: [
            const SizedBox(height: 16),

            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: vm.txtSearch,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Tìm thiết bị",
                ),
                onChanged: (_) {
                  vm.search();
                },
              ),
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: vm.dsHienThi.length,

                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      bool? result = await Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => SuaChuaProvider(),
                              ),
                              ChangeNotifierProvider(
                                create: (_) => LichSuMuaThietBiProvider(),
                              ),
                            ],
                            child: ChiTietThietBiPage(
                              thietBi: vm.dsHienThi[index],
                            ),
                          ),
                        ),
                      );

                      if (result == true) {
                        await vm.refresh();
                      }
                    },

                    child: ItemThietBi(thietBi: vm.dsHienThi[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
