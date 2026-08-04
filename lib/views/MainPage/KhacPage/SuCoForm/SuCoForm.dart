import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/SuCoForm/SuCoFormViewModel.dart';
import 'package:AppTroNhaToi/widgets/ItemLuanChuyen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuCoForm extends StatefulWidget {
  final PhieuSuCo? suCo;

  const SuCoForm({
    super.key,
    this.suCo,
  });

  @override
  State<SuCoForm> createState() => _SuCoFormState();
}

class _SuCoFormState extends State<SuCoForm> {
  late SuCoFormViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = SuCoFormViewModel(
      context.read<SuCoProvider>(),
      context.read<PhongProvider>(),
      suCoInput: widget.suCo,
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
      child: Consumer<SuCoFormViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xffF5F5F5),

            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(
                vm.isEditMode
                    ? "Cập nhật sự cố"
                    : "Thêm sự cố",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),

            bottomNavigationBar: SafeArea(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2D7A3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final result = await vm.luu();

                            if (!mounted) return;

                            if (result != null) {
                              Navigator.pop(context, result);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Không thể lưu sự cố",
                                  ),
                                ),
                              );
                            }
                          },
                    icon: vm.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                          ),
                    label: Text(
                      vm.isEditMode
                          ? "CẬP NHẬT"
                          : "LƯU SỰ CỐ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xff2D7A3A),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "THÔNG TIN SỰ CỐ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: vm.txtTenSuCo,
                          decoration: InputDecoration(
                            labelText: "Tên sự cố",
                            errorText: vm.errTenSuCo,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField(
                          value: vm.phong,
                          decoration: InputDecoration(
                            labelText: "Phòng",
                            errorText: vm.errPhong,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: vm.dsPhong.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.tenPhong),
                            );
                          }).toList(),
                          onChanged: (value) {
                            vm.phong = value;
                            vm.notifyListeners();
                          },
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: vm.txtNgayBatDau,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Ngày bắt đầu",
                                  errorText: vm.errNgayBatDau,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () => vm.chonNgay(
                                  context,
                                  vm.txtNgayBatDau,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextField(
                                controller: vm.txtNgayHoanThanh,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Ngày hoàn thành",
                                  errorText: vm.errNgayHoanThanh,
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onTap: () => vm.chonNgay(
                                  context,
                                  vm.txtNgayHoanThanh,
                                ),
                              ),
                            ),
                          ],
                        ),
                            const SizedBox(height: 16),

                        DropdownButtonFormField<int>(
                          value: vm.trangThaiThongBao,
                          decoration: InputDecoration(
                            labelText: "Trạng thái",
                            errorText: vm.errTrangThai,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: vm.dsTrangThai.map((e) {
                            return DropdownMenuItem<int>(
                              value: e["value"],
                              child: Text(e["text"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            vm.trangThaiThongBao = value;
                            vm.notifyListeners();
                          },
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: vm.txtChiPhi,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Chi phí sửa chữa",
                            errorText: vm.errChiPhi,
                            prefixIcon: const Icon(
                              Icons.payments_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: vm.txtGhiChu,
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "Ghi chú",
                            errorText: vm.errGhiChu,
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.swap_horizontal_circle_outlined,
                              color: Color(0xff2D7A3A),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "LUÂN CHUYỂN NGƯỜI THUÊ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2D7A3A),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Thêm",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        if ((widget.suCo?.chiTietLuanChuyen ?? [])
                            .isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 40,
                            ),
                            alignment: Alignment.center,
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.swap_horizontal_circle_outlined,
                                  size: 55,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Chưa có lịch sử luân chuyển",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: widget
                                    .suCo!.chiTietLuanChuyen?.length ??
                                0,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, index) {
                              return ItemLuanChuyen(
                                item: widget
                                    .suCo!.chiTietLuanChuyen![index],
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}