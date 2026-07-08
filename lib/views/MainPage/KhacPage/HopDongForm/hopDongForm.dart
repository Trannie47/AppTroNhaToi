import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/hopDongForm/HopDongFormViewModel.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../../models/DTO/RoomAvailableDTO.dart';

class HopDongForm extends StatefulWidget {
  final HopDong? hopDong;

  const HopDongForm({super.key, this.hopDong});

  @override
  State<HopDongForm> createState() => _TaoHopDongPageState();
}

class _TaoHopDongPageState extends State<HopDongForm> {
  late HopDongFormViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = HopDongFormViewModel();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onTap: () => Navigator.pop(context),
                child: const Center(
                  child: Icon(Icons.arrow_back_ios_new, size: 14),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Tạo hợp đồng",
          style: TextStyle(
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
                  Builder(
                      builder: (context) {
                        return CustomDropdownSearch<RoomAvailableDTO>(
                          asyncItems: (filter) async {
                            if (vm.roomsAvailable is! HopDongSuccess<RoomAvailableDTO>) {
                              await vm.getRoomsAvailableForContract();
                            }

                            //Nếu gọi xong mà dính lỗi, bắn SnackBar thông báo và trả về mảng rỗng để không bung menu lỗi
                            if (vm.roomsAvailable is HopDongError) {
                              final errorState = vm.roomsAvailable as HopDongError;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorState.errorMessage),
                                  backgroundColor: Colors.red.shade700,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return [];
                            }

                            // Nếu thành công, trả về list data từ Server để Dropdown tự động vẽ lên màn hình
                            if (vm.roomsAvailable is HopDongSuccess<RoomAvailableDTO>) {
                              final data = (vm.roomsAvailable as HopDongSuccess<RoomAvailableDTO>).data;

                              // lọc chữ tìm kiếm theo tên phòng
                              final f = filter.toLowerCase();
                              if (f.isEmpty) return data;
                              return data.where((e) => e.tenPhong.toLowerCase().contains(f)).toList();
                            }

                            return [];
                          },

                          selectedItem: vm.selectedPhong,
                          itemAsString: (item) => item.tenPhong,
                          onChanged: (value) {
                            setState(() {
                              vm.selectedPhong = value;
                              vm.onSelectedPhong(value);
                            });
                          },
                        );

                      },
                   ),

                  const SizedBox(height: 16),

                  _label("Người thuê"),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      return CustomDropdownSearch<NguoiThue>(
                        asyncItems: (filter) async {
                          if (vm.tenantsAvailable is! HopDongSuccess<NguoiThue>) {
                            await vm.getNguoiThueAvailableForContract();
                          }

                          //Nếu gọi xong mà dính lỗi, bắn SnackBar thông báo và trả về mảng rỗng để không bung menu lỗi
                          if (vm.tenantsAvailable is HopDongError) {
                            final errorState = vm.tenantsAvailable as HopDongError;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorState.errorMessage),
                                backgroundColor: Colors.red.shade700,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return [];
                          }

                          // Nếu thành công, trả về list data từ Server để Dropdown tự động vẽ lên màn hình
                          if (vm.tenantsAvailable is HopDongSuccess<NguoiThue>) {
                            final data = (vm.tenantsAvailable as HopDongSuccess<NguoiThue>).data;

                            //lọc chữ tìm kiếm theo tên phòng
                            final f = filter.toLowerCase();
                            if (f.isEmpty) return data;
                            return data.where((e) => e.hoTen!.toLowerCase().contains(f)).toList();
                          }

                          return [];
                        },

                        selectedItem: vm.selectedNguoiThue,
                        itemAsString: (item) => item.hoTen!,
                        onChanged: (value) {
                          setState(() {
                            vm.selectedNguoiThue = value;
                          });
                        },
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
                            _label("Ngày ký"),
                            _dateField(vm.txtNgayKy, vm.errNgayKy),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Ngày hết hạn"),
                            _dateField(vm.txtNgayHetHan, vm.errNgayHetHan),
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
                    ],
                  ),

                  const SizedBox(height: 16),



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

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  bool hopLe = vm.kiemTraDuLieu();

                  if (!hopLe) {
                    return;
                  }

                  print("Lưu hợp đồng");
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tạo hợp đồng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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

  Widget _dateField(TextEditingController controller, String? errorText) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [MaskedInputFormatter('##/##/####')],
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        errorText: errorText,
        errorMaxLines: 2,
        filled: true,
        fillColor: const Color(0xffF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () {
            vm.chonNgay(context, controller);
          },
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
