import 'package:AppTroNhaToi/modelviews/MainPage/MainPage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainPageModelView vm;

  @override
  void initState() {
    super.initState();

    vm = MainPageModelView();

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
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
      body: vm.pages[vm.currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        selectedItemColor: const Color(0xFF2D7A3A),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            vm.currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Tổng quan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Phòng"),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Người thuê",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Khác"),
        ],
      ),
    );
  }
}
