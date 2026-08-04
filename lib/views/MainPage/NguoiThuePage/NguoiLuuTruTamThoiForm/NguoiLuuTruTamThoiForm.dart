import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/nguoi_luu_tru_tam_thoi_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../models/hop_dong.dart';
import '../../../../models/nguoi_luu_tru_tam_thoi.dart';
import '../../../../modelviews/MainPage/NguoiThuePage/NguoiLuuTruTamThoiForm/NguoiLuuTruTamThoiFormViewModel.dart';

class NguoiLuuTruTamThoiForm extends StatefulWidget {
  final int idnt;
  final String? tenNguoiThue;
  final List<HopDong> dsHopDong;
  final NguoiLuuTruTamThoi? itemEdit;

  const NguoiLuuTruTamThoiForm({
    super.key,
    required this.idnt,
    this.tenNguoiThue,
    this.dsHopDong = const [],
    this.itemEdit,
  });

  @override
  State<NguoiLuuTruTamThoiForm> createState() => _NguoiLuuTruTamThoiFormState();
}

class _NguoiLuuTruTamThoiFormState extends State<NguoiLuuTruTamThoiForm> {
  late NguoiLuuTruTamThoiFormViewModel vm;

  bool get _isEditMode => widget.itemEdit != null;

  @override
  void initState() {
    super.initState();

    vm = NguoiLuuTruTamThoiFormViewModel(
      context.read<NguoiLuuTruTamThoiProvider>(),
    );
    vm.initData(widget.itemEdit, widget.dsHopDong);

    vm.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  // Chọn ngày bằng hàm tiện ích chonNgayChuan
  Future<void> _selectDate(BuildContext context, bool isNgayDen) async {
    final initialDate = isNgayDen
        ? (vm.ngayDen ?? DateTime.now())
        : (vm.ngayVe ?? DateTime.now());

    final picked = await chonNgayChuan(
      context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      if (isNgayDen) {
        vm.setNgayDen(picked);
      } else {
        vm.setNgayVe(picked);
      }
    }
  }

  Future<void> _handleSave() async {
    if (!vm.validateAll()) return;

    try {
      final success = await vm.saveForm(
        idnt: widget.idnt,
        itemEdit: widget.itemEdit,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? "Cập nhật thông tin thành công"
                  : "Thêm người lưu trú thành công",
            ),
            backgroundColor: const Color(0xff437648),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String tenNguoiThueText =
        widget.tenNguoiThue ?? "Người thuê bảo lãnh";

    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xff1C1C1E),
              ),
            ),
          ),
        ),
        title: Text(
          _isEditMode ? "Chỉnh sửa lưu trú" : "Thêm lưu trú",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xff1C1C1E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCardSection(
              title: "Thông tin người lưu trú",
              children: [
                _buildInputField(
                  label: "Họ và tên",
                  hintText: "Nhập họ và tên",
                  controller: vm.hoTenController,
                  errorText: vm.errHoTen,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  label: "Mối quan hệ",
                  hintText: "VD: ba, mẹ, anh, chị, bạn...",
                  controller: vm.moiQuanHeController,
                  errorText: vm.errMoiQuanHe,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  label: "CCCD",
                  hintText: "Nhập số CCCD (12 số)",
                  controller: vm.cccdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  errorText: vm.errCccd,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  label: "Số điện thoại",
                  hintText: "VD: 0901 234 567",
                  controller: vm.sdtController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  errorText: vm.errSdt,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildCardSection(
              title: "Thông tin lưu trú",
              children: [
                _buildPhongDropdown(),
                const SizedBox(height: 14),

                _buildInputField(
                  label: "Người thuê bảo lãnh",
                  hintText: "",
                  readOnlyValue: tenNguoiThueText,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerBox(
                        label: "Ngày đến",
                        dateValue: formatDate(vm.ngayDen),
                        onTap: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDatePickerBox(
                        label: "Ngày về",
                        dateValue: formatDate(vm.ngayVe),
                        onTap: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff437648),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: vm.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _isEditMode
                            ? "Cập nhật thông tin"
                            : "Lưu người lưu trú",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhongDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Phòng lưu trú",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff1C1C1E),
              ),
            ),
            Text(
              " *",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: vm.selectedPhongId,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: "Chọn phòng lưu trú",
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xffC7C7CC),
              fontWeight: FontWeight.w400,
            ),
            errorText: vm.errPhong,
            fillColor: const Color(0xffF8F9FA),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE5E5EA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff437648),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          items: widget.dsHopDong.map((hd) {
            final pId = hd.phongID;
            final tenPhong = hd.phong?.tenPhong ?? "$pId";

            return DropdownMenuItem<int>(
              value: pId,
              child: Text(
                "Phòng $tenPhong",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1C1C1E),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => vm.setPhongId(val),
        ),
      ],
    );
  }

  Widget _buildCardSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff437648),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    String? readOnlyValue,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final bool isReadOnly = readOnlyValue != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff1C1C1E),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: isReadOnly ? null : controller,
          readOnly: isReadOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff1C1C1E),
          ),
          decoration: InputDecoration(
            hintText: isReadOnly ? readOnlyValue : hintText,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xffC7C7CC),
              fontWeight: FontWeight.w400,
            ),
            errorText: errorText,
            fillColor: const Color(0xffF8F9FA),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE5E5EA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff437648),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerBox({
    required String label,
    required String dateValue,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff1C1C1E),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffE5E5EA)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateValue.isEmpty ? "Chọn ngày" : dateValue,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1C1C1E),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Color(0xff8E8E93),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
