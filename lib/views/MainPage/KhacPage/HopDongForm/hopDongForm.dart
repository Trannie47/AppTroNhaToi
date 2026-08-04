import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/DTO/NguoiThueAvailableDTO.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/hopDongForm/HopDongFormViewModel.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:AppTroNhaToi/states/create_contract_state.dart';
import 'package:AppTroNhaToi/states/hop_dong_update_state.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:AppTroNhaToi/widgets/app_confirm_dialog.dart';

class HopDongForm extends StatefulWidget {
  final HopDongDTO? hopDong;

  const HopDongForm({super.key, this.hopDong});

  @override
  State<HopDongForm> createState() => _TaoHopDongPageState();
}

class _TaoHopDongPageState extends State<HopDongForm> {
  late HopDongFormViewModel vm;

  @override
  void initState() {
    super.initState();
    final globalHopDongProvider = Provider.of<HopDongProvider>(
      context,
      listen: false,
    );
    final globalNguoiThueProvider = Provider.of<NguoiThueProvider>(
      context,
      listen: false,
    );
    vm = HopDongFormViewModel(globalHopDongProvider, globalNguoiThueProvider);
    vm.init(hopDong: widget.hopDong);
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

  void _showThemThanhVienDialog() async {
    NguoiThueAvailableDTO? selectedThanhVien;
    final quanHeController = TextEditingController();

    List<NguoiThueAvailableDTO> availableMembers = await vm
        .getAvailableMembers();

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: const Text(
                "Thêm thành viên ở chung",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chọn người ở cùng",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    CustomDropdownSearch<NguoiThueAvailableDTO>(
                      hintText: "Chọn khách thuê",
                      asyncItems: (filter) async {
                        final f = filter.toLowerCase();
                        if (f.isEmpty) return availableMembers;
                        return availableMembers
                            .where((e) => e.hoTen!.toLowerCase().contains(f))
                            .toList();
                      },
                      selectedItem: selectedThanhVien,
                      itemAsString: (item) => item.hoTen ?? '',
                      onChanged: (value) {
                        setDialogState(() {
                          selectedThanhVien = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Mối quan hệ với đại diện",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: quanHeController,
                      decoration: InputDecoration(
                        hintText: "VD: Vợ, Con, Bạn ở cùng...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xffF7F7F7),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xff2D7A3A),
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Hủy",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedThanhVien != null) {
                      vm.addThanhVienOChung(
                        selectedThanhVien!,
                        quanHeController.text.trim().isEmpty
                            ? 'Thành viên'
                            : quanHeController.text.trim(),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Thêm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        vm.createContractState is CreateContractLoading ||
        vm.updateContractState is HopDongUpdateLoading;
    final bool isEditMode = vm.isEdit;
    final bool isActiveContract = vm.isEdit && vm.hdDTO?.trangThai == 1;
    final bool isPendingContract = vm.isEdit && vm.hdDTO?.trangThai == 0;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 61,
            leading: Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: Material(
                  color: const Color(0xffF3F3F3),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _hienThiXacNhanThoat(),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios_new, size: 14),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              vm.isEdit ? "Cập nhật hợp đồng" : "Tạo hợp đồng",
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _section(
                  title: "Thông tin thuê",
                  child: Column(
                    children: [
                      _label("Phòng thuê"),
                      const SizedBox(height: 6),
                      AbsorbPointer(
                        absorbing: isEditMode,
                        child: Opacity(
                          opacity: isEditMode ? 0.6 : 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdownSearch<RoomAvailableDTO>(
                                hintText: "Chọn phòng thuê",
                                asyncItems: (filter) async {
                                  if (vm.roomsAvailable
                                      is! HopDongSuccess<RoomAvailableDTO>) {
                                    await vm.getRoomsAvailableForContract();
                                  }
                                  if (vm.roomsAvailable is HopDongError) {
                                    final errorState =
                                        vm.roomsAvailable as HopDongError;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(errorState.errorMessage),
                                        backgroundColor: Colors.red.shade700,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return [];
                                  }
                                  if (vm.roomsAvailable
                                      is HopDongSuccess<RoomAvailableDTO>) {
                                    final data =
                                        (vm.roomsAvailable
                                                as HopDongSuccess<
                                                  RoomAvailableDTO
                                                >)
                                            .data;
                                    final f = filter.toLowerCase();
                                    if (f.isEmpty) return data;
                                    return data
                                        .where(
                                          (e) => e.tenPhong
                                              .toLowerCase()
                                              .contains(f),
                                        )
                                        .toList();
                                  }
                                  return [];
                                },
                                selectedItem: vm.selectedPhong,
                                itemAsString: (item) => item.tenPhong,
                                onChanged: (value) {
                                  vm.onSelectedPhong(value);
                                },
                              ),
                              if (vm.errPhong != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  vm.errPhong!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label("Người đại diện đứng tên hợp đồng"),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.green.shade200,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              "Chính chủ (>= 18 tuổi)",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      AbsorbPointer(
                        absorbing: isEditMode,
                        child: Opacity(
                          opacity: isEditMode ? 0.6 : 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomDropdownSearch<NguoiThueAvailableDTO>(
                                hintText: "Chọn người đại diện",
                                asyncItems: (filter) async {
                                  await vm.getAvailableRepresentatives();

                                  if (vm.representativesAvailable
                                      is HopDongSuccess<
                                        NguoiThueAvailableDTO
                                      >) {
                                    final data =
                                        (vm.representativesAvailable
                                                as HopDongSuccess<
                                                  NguoiThueAvailableDTO
                                                >)
                                            .data;
                                    final f = filter.toLowerCase();
                                    if (f.isEmpty) return data;
                                    return data
                                        .where(
                                          (e) => e.hoTen!
                                              .toLowerCase()
                                              .contains(f),
                                        )
                                        .toList();
                                  }

                                  if (vm.representativesAvailable
                                      is HopDongError) {
                                    final errorState =
                                        vm.representativesAvailable
                                            as HopDongError;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(errorState.errorMessage),
                                        backgroundColor: Colors.red.shade700,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return [];
                                  }
                                  return [];
                                },
                                selectedItem: vm.selectedNguoiThue,
                                itemAsString: (item) => item.hoTen ?? '',
                                onChanged: (value) {
                                  vm.onSelectedNguoiThue(value);
                                },
                              ),
                              if (vm.errNguoiThue != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  vm.errNguoiThue!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label("Thành viên ở cùng (Gia đình / Ở ghép)"),
                          InkWell(
                            onTap: () => _showThemThanhVienDialog(),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Color(0xff2E7D32),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "Thêm thành viên",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (vm.listThanhVienOChung.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            "Chưa có thành viên nào ở cùng ngoài người đại diện.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.listThanhVienOChung.length,
                          itemBuilder: (context, index) {
                            final tv = vm.listThanhVienOChung[index];
                            NguoiThueAvailableDTO nguoiThueObj =
                                tv['nguoiThue'];
                            String quanHe = tv['quanHe'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F9F5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 18,
                                    color: Color(0xff2E7D32),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nguoiThueObj.hoTen ?? '',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Quan hệ: $quanHe",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      vm.removeThanhVienOChung(index);
                                    },
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Ngày bắt đầu"),
                                const SizedBox(height: 6),
                                _dateField(
                                  vm.txtNgayKy,
                                  vm.errNgayKy,
                                  onTapCalendar: () {
                                    final now = DateTime.now();
                                    final today = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                    );
                                    final dauThang = DateTime(
                                      now.year,
                                      now.month,
                                      1,
                                    );

                                    if (isPendingContract) {
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: today,
                                      );
                                    } else if (isActiveContract) {
                                      DateTime ngayKyGoc =
                                          vm.hdDTO?.ngayKy ?? dauThang;
                                      DateTime minDate =
                                          (ngayKyGoc.year == now.year &&
                                              ngayKyGoc.month == now.month)
                                          ? ngayKyGoc.add(
                                              const Duration(days: 1),
                                            )
                                          : dauThang;
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: minDate,
                                        lastDate: today,
                                      );
                                    } else {
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: dauThang,
                                        lastDate: today.add(
                                          const Duration(days: 30),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Ngày hết hạn"),
                                const SizedBox(height: 6),
                                _dateField(
                                  vm.txtNgayHetHan,
                                  vm.errNgayHetHan,
                                  onTapCalendar: () {
                                    vm.chonNgay(context, vm.txtNgayHetHan);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Thiết lập giá thuê",
                  child: Column(
                    children: [
                      _label("Giá gốc của phòng thuê"),
                      _textfield(
                        controller: vm.txtTongGiaPhong,
                        hint: "0",
                        errorText: vm.errTongGiaPhong,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _label("Giá thuê của hợp đồng"),
                      _textfield(
                        controller: vm.txtGiaHopDong,
                        hint: "Nhập giá thuê hợp đồng",
                        errorText: vm.errGiaHopDong,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          DinhDangGiaVN(),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Cọc & ghi chú",
                  child: Column(
                    children: [
                      _label("Tiền cọc"),
                      _textfield(
                        controller: vm.txtTienCoc,
                        hint: "Nhập tiền cọc",
                        errorText: vm.errTienCoc,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          DinhDangGiaVN(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _label("Ghi chú"),
                      _textfield(
                        controller: vm.txtGhiChu,
                        hint: "Nhập ghi chú",
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _section(
                  title: "Ảnh hợp đồng",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vm.listImageContract.isEmpty)
                        InkWell(
                          onTap: vm.selectImageCotract,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F7F7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.grey.shade600,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Chạm để thêm ảnh hợp đồng",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ...List.generate(vm.listImageContract.length, (
                              index,
                            ) {
                              final file = vm.listImageContract[index];
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      file,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: InkWell(
                                      onTap: () =>
                                          vm.deleteImageContract(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            InkWell(
                              onTap: vm.selectImageCotract,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey.shade600,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (vm.errImageContract != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          vm.errImageContract!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        vm.createContractState is CreateContractLoading ||
                            vm.updateContractState is HopDongUpdateLoading
                        ? null
                        : () async {
                            if (!vm.kiemTraDuLieu()) return;
                            if (vm.isEdit) {
                              if (vm.hdDTO?.trangThai == 1) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AppConfirmDialog(
                                    title: "Cập nhật hợp đồng",
                                    content:
                                        "Lưu ý trước khi cập nhật hợp đồng\n\n"
                                        "- Hợp đồng hiện tại sẽ bị kết thúc và một hợp đồng mới sẽ được tạo để thay thế.\n\n"
                                        "- Tiền phòng kỳ này sẽ được hệ thống tự động chia theo số ngày ở thực tế của từng hợp đồng.",
                                    textConfirm: "Đồng ý",
                                    textCancel: "Hủy",
                                    isDangerous: false,
                                    customIcon: Icons.warning_amber_rounded,
                                    confirmColor: const Color(0xFFE65100),
                                    onConfirm: () =>
                                        Navigator.pop(context, true),
                                  ),
                                );
                                if (confirm == true) {
                                  await vm.updateHopDong();
                                }
                              } else {
                                await vm.updateHopDong();
                              }
                              if (!mounted) return;
                              if (vm.updateContractState
                                  is HopDongUpdateSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Cập nhật hợp đồng thành công!",
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                final updatedData =
                                    (vm.updateContractState
                                            as HopDongUpdateSuccess)
                                        .data;
                                if (vm.hdDTO?.trangThai == 0) {
                                  Navigator.pop(context, updatedData);
                                } else {
                                  Navigator.pop(context, true);
                                }
                              }
                              if (vm.updateContractState
                                  is HopDongUpdateError) {
                                final errorState =
                                    vm.updateContractState
                                        as HopDongUpdateError;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorState.errorMessage),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } else {
                              await vm.createHopDong();
                              if (!mounted) return;
                              if (vm.createContractState
                                  is CreateContractSuccess) {
                                await context
                                    .read<PhongProvider>()
                                    .getListPhong();
                                await context
                                    .read<NguoiThueProvider>()
                                    .fetchAll();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Tạo hợp đồng thành công!"),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pop(context, true);
                              }
                              if (vm.createContractState
                                  is CreateContractError) {
                                final errorState =
                                    vm.createContractState
                                        as CreateContractError;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorState.errorMessage),
                                    backgroundColor: Colors.red.shade700,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      vm.isEdit ? "Lưu thay đổi" : "Tạo hợp đồng",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // NÚT HỦY BỎ
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _hienThiXacNhanThoat(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC62828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Hủy bỏ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withOpacity(0.45),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Đang xử lý...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2E7D32),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _textfield({
    required TextEditingController controller,
    String? hint,
    String? errorText,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
    bool readOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          errorText: errorText,
          errorMaxLines: 2,
          hintText: hint,
          filled: true,
          fillColor: const Color(0xffF7F7F7),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff2D7A3A), width: 1.2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
        ),
      ),
    );
  }

  void _hienThiXacNhanThoat() async {
    if (!vm.coThayDoi) {
      Navigator.pop(context);
      return;
    }
    final confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AppConfirmDialog(
        title: "Thoát khỏi form?",
        content:
            "Dữ liệu bạn đã nhập sẽ bị mất nếu thoát.\nBạn có chắc chắn muốn thoát không?",
        textConfirm: "Thoát",
        textCancel: "Ở lại",
        isDangerous: true,
        onConfirm: () => Navigator.pop(dialogContext, true),
      ),
    );
    if (confirmDelete != true) return;
    if (confirmDelete == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget _dateField(
    TextEditingController controller,
    String? errorText, {
    bool disabled = false,
    VoidCallback? onTapCalendar,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [MaskedInputFormatter('##/##/####')],
      style: TextStyle(
        fontSize: 14,
        color: disabled ? Colors.black54 : Colors.black87,
      ),
      decoration: InputDecoration(
        errorText: errorText,
        errorMaxLines: 3,
        filled: true,
        fillColor: disabled ? const Color(0xffEEEEEE) : const Color(0xffF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: disabled
            ? null
            : IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: onTapCalendar,
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xffEAEAEA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xff2D7A3A), width: 1.2),
        ),
      ),
    );
  }
}
