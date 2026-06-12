
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/ThietBiPage/thietBiPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiForm/thietBiForm.dart';
import 'package:AppTroNhaToi/widgets/itemThietBi.dart';
import 'package:flutter/material.dart';

class ThietBiPage extends StatefulWidget {
  const ThietBiPage({super.key});

  @override
  State<ThietBiPage> createState() => _ThietBiPageState();
}

class _ThietBiPageState extends State<ThietBiPage> {

  final vm = ThietBiPageViewModel();

  @override
  Widget build(BuildContext context) {

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

            child:ElevatedButton.icon(
              onPressed: () async {

                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ThietBiForm(),
                  ),
                );

                if (result == true) {
                  setState(() {});
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
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        child: Column(
          children: [

            const SizedBox(height: 16),

            Row(
              children: [

                _tab(
                  "Tất cả (${vm.tongSoThietBi})",
                  0,
                ),

                _tab(
                  "Đang dùng (${vm.tongDangDung})",
                  1,
                ),

                _tab(
                  "Hỏng/Sửa (${vm.tongHongSua})",
                  2,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(

                itemCount: vm.dsHienThi.length,

                itemBuilder: (context,index){

                  return GestureDetector(

                    onTap: () async {

                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ThietBiForm(
                            thietBi: vm.dsHienThi[index],
                          ),
                        ),
                      );

                      if (result == true) {
                        setState(() {});
                      }
                    },

                    child: ItemThietBi(
                      thietBi: vm.dsHienThi[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String text, int index) {
    bool selected = vm.currentIndex == index;

    Color backgroundColor = const Color(0xffF3F3F3);
    Color textColor = const Color(0xff757575);

    if (selected) {
      switch (index) {
        case 1:
          backgroundColor = const Color(0xffE7F5EA);
          textColor = const Color(0xff2D7A3A);
          break;

        case 2:
          backgroundColor = const Color(0xffFFEAEA);
          textColor = Colors.red;
          break;

        default:
          backgroundColor = const Color(0xffF3F3F3);
          textColor = Colors.black87;
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          vm.changeTab(index);
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 8),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),

        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}