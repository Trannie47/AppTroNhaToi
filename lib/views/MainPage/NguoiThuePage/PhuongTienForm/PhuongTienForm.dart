import 'package:AppTroNhaToi/Provider/phuong_tien_provider.dart';
import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../modelviews/MainPage/NguoiThuePage/PhuongTienForm/PhuongTienForm.dart';

class PhuongTienForm extends StatefulWidget {
  final NguoiThue nguoiThue;
  final List<HopDong>? dsHopDong;
  final Function(PhuongTien)? onSave;
  final PhuongTien? phuongTienSua;

  const PhuongTienForm({
    super.key,
    required this.nguoiThue,
    this.dsHopDong,
    this.onSave,
    this.phuongTienSua,
  });

  @override
  State<PhuongTienForm> createState() => _PhuongTienFormState();
}

class _PhuongTienFormState extends State<PhuongTienForm> {
  late PhuongTienFormViewModel vm;

  List<HopDong> _listHopDong = [];
  bool _isLoadingRoom = false;

  @override
  void initState() {
    super.initState();
    vm = PhuongTienFormViewModel(phuongTienSua: widget.phuongTienSua);

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (widget.dsHopDong != null && widget.dsHopDong!.isNotEmpty) {
      _listHopDong = widget.dsHopDong!;
    } else {
      _fetchDsPhongByNguoiThue();
    }
  }

