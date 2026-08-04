import 'package:AppTroNhaToi/Provider/thiet_bi_provider.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/ThietBiPage/thietBiPageModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/ThietBiPhongPage/ThietBiPhongPageModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThietBiPhongFormDialog extends StatefulWidget {
  final int phongId;

  final ThietBiPhongPageModel? item;
  final ThietBiPhongPageViewModel viewModel;

  const ThietBiPhongFormDialog({
    super.key,
    required this.phongId,
    this.item,
    required this.viewModel,
  });

  @override
  State<ThietBiPhongFormDialog> createState() => _ThietBiPhongFormDialogState();
}

class _ThietBiPhongFormDialogState extends State<ThietBiPhongFormDialog> {
  ThietBiPageModel? _selectedThietBi;
  late DateTime _selectedDate;
  late TextEditingController _ghiChuController;

  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.item?.lapRap.ngayLap ?? DateTime.now();
    _ghiChuController = TextEditingController(
      text: widget.item?.lapRap.ghiChu ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThietBiProvider>().fetchAll();
    });
  }

  @override
  void dispose() {
    _ghiChuController.dispose();
    super.dispose();
  }

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
            Text(
              _isEditMode ? "Chỉnh sửa thiết bị" : "Thêm thiết bị vào phòng",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Thiết bị",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),

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
                  widget.item?.lapRap.thietBi?.tenThietBi ?? 'Chưa rõ tên',
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

            const Text(
              "Ghi chú",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _ghiChuController,
              enabled: !_isSubmitting,
              maxLines: 3,
              onChanged: (_) => setState(() => _errorMessage = null),
              decoration: InputDecoration(
                hintText: "Nhập ghi chú (nếu có)",
                hintStyle: const TextStyle(
                  color: Color(0xff8E8E93),
                  fontSize: 14,
                ),
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
            ),

            const SizedBox(height: 16),

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
                        backgroundColor: const Color(0xff437648),
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
                              _isEditMode ? "Cập nhật" : "Thêm",
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
    // CHẾ ĐỘ SỬA (cập nhật ghi chú / ngày lắp)
    if (_isEditMode) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      try {
        await widget.viewModel.capNhatThietBi(
          item: widget.item!,
          ghiChu: _ghiChuController.text,
          ngayLap: _selectedDate,
        );

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

    // CHẾ ĐỘ THÊM MỚI
    if (_selectedThietBi == null) {
      setState(() {
        _errorMessage = "Vui lòng chọn thiết bị!";
      });
      return;
    }

    final thietBiId = _selectedThietBi!.thietBi.thietBiID;
    if (thietBiId == null) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.viewModel.themThietBi(
        thietBiId: thietBiId,
        ghiChu: _ghiChuController.text,
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
