import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/phieu_su_co.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/SuCoForm/SuCoFormViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/luanChuyenPage.dart';
import 'package:AppTroNhaToi/widgets/ItemLuanChuyen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SuCoForm extends StatefulWidget {
  final PhieuSuCo? suCo;
  final int? phongId;

  const SuCoForm({super.key, this.suCo, this.phongId});

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
      phongMacDinhId: widget.phongId,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.phongId == null) return;

      final ds = vm.dsPhong.where((e) => e.phongID == widget.phongId).toList();

      if (ds.isNotEmpty) {
        vm.phong = ds.first;
        vm.notifyListeners();
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
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<SuCoFormViewModel>(
        builder: (_, vm, __) {
          return Scaffold(
            backgroundColor: const Color(0xffF5F5F5),

            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: Colors.white,
              title: Text(
                vm.isEditMode ? "Cập nhật sự cố" : "Thêm sự cố",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            // bottomNavigationBar: SafeArea(
            //   child: Container(
            //     color: Colors.white,
            //     padding: const EdgeInsets.all(16),
            //     child: SizedBox(
            //       height: 52,
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: const Color(0xff2D7A3A),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(14),
            //           ),
            //         ),
            //         onPressed: vm.isLoading
            //             ? null
            //             : () async {
            //                 final result = await vm.luu();
            //
            //                 if (!mounted) return;
            //
            //                 if (result != null) {
            //                   Navigator.pop(context, result);
            //                 } else {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                       content: Text(
            //                         "Không thể lưu sự cố",
            //                       ),
            //                     ),
            //                   );
            //                 }
            //               },
            //         icon: vm.isLoading
            //             ? const SizedBox(
            //                 width: 18,
            //                 height: 18,
            //                 child: CircularProgressIndicator(
            //                   color: Colors.white,
            //                   strokeWidth: 2,
            //                 ),
            //               )
            //             : const Icon(
            //                 Icons.save_outlined,
            //                 color: Colors.white,
            //               ),
            //         label: Text(
            //           vm.isEditMode
            //               ? "CẬP NHẬT"
            //               : "LƯU SỰ CỐ",
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            bottomNavigationBar: vm.isEditMode
                ? SafeArea(
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
                                  }
                                },
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: const Text(
                            "CẬP NHẬT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,

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
                              color: Color(0xf5db0827),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "THÔNG TIN SỰ CỐ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xff2D7A3A),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

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

                        const SizedBox(height: 20),

                        DropdownButtonFormField<Phong>(
                          value: vm.phong,
                          decoration: InputDecoration(
                            labelText: "Phòng",
                            errorText: vm.errPhong,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: vm.dsPhong.map((e) {
                            return DropdownMenuItem<Phong>(
                              value: e,
                              child: Text(e.tenPhong),
                            );
                          }).toList(),
                          onChanged: widget.phongId != null
                              ? null
                              : (value) {
                                  vm.phong = value;
                                  vm.notifyListeners();
                                },
                        ),

                        const SizedBox(height: 24),
                        TextField(
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
                          onTap: () => vm.chonNgay(context, vm.txtNgayBatDau),
                        ),
                        const SizedBox(height: 24),

                        TextField(
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
                          onTap: () =>
                              vm.chonNgay(context, vm.txtNgayHoanThanh),
                        ),

                        const SizedBox(height: 28),

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

                        const SizedBox(height: 28),

                        TextField(
                          controller: vm.txtChiPhi,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DinhDangGiaVN(),
                          ],
                          decoration: InputDecoration(
                            labelText: "Chi phí sửa chữa",
                            hintText: "0",
                            suffixText: "VNĐ",
                            errorText: vm.errChiPhi,
                            prefixIcon: const Icon(Icons.payments_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

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
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: vm.daXacNhanThongTin
                                ? null
                                : () async {
                                    final result = await vm.luu();

                                    if (!mounted) return;

                                    if (result != null) {
                                      vm.xacNhanThongTin();

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Đã xác nhận thông tin sự cố",
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Không thể lưu sự cố"),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vm.daXacNhanThongTin
                                  ? Colors.grey
                                  : const Color(0xff2D7A3A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(
                              vm.daXacNhanThongTin
                                  ? Icons.check_circle
                                  : Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              vm.daXacNhanThongTin
                                  ? "ĐÃ XÁC NHẬN"
                                  : "XÁC NHẬN THÔNG TIN",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  if (vm.daXacNhanThongTin || vm.isEditMode)
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 130,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (vm.suCoDaLuu == null) {
                                      return;
                                    }

                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LuanChuyenPage(
                                          suCoId: vm.suCoDaLuu!.suCoId!,
                                        ),
                                      ),
                                    );

                                    if (!mounted) return;

                                    if (result != null) {
                                      vm.loadDeSua(result);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff2D7A3A),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: Icon(
                                    vm.isEditMode ? Icons.edit : Icons.add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    vm.isEditMode
                                        ? "Cập nhật\nluân chuyển"
                                        : "Thêm",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          if ((vm.suCoDaLuu?.chiTietLuanChuyen ?? []).isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 40),
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
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  vm.suCoDaLuu?.chiTietLuanChuyen?.length ?? 0,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, index) {
                                return ItemLuanChuyen(
                                  item: vm.suCoDaLuu!.chiTietLuanChuyen![index],
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
