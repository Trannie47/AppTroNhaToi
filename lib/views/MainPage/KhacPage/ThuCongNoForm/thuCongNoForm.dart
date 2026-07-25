import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phieu_thu_hoa_don_tap_hoa_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThuCongNoForm/thuCongNoFormModel.dart';
import 'package:AppTroNhaToi/widgets/CustomDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ThuCongNoForm extends StatefulWidget {
  const ThuCongNoForm({super.key});

  @override
  State<ThuCongNoForm> createState() => _ThuCongNoFormState();
}

class _ThuCongNoFormState extends State<ThuCongNoForm> {
  late ThuCongNoFormViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = ThuCongNoFormViewModel(
      context.read<PhieuThuHdThProvider>(),
      context.read<NguoiThueProvider>(),
    );

    vm.addListener(() {
      if (mounted) setState(() {});
    });

    Future.microtask(() => vm.init());
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final ok = await vm.thuCongNo();

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Thu công nợ thành công")));
      Navigator.pop(context, true);
      return;
    }

    if (vm.errNguoiThue != null ||
        (vm.formKey.currentState?.validate() == false)) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Thu công nợ thất bại")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thu công nợ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xffECECEC))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text("Tổng công nợ", style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  Text(
                    NumberFormat.currency(
                      locale: "vi_VN",
                      symbol: "đ",
                      decimalDigits: 0,
                    ).format(vm.tongCongNo),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xffD84315),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2D7A3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: vm.isLoading ? null : save,
                  child: vm.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Thu công nợ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Form(
        key: vm.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _section(
                title: "Thông tin thanh toán",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Người thuê",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 10),

                    CustomDropdownSearch<ThuCongNoFormModel>(
                      label: "Người thuê",
                      hintText: "-- Chọn người thuê --",
                      items: vm.listNguoiThue,
                      selectedItem: vm.nguoiThue,
                      itemAsString: (item) => item.nguoiThue.hoTen ?? "",

                      onChanged: (value) {
                        vm.chonNguoiThue(value);
                      },
                      errorText: vm.errNguoiThue,
                    ),

                    const SizedBox(height: 20),

                    _input(
                      title: "Số tiền thu",
                      controller: vm.txtSoTien,
                      hint: "Nhập số tiền",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DinhDangGiaVN(),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _datePicker(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  Widget _input({
    required String title,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xffF4F4F4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
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
              borderSide: const BorderSide(color: Color(0xff2D7A3A)),
            ),
          ),
          validator: (_) => vm.validateSoTien(),
        ),
      ],
    );
  }

  Widget _datePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ngày thu", style: TextStyle(fontWeight: FontWeight.w500)),

        const SizedBox(height: 10),

        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => vm.chonNgayThu(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xffF4F4F4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    vm.txtNgayThu.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(Icons.calendar_month, color: Color(0xff2D7A3A)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
