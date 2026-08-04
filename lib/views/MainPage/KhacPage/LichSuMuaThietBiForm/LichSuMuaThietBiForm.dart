import 'package:AppTroNhaToi/Provider/lich_su_mua_thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/models/lich_su_mua_thiet_bi.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/lichSuMuaThietBiForm/lichSuMuaThietBiFormViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LichSuMuaThietBiForm extends StatefulWidget {
  final ThietBi thietBi;
  final LichSuMuaThietBi? lichSuMua;

  const LichSuMuaThietBiForm({
    super.key,
    required this.thietBi,
    this.lichSuMua,
  });

  @override
  State<LichSuMuaThietBiForm> createState() => _LichSuMuaThietBiFormState();
}

class _LichSuMuaThietBiFormState extends State<LichSuMuaThietBiForm> {
  late LichSuMuaThietBiFormViewModel vm;
  final FocusNode _soLuongFocus = FocusNode();
  final FocusNode _donGiaFocus = FocusNode();
  final FocusNode _ghiChuFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    vm = LichSuMuaThietBiFormViewModel(
      context.read<LichSuMuaThietBiProvider>(),
      thietBi: widget.thietBi,
      lichSuInput: widget.lichSuMua,
    );

    for (final node in [_soLuongFocus, _donGiaFocus, _ghiChuFocus]) {
      node.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _soLuongFocus.dispose();
    _donGiaFocus.dispose();
    _ghiChuFocus.dispose();
    super.dispose();
  }

  Widget _input({
    required String title,
    required String hint,
    required TextEditingController controller,
    FocusNode? focusNode,
    String? errorText,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,

            decoration: InputDecoration(
              hintText: (focusNode?.hasFocus ?? false) ? null : hint,
              suffixIcon: suffixIcon,
              errorText: errorText,

              errorMaxLines: 2,
              errorStyle: const TextStyle(fontSize: 11, height: 1.2),

              filled: true,
              fillColor: const Color(0xffF8F8F8),

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
                borderSide: const BorderSide(color: Color(0xff2E7D32)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.lichSuMua != null;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 6,
        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),

          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xffF5F5F5),
              shape: BoxShape.circle,
            ),

            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            ),
          ),
        ),

        title: Text(
          isEdit ? "Sửa lịch sử mua" : "Thêm lịch sử mua",

          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xffE8F5E9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Thành tiền",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    formatMoney(
                      (int.tryParse(vm.txtSoLuong.text.trim()) ?? 0) *
                          (double.tryParse(
                                vm.txtDonGia.text.replaceAll(".", ""),
                              ) ??
                              0),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2D7A3A),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 55,
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2E7D32),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () async {
                  final result = await vm.luu();

                  setState(() {});

                  if (result != null && mounted) {
                    Navigator.pop(context, result);
                  }
                },

                child: Text(
                  isEdit ? "Cập nhật lịch sử mua" : "Lưu lịch sử mua",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Thông tin mua hàng",
                style: TextStyle(
                  color: Color(0xff2D7A3A),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.devices_other_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.thietBi.tenThietBi ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              _input(
                title: "Số lượng",
                hint: "VD: 5",
                controller: vm.txtSoLuong,
                focusNode: _soLuongFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                errorText: vm.errSoLuong,
                onChanged: (_) {
                  vm.errSoLuong = null;
                  setState(() {});
                },
              ),

              _input(
                title: "Đơn giá (đ)",
                hint: "0",
                controller: vm.txtDonGia,
                focusNode: _donGiaFocus,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DinhDangGiaVN(),
                ],
                errorText: vm.errDonGia,
                onChanged: (_) {
                  vm.errDonGia = null;
                  setState(() {});
                },
              ),

              _input(
                title: "Ngày mua",
                hint: "dd/MM/yyyy",
                controller: vm.txtNgayMua,
                readOnly: true,
                errorText: vm.errNgayMua,
                onTap: () async {
                  vm.errNgayMua = null;
                  await vm.chonNgayMua(context);
                  setState(() {});
                },
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              ),

              _input(
                title: "Ghi chú",
                hint: "VD: Mua tại cửa hàng ABC",
                controller: vm.txtGhiChu,
                focusNode: _ghiChuFocus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
