import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/hopDongForm/HopDongFormViewModel.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/hop_dong_provider.dart';
import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../Provider/phong_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../models/DTO/RoomAvailableDTO.dart';
import '../../../../states/create_contract_state.dart';
import '../../../../states/hop_dong_update_state.dart';
import '../../../../widgets/app_confirm_dialog.dart';

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
    final globalHopDongProvider = Provider.of<HopDongProvider>(context, listen: false);
    final globalNguoiThueProvider = Provider.of<NguoiThueProvider>(context, listen: false);
    vm = HopDongFormViewModel(globalHopDongProvider,globalNguoiThueProvider);
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
    final isLoading = vm.createContractState is CreateContractLoading|| vm.updateContractState is HopDongUpdateLoading;
    final bool isEditMode = vm.isEdit; // Khóa Phòng & Người thuê khi Edit
    final bool isActiveContract = vm.isEdit && vm.hdDTO?.trangThai == 1; // Khóa Ngày bắt đầu khi HĐ Đang hoạt động
    final bool isPendingContract = vm.isEdit && vm.hdDTO?.trangThai == 0; // HĐ Chờ hiệu lực
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
            title: Text( vm.isEdit? "Cập nhật hợp đồng":
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
                      AbsorbPointer(
                        absorbing: isEditMode,
                        child: Opacity(
                            opacity: isEditMode ? 0.6 : 1.0,
                            child: Builder(
                              builder: (context) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdownSearch<RoomAvailableDTO>(
                                      hintText: "Chọn phòng thuê",
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
                                        vm.onSelectedPhong(value);
                                      },
                                    ),
                                    if (vm.errPhong != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        vm.errPhong!,
                                        style: const TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    ],
                                  ],
                                );


                              },
                            ),
                        ),

                      ),

                      const SizedBox(height: 16),

                      _label("Người thuê"),
                      const SizedBox(height: 6),
                      AbsorbPointer(
                       absorbing: isEditMode,
                        child: Opacity(
                            opacity: isEditMode ? 0.6:1.0,
                          child: Builder(
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomDropdownSearch<NguoiThue>(
                                    hintText: "Chọn người thuê",
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
                                      vm.onSelectedNguoiThue(value);
                                    },

                                  ),
                                  if (vm.errNguoiThue != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      vm.errNguoiThue!,
                                      style: const TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ],
                                ],
                              );


                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Ngày bắt đầu"),
                                _dateField(
                                  vm.txtNgayKy,
                                  vm.errNgayKy,
                                  disabled: false,
                                  onTapCalendar: () {
                                    final now = DateTime.now();
                                    final today = DateTime(now.year, now.month, now.day);
                                    final dauThang = DateTime(now.year, now.month, 1);
                                    final cuoiThang = DateTime(now.year, now.month + 1, 0);

                                    if (isPendingContract) {
                                      // HĐ Chờ hiệu lực (trangThai == 0) -> Bắt đầu từ hôm nay trở đi
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: today,
                                      );
                                    } else if (isActiveContract) {
                                      // HĐ Đang hoạt động (trangThai == 1) -> CHỈ CHO CHỌN NGÀY TRONG THÁNG HIỆN TẠI
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: dauThang,
                                        lastDate: today,
                                      );
                                    } else {
                                      // Tạo mới HĐ -> Cho phép lùi về ngày 01 tháng này
                                      vm.chonNgay(
                                        context,
                                        vm.txtNgayKy,
                                        firstDate: dauThang,
                                        lastDate: today.add(const Duration(days: 30)), //Khóa lịch sau 30 ngày thì ko cho chọn nữa
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
                              border: Border.all(color: Colors.grey.shade300, width: 1.2),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.add_a_photo_outlined,
                                    color: Colors.grey.shade600, size: 28),
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
                            ...List.generate(vm.listImageContract.length, (index) {
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
                                      onTap: () => vm.deleteImageContract(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            size: 14, color: Colors.white),
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
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Icon(Icons.add,
                                    color: Colors.grey.shade600, size: 26),
                              ),
                            ),
                          ],
                        ),

                      if (vm.errImageContract != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          vm.errImageContract!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
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
                    onPressed: vm.createContractState is CreateContractLoading || vm.updateContractState is HopDongUpdateLoading
                        ? null // khoá nút khi đang gửi, tránh spam
                        : () async {
                      if (!vm.kiemTraDuLieu()) return;
                      if(vm.isEdit){
                        if (vm.hdDTO?.trangThai == 1) {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AppConfirmDialog(
                              title: "Cập nhật hợp đồng",
                              content: "Lưu ý trước khi cập nhật hợp đồng\n\n"
                                  "- Hợp đồng hiện tại sẽ bị kết thúc và một hợp đồng mới sẽ được tạo để thay thế.\n"
                                  "\n"
                                  "-Tiền phòng kỳ này sẽ được hệ thống tự động chia theo số ngày ở thực tế của từng hợp đồng.",
                              textConfirm: "Đồng ý",
                              textCancel: "Hủy",
                              isDangerous: false,
                              customIcon: Icons.warning_amber_rounded,
                              confirmColor: const Color(0xFFE65100),
                              onConfirm: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          );
                          if (confirm == true) {
                            await vm.updateHopDong();
                          }
                        } else {
                          // Nếu trạng thái là 0 (khởi tạo) thì update luôn
                          await vm.updateHopDong();
                        }
                        if (!mounted) return;
                        if (vm.updateContractState is HopDongUpdateSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cập nhật hợp đồng thành công!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );

                          final updatedData = (vm.updateContractState as HopDongUpdateSuccess).data;

                          if (vm.hdDTO?.trangThai == 0) {
                            // Trạng thái 0 trả về object mới để màn hình chi tiết tự cập nhật
                            Navigator.pop(context, updatedData);
                          } else {
                            // Trạng thái 1 tắt form với flag true, sau đó menu sẽ tắt ChiTietHopDongPage để về List
                            Navigator.pop(context, true);
                          }
                        }
                        if (vm.updateContractState is HopDongUpdateError) {
                          final errorState = vm.updateContractState as HopDongUpdateError;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorState.errorMessage),
                              backgroundColor: Colors.red.shade700,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }

                      }
                      else{
                        await vm.createHopDong();
                        if (!mounted) return;
                        if (vm.createContractState is CreateContractSuccess){
                          await context.read<PhongProvider>().getListPhong();
                          await context.read<NguoiThueProvider>().fetchAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tạo hợp đồng thành công!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pop(context,true); // Quay về màn hình danh sách hợp đồng
                        }
                        if (vm.createContractState is CreateContractError) {
                          final errorState = vm.createContractState as CreateContractError;
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
                    child: Text( vm.isEdit? "Lưu thay đổi":
                      "Tạo hợp đồng",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                     _hienThiXacNhanThoat();
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
        ),
        if (isLoading)
          AbsorbPointer(
            absorbing: true,// nếu đang loading thì chặn toàn bộ tương tác
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
          )
      ],/////

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
  void _hienThiXacNhanThoat()async {
    //Nếu chưa có dữ liệu trên form thì thoát luôn
    if (!vm.coThayDoi) {
      Navigator.pop(context);
      return;
    }
    final confirmDelete =await showDialog<bool>(
      context: context,
      barrierDismissible: false,// ngăn người dùng nhấn ra ngoài làm trả về null
      builder: (dialogContext) => AppConfirmDialog(
        title: "Thoát khỏi form?",
        content: "Dữ liệu bạn đã nhập sẽ bị mất nếu thoát.\nBạn có chắc chắn muốn thoát không?",
        textConfirm: "Thoát",
        textCancel: "Ở lại",
        isDangerous: true,
        onConfirm: () {
          Navigator.pop(dialogContext, true);
        },
      ),
    );
    if (confirmDelete != true) {
      return;
    }
    if(confirmDelete == true &&context.mounted){
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
      readOnly: true ,
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
  }}
