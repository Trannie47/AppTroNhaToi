import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LapRapFormDialog extends StatefulWidget {
  final int phongId;
  final LapRapPageModel?
  lapRapPageModel; // Nếu truyền lapRap -> Chế độ Sửa/Xóa. Nếu null -> Thêm mới
  final LapRapPageViewModel viewModel; // Nhận ViewModel từ UI

  const LapRapFormDialog({
    super.key,
    required this.phongId,
    this.lapRapPageModel,
    required this.viewModel,
  });

  @override
  State<LapRapFormDialog> createState() => _LapRapFormDialogState();
}

class _LapRapFormDialogState extends State<LapRapFormDialog> {
  ThietBiPageModel? _selectedThietBi;
  late int _soLuong;
  late DateTime _selectedDate;

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditMode => widget.lapRapPageModel != null;

  @override
  void initState() {
    super.initState();

    _soLuong = widget.lapRapPageModel?.lapRap.soLuong ?? 1;
    _selectedDate = widget.lapRapPageModel?.lapRap.ngayLap ?? DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThietBiProvider>().fetchAll();
    });
  }

  // Bật lịch chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff2D7A3A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThietBiProvider>();

    // Tìm thiết bị tương ứng trong kho tổng
    ThietBiPageModel? matchingModel;
    if (_isEditMode &&
        widget.lapRapPageModel?.lapRap.thietBi?.thietBiID != null) {
      try {
        matchingModel = provider.list.firstWhere(
          (e) =>
              e.thietBi.thietBiID ==
              widget.lapRapPageModel!.lapRap.thietBi!.thietBiID,
        );
      } catch (_) {}
    }

    // Tính số lượng tối đa có thể chọn
    final initialSoLuong = widget.lapRapPageModel?.lapRap.soLuong ?? 0;
    final int maxSoLuong = _isEditMode
        ? ((matchingModel?.soLuongConLai ?? 0) + initialSoLuong)
        : (_selectedThietBi?.soLuongConLai ?? 999);

    // Danh sách thiết bị còn hàng cho Dropdown
    final dsThietBiConHang = provider.list
        .where((item) => item.soLuongConLai > 0)
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TIÊU ĐỀ DIALOG
            Text(
              _isEditMode ? "Chỉnh sửa thiết bị" : "Thêm thiết bị vào phòng",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 16),

            // CHỌN THIẾT BỊ
            const Text(
              "Thiết bị",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),

            // Ở CHẾ ĐỘ SỬA: KHÓA TÊN THIẾT BỊ (CHỈ ĐỌC)
            if (_isEditMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xffEFEFEF)),
                ),
                child: Text(
                  widget.lapRapPageModel?.lapRap.thietBi?.tenThietBi ??
                      'Chưa rõ tên',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1C1C1E),
                  ),
                ),
              )
            else
              DropdownButtonFormField<ThietBiPageModel>(
                value: _selectedThietBi,
                hint: const Text(
                  "--Chọn thiết bị--",
                  style: TextStyle(color: Color(0xff8E8E93), fontSize: 14),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff8E8E93),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF8F9FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xff2D7A3A)),
                  ),
                ),
                items: dsThietBiConHang.map((item) {
                  return DropdownMenuItem<ThietBiPageModel>(
                    value: item,
                    child: Text(
                      item.thietBi.tenThietBi ?? 'Chưa rõ tên',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _isSubmitting
                    ? null
                    : (val) {
                        setState(() {
                          _selectedThietBi = val;
                          _errorMessage = null;
                        });
                      },
              ),

            const SizedBox(height: 16),

            // BỘ TĂNG GIẢM SỐ LƯỢNG
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Số lượng",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C1C1E),
                  ),
                ),
                if (_isEditMode && matchingModel != null)
                  Text(
                    "(Kho còn: ${matchingModel.soLuongConLai})",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff8E8E93),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffF8F9FA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffEFEFEF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút Giảm (-)
                  IconButton(
                    onPressed:
                        (_soLuong <= (_isEditMode ? 0 : 1) || _isSubmitting)
                        ? null
                        : () {
                            setState(() {
                              _soLuong--;
                              _errorMessage = null;
                            });
                          },
                    icon: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: _soLuong <= (_isEditMode ? 0 : 1)
                          ? Colors.grey.shade400
                          : Colors.red.shade600,
                    ),
                  ),

                  // Con số hiển thị
                  Text(
                    "$_soLuong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _soLuong == 0
                          ? Colors.red
                          : const Color(0xff1C1C1E),
                    ),
                  ),

                  // Nút Tăng (+)
                  IconButton(
                    onPressed: (_soLuong >= maxSoLuong || _isSubmitting)
                        ? null
                        : () {
                            setState(() {
                              _soLuong++;
                              _errorMessage = null;
                            });
                          },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: _soLuong >= maxSoLuong
                          ? Colors.grey.shade400
                          : const Color(0xff2D7A3A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CHỌN NGÀY LẮP
            const Text(
              "Ngày lắp",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _isSubmitting ? null : () => _selectDate(context),
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF8F9FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black87,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                  ),
                ),
                child: Text(
                  formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff1C1C1E),
                  ),
                ),
              ),
            ),

            // Thông báo lỗi
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFDF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffFADBD8)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xffD9534F),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffD9534F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffD0D5DD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff344054),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_isEditMode && _soLuong == 0)
                            ? Colors.red.shade700
                            : const Color(0xff437648),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isEditMode
                                  ? (_soLuong == 0
                                        ? "Xóa khỏi phòng"
                                        : "Cập nhật")
                                  : "Thêm",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction() async {
    //TRƯỜNG HỢP CHỈNH SỬA / XÓA (Khi nhấn vào item trong phòng)
    if (_isEditMode) {
      final lapRapId = widget.lapRapPageModel?.lapRap.id;
      if (lapRapId == null) {
        setState(() {
          _errorMessage = "Không tìm thấy mã lắp đặt!";
        });
        return;
      }

      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      try {
        await widget.viewModel.capNhatLapRap(id: lapRapId, soLuong: _soLuong);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString().replaceFirst('Exception: ', '');
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
      return;
    }

    // TRƯỜNG HỢP THÊM MỚI (Khi nhấn nút + Thêm ở góc trên)
    if (_selectedThietBi == null) {
      setState(() {
        _errorMessage = "Vui lòng chọn thiết bị!";
      });
      return;
    }

    final thietBiId = _selectedThietBi!.thietBi.thietBiID;
    if (thietBiId == null) return;

    if (_soLuong > _selectedThietBi!.soLuongConLai) {
      setState(() {
        _errorMessage =
            "Không đủ số lượng! Trong kho chỉ còn ${_selectedThietBi!.soLuongConLai} cái.";
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.viewModel.taoLapRap(
        thietBiId: thietBiId,
        soLuong: _soLuong,
        ngayLap: _selectedDate,
      );

      if (success && mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
