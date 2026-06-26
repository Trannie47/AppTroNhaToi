import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/ChonHangHoaPage/chonHangHoaPageViewModel.dart';
import 'package:AppTroNhaToi/Provider/hang_hoa_provider.dart';
import 'package:AppTroNhaToi/widgets/itemHangHoa.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChonHangHoaPage extends StatefulWidget {
  const ChonHangHoaPage({super.key});

  @override
  State<ChonHangHoaPage> createState() => _ChonHangHoaPageState();
}

class _ChonHangHoaPageState extends State<ChonHangHoaPage> {
  late ChonHangHoaPageModelView vm;

  @override
  void initState() {
    super.initState();

    vm = ChonHangHoaPageModelView(context.read<HangHoaProvider>());

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
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        title: const Text("Thêm hàng hoá vào hoá đơn"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search
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
                  hintText: "Tìm mặt hàng",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: vm.dsHangHoaHienThi.length,
                itemBuilder: (context, index) {
                  final hangHoa = vm.dsHangHoaHienThi[index];
                  return ItemHangHoa(
                    hangHoa: hangHoa,
                    onTap: () {
                      Navigator.pop(context, hangHoa);
                    },
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
