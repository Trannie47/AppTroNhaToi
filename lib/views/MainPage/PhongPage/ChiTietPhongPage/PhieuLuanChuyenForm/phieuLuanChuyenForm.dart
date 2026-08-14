import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_luan_chuyen_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/phieuLuanChuyenFormViewModel.dart';
import 'package:AppTroNhaToi/models/phieu_luan_chuyen.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/ItemHopDong.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class PhieuLuanChuyenForm extends StatefulWidget {
  final PhieuLuanChuyen? item;
  final int? phongCuIdCoDinh;
  final String? tenPhongCu;

  const PhieuLuanChuyenForm({
    super.key,
    this.item,
    this.phongCuIdCoDinh,
    this.tenPhongCu,
  });
  @override
  State<PhieuLuanChuyenForm> createState() => _PhieuLuanChuyenFormState();
}

class _PhieuLuanChuyenFormState extends State<PhieuLuanChuyenForm> {
  late PhieuLuanChuyenFormViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = PhieuLuanChuyenFormViewModel(
      hopDongProvider: context.read<HopDongProvider>(),
      phongProvider: context.read<PhongProvider>(),
      phieuLuanChuyenProvider: context.read<PhieuLuanChuyenProvider>(),
    );

    vm.init(widget.item, phongCuIdCoDinh: widget.phongCuIdCoDinh);

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Future<void> _moDsNguoiThue() async {
    final hopDong = vm.hopDongDaChon;
    if (hopDong == null) return;

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Người thuê trong hợp đồng",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.star, color: Color(0xff2D7A3A)),
                title: Text(
                  hopDong.tenDaiDien ?? "Chưa rõ",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "Người thuê đại diện",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              if (hopDong.dsNguoiOGhep.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Không có người ở ghép",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
              else
                ...hopDong.dsNguoiOGhep.map(
                  (nt) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      nt.hoTen ?? "Chưa rõ",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      nt.quanHeVoiDaiDien ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Đóng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropDownHopDong() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hợp đồng",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 8),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomDropdownSearch<ItemHopDong>(
                hintText: "-- Chọn hợp đồng --",
                items: vm.dsHopDong,
                selectedItem: vm.dsHopDong
                    .where((e) => e.hopDongId == vm.hopDongDaChonId)
                    .cast<ItemHopDong?>()
                    .firstOrNull,
                itemAsString: (item) =>
                    "${item.hopDongId} - ${item.tenDaiDien ?? ''}",
                onChanged: (value) async {
                  await vm.chonHopDong(value?.hopDongId);
                },
              ),
            ),

            const SizedBox(width: 8),

            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: IconButton(
                onPressed: vm.hopDongDaChon == null ? null : _moDsNguoiThue,
                icon: const Icon(Icons.info, color: Color(0xff2D7A3A)),
                tooltip: "Xem người thuê trong hợp đồng",
              ),
            ),
          ],
        ),

        if (vm.errHopDong != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              vm.errHopDong!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _dropDownPhongMoi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownSearch<ItemPhongModel>(
          label: "Phòng mới",
          hintText: "-- Chọn phòng mới --",
          items: vm.dsPhongCoTheChon,
          selectedItem: vm.dsPhongCoTheChon
              .where((e) => e.phongId == vm.phongMoiDaChonId)
              .cast<ItemPhongModel?>()
              .firstOrNull,
          itemAsString: (item) => item.tenPhong,
          onChanged: (value) {
            vm.chonPhongMoi(value?.phongId);
          },
        ),

        if (vm.errPhongMoi != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              vm.errPhongMoi!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,

        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, color: Colors.black),
            ),
          ),
        ),

        titleSpacing: 12,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Phiếu luân chuyển",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            if (widget.tenPhongCu != null)
              Text(
                widget.tenPhongCu!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin luân chuyển",
                          style: TextStyle(
                            color: Color(0xff2D7A3A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),
                        _dropDownHopDong(),
                        const SizedBox(height: 18),
                        _dropDownPhongMoi(),
                        const SizedBox(height: 18),

                        _input(
                          title: "Ngày bắt đầu",
                          hint: "dd/MM/yyyy",
                          readOnly: true,
                          controller: vm.txtTuNgay,
                          errorText: vm.errTuNgay,
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter('##/##/####')],
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                            ),
                            onPressed: () async {
                              await vm.chonNgayBatDau(context, vm.txtTuNgay);
                            },
                          ),
                        ),

                        const SizedBox(height: 18),

                        _input(
                          title: "Ngày kết thúc",
                          hint: "dd/MM/yyyy",
                          readOnly: true,
                          controller: vm.txtDenNgay,
                          errorText: vm.errDenNgay,
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter('##/##/####')],
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                            ),
                            onPressed: () async {
                              await vm.chonNgayKetThuc(context, vm.txtDenNgay);
                            },
                          ),
                        ),

                        const SizedBox(height: 18),

                        _input(
                          title: "Lý do luân chuyển",
                          controller: vm.txtLyDo,
                          errorText: vm.errLyDo,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 18),

                        _input(
                          title: "Chi phí",
                          hint: "0",
                          controller: vm.txtChiPhi,
                          errorText: vm.errChiPhi,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DinhDangGiaVN(),
                          ],
                          suffixText: "Vnd",
                        ),

                        const SizedBox(height: 18),

                        _input(
                          title: "Ghi chú",
                          controller: vm.txtGhiChu,
                          errorText: vm.errGhiChu,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2D7A3A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: vm.isSaving
                ? null
                : () async {
                    final result = await vm.luu();

                    if (!mounted) return;

                    if (result != null) {
                      Navigator.pop(context, result);
                      return;
                    }

                    if (vm.errLuu != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(vm.errLuu!),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },

            child: vm.isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Lưu phiếu luân chuyển",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String title,
    String? hint,
    required TextEditingController controller,
    String? errorText,
    Widget? suffixIcon,
    String? suffixText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff4A4A4A),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            errorText: null,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xff2D7A3A)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }
}
