import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/SuCoPage/SuCoPageViewModel.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/SuCoForm/SuCoForm.dart';
import 'package:AppTroNhaToi/widgets/ItemSuCo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuCoPage extends StatefulWidget {
  const SuCoPage({super.key});

  @override
  State<SuCoPage> createState() => _SuCoPageState();
}

class _SuCoPageState extends State<SuCoPage> {
  late SuCoPageViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = SuCoPageViewModel(
      context.read<SuCoProvider>(),
    );
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<SuCoPageViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xffF5F5F5),

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Quản lý sự cố",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xff2D7A3A),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                "Thêm sự cố",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuCoForm(),
                  ),
                );

                await vm.refresh();
              },
            ),

            body: RefreshIndicator(
              onRefresh: vm.refresh,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      10,
                      16,
                      16,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: vm.txtSearch,
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm sự cố...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xffF5F5F5),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xff2D7A3A),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _itemThongKe(
                                "Tổng sự cố",
                                vm.dsSuCo.length.toString(),
                                Colors.blue,
                                Icons.assignment_outlined,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _itemThongKe(
                                "Đang xử lý",
                                vm.soDangXuLy.toString(),
                                Colors.orange,
                                Icons.build_circle_outlined,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: _itemThongKe(
                                "Hoàn thành",
                                vm.soHoanThanh.toString(),
                                const Color(0xff2D7A3A),
                                Icons.check_circle_outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                     Expanded(
                    child: vm.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : vm.dsHienThi.isEmpty
                            ? ListView(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 120),
                                  Icon(
                                    Icons.assignment_late_outlined,
                                    size: 70,
                                    color: Color(0xffBDBDBD),
                                  ),
                                  SizedBox(height: 12),
                                  Center(
                                    child: Text(
                                      "Chưa có sự cố nào",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff757575),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: vm.dsHienThi.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, index) {
                                  final PhieuSuCo item =
                                      vm.dsHienThi[index];

                                  return ItemSuCo(
                                    suCo: item,
                                    edit: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SuCoForm(
                                            suCo: item,
                                          ),
                                        ),
                                      );

                                      await vm.refresh();
                                    },
                                    delete: () async {
                                      final xoa = await showDialog<bool>(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text(
                                                "Xóa sự cố",
                                              ),
                                              content: const Text(
                                                "Bạn có chắc muốn xóa sự cố này?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      false,
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Hủy",
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Xóa",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      if (!xoa) return;

                                      final ok = await vm.xoa(
                                        item.suCoId!,
                                      );

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: ok
                                              ? const Color(0xff2D7A3A)
                                              : Colors.red,
                                          content: Text(
                                            ok
                                                ? "Đã xóa sự cố"
                                                : "Không thể xóa sự cố",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemThongKe(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff777777),
            ),
          ),
        ],
      ),
    );
  }
}