import 'package:AppTroNhaToi/Provider/lap_rap_thietbi_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Provider/thiet_bi_provider.dart';
import '../../../KhacPage/ThietBiPage/thietBiPageModel.dart';

class ThemThietBiPhongDialog extends StatefulWidget {
  final int phongId;

  const ThemThietBiPhongDialog({
    super.key,
    required this.phongId,
  });

  @override
  State<ThemThietBiPhongDialog> createState() => _ThemThietBiPhongDialogState();
}

class _ThemThietBiPhongDialogState extends State<ThemThietBiPhongDialog> {
  ThietBiPageModel? _selectedThietBi;
  final TextEditingController _soLuongController = TextEditingController(text: "1");
  DateTime _selectedDate = DateTime.now();

  // Biến trạng thái đang gửi API
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Tải danh sách thiết bị tổng từ Provider nếu chưa load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ThietBiProvider>();
      if (provider.list.isEmpty) {
        provider.fetchAll();
      }
    });
  }

  @override
  void dispose() {
    _soLuongController.dispose();
    super.dispose();
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xff2D7A3A),
            ),
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThietBiProvider>();
    final dsThietBi = provider.list;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. CHỌN THIẾT BỊ
            const Text(
              "Thiết bị",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<ThietBiPageModel>(
              value: _selectedThietBi,
              hint: const Text(
                "--Thiết bị--",
                style: TextStyle(color: Color(0xff8E8E93), fontSize: 14),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xff8E8E93)),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8F9FA),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              items: dsThietBi.map((item) {
                return DropdownMenuItem<ThietBiPageModel>(
                  value: item,
                  child: Text(
                    item.thietBi.tenThietBi ?? 'Chưa rõ tên',
                    style: const TextStyle(fontSize: 14, color: Color(0xff1C1C1E)),
                  ),
                );
              }).toList(),
              onChanged: _isSubmitting
                  ? null
                  : (val) {
                setState(() {
                  _selectedThietBi = val;
                });
              },
            ),

            const SizedBox(height: 16),

            /// 2. NHẬP SỐ LƯỢNG
            const Text(
              "Số lượng",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xff1C1C1E),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _soLuongController,
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, color: Color(0xff1C1C1E)),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8F9FA),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

            /// 3. CHỌN NGÀY LẮP
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  _formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff1C1C1E),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 4. HÀNG NÚT [ HỦY ] VÀ [ THÊM ]
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                        // Validate chọn thiết bị
                        if (_selectedThietBi == null) {
                          return;
                        }

                        final thietBiId = _selectedThietBi!.thietBi.thietBiID;
                        if (thietBiId == null) {
                          return;
                        }

                        final soLuong = int.tryParse(_soLuongController.text) ?? 1;

                        // Bật trạng thái Loading
                        setState(() {
                          _isSubmitting = true;
                        });

                        try {
                          final lapRapProvider = context.read<LapRapThietbiProvider>();
                          final result = await lapRapProvider.taoLapRap(
                            phongId: widget.phongId,
                            thietBiId: thietBiId,
                            soLuong: soLuong,
                            ngayLap: _selectedDate,
                          );

                          if (result != null && mounted) {
                            // 🔥 Đóng Dialog và trả về true để màn hình chính xử lý UI
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          if (mounted) {
                            // Nếu có lỗi, đóng dialog và trả về null/false
                            Navigator.pop(context, false);
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      },
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
                          : const Text(
                        "Thêm",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}