  Future<void> _fetchDsPhongByNguoiThue() async {
    final idnt = widget.nguoiThue.idnt;
    if (idnt == null) return;

    setState(() {
      _isLoadingRoom = true;
    });

    try {
      final dio = RetrofitClient().dio;
      final response = await dio.get("hop-dong/nguoi-thue/$idnt");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        if (mounted) {
          setState(() {
            _listHopDong = data.map((e) => HopDong.fromMap(e)).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Lỗi tải danh sách phòng trong PhuongTienForm: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRoom = false;
        });
      }
    }
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void _showSelectPhongBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chọn phòng liên quan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C1C1E),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.do_not_disturb_alt_rounded, color: Colors.orange),
                title: const Text("Chưa gán phòng", style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: vm.selectedPhongId == null
                    ? const Icon(Icons.check_circle_rounded, color: Color(0xff2D7A3A))
                    : null,
                onTap: () {
                  vm.selectPhong(null, null);
                  Navigator.pop(context);
                },
              ),
              if (_listHopDong.isNotEmpty)
                ..._listHopDong.map((hd) {
                  final phong = hd.phong;
                  final pId = phong?.phongID;
                  final tPhong = phong?.tenPhong ?? "??";

                  final isSelected = vm.selectedPhongId == pId;

                  return ListTile(
                    leading: Icon(
                      Icons.meeting_room_outlined,
                      color: isSelected ? const Color(0xff2D7A3A) : Colors.grey,
                    ),
                    title: Text(
                      "Phòng $tPhong",
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? const Color(0xff2D7A3A) : const Color(0xff1C1C1E),
                      ),
                    ),
                    subtitle: Text(
                      "Đang thuê từ ${hd.ngayKy != null ? hd.ngayKy.toString().split(' ')[0] : ''}",
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xff2D7A3A))
                        : null,
                    onTap: () {
                      vm.selectPhong(pId, tPhong);
                      Navigator.pop(context);
                    },
                  );
                }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _xuLyLuu() async {
    if (!vm.validateAll()) return;
    if (widget.nguoiThue.idnt == null) return;

    final provider = context.read<PhuongTienProvider>();
    bool success = await vm.savePhuongTien(
      provider: provider,
      idnt: widget.nguoiThue.idnt!,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              vm.isEditing
                  ? "Cập nhật phương tiện thành công!"
                  : "Thêm phương tiện mới thành công!",
            ),
            backgroundColor: const Color(0xff2D7A3A),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage ?? "Thao tác thất bại!"),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRoom = _listHopDong.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 72,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.isEditing ? "Cập nhật phương tiện" : "Thêm phương tiện",
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: Color(0xff1C1C1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 140),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Chủ phương tiện",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _title("Người thuê"),
                        Container(
                          width: double.infinity,
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F2F7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffEAEAEA)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.nguoiThue.hoTen ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1C1C1E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _title("Phòng liên quan"),
                        GestureDetector(
                          onTap: () {
                            if (_isLoadingRoom) return;

                            if (hasRoom) {
                              _showSelectPhongBottomSheet();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Người thuê này hiện chưa có hợp đồng thuê phòng nào!"),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xffEAEAEA)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _isLoadingRoom
                                      ? const Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xff2D7A3A),
                                      ),
                                    ),
                                  )
                                      : Text(
                                    vm.selectedTenPhong != null
                                        ? "Phòng ${vm.selectedTenPhong}"
                                        : "Chưa gán phòng",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: vm.selectedTenPhong != null
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: vm.selectedTenPhong != null
                                          ? const Color(0xff1C1C1E)
                                          : const Color(0xff8E8E93),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: hasRoom
                                      ? const Color(0xff2D7A3A)
                                      : Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Chọn phòng liên quan đến xe này. (Không bắt buộc)",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xffA0A0A0),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin xe",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _title("Loại xe"),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _itemLoaiXe(
                              title: "Xe máy",
                              value: 0,
                              icon: Icons.two_wheeler_rounded,
                            ),
                            const SizedBox(width: 10),
                            _itemLoaiXe(
                              title: "Ô tô",
                              value: 1,
                              icon: Icons.directions_car_filled_rounded,
                            ),
                            const SizedBox(width: 10),
                            _itemLoaiXe(
                              title: "Xe đạp",
                              value: 2,
                              icon: Icons.pedal_bike_rounded,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        _title("Hãng xe"),
                        _input(
                          controller: vm.txtHangXe,
                          hint: "VD: Honda, Yamaha...",
                          errorText: vm.errHangXe,
                        ),

                        const SizedBox(height: 18),
                        _title("Biển số xe"),
                        _input(
                          controller: vm.txtBienSo,
                          hint: "VD: 59B1-123.45",
                          errorText: vm.errBienSo,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Bắt buộc đối với ô tô và xe máy. Xe đạp có thể để trống.",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xffA0A0A0),
                          ),
                        ),

                        const SizedBox(height: 18),
                        _title("Màu sắc"),
                        _input(
                          controller: vm.txtMauSac,
                          hint: "VD: Đen, trắng...",
                          errorText: vm.errMauSac,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xffE8EEE8),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phí gửi xe",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2D7A3A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _title("Giá gửi xe mặc định"),
                        TextField(
                          controller: vm.txtGiaGui,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DinhDangGiaVN(),
                          ],
                          decoration: InputDecoration(
                            hintText: "0",
                            suffixText: "đ/tháng",
                            suffixStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff9E9E9E),
                            ),
                            errorText: vm.errGiaGui,
                            errorStyle: const TextStyle(color: Colors.red, fontSize: 11),
                            filled: true,
                            fillColor: const Color(0xffF8F8F8),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xffEAEAEA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xffEAEAEA)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xff2D7A3A),
                                width: 1.2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red, width: 1.2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Giá này sẽ tự điền khi tạo hóa đơn hàng tháng",
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: Color(0xffA0A0A0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: vm.isLoading ? null : _xuLyLuu,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff2D7A3A),
                disabledBackgroundColor: const Color(0xff2D7A3A).withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
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
                  : const Text(
                "Lưu phương tiện",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemLoaiXe({
    required String title,
    required int value,
    required IconData icon,
  }) {
    final isSelected = vm.loaiXe == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => vm.changeLoaiXe(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xffE8F5EA) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xff2D7A3A) : const Color(0xffEAEAEA),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xff2D7A3A) : const Color(0xff9E9E9E),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xff2D7A3A) : const Color(0xff7A7A7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff1C1C1E),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    String? hint,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xff9E9E9E),
        ),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 11),
        filled: true,
        fillColor: const Color(0xffF8F8F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xffEAEAEA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xffEAEAEA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xff2D7A3A),
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
      ),
    );
  }
}