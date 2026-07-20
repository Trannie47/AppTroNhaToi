import 'package:flutter/material.dart';

/// Widget dùng chung để chọn tháng/năm, gọi được ở bất kỳ trang nào.
///
/// Không phụ thuộc vào ViewModel cụ thể nào — truyền [thangHienTai]/[namHienTai]
/// để hiển thị giá trị ban đầu, và [onApply] để nhận lại lựa chọn khi người
/// dùng bấm "Áp dụng".
///
/// Ví dụ dùng trong 1 trang bất kỳ:
/// ```dart
/// chonThangNam(
///   context,
///   thangHienTai: vm.thangChon,
///   namHienTai: vm.namChon,
///   onApply: (thang, nam) => vm.chonThangNam(thang, nam),
/// );
/// ```
Future<void> chonThangNam(
  BuildContext context, {
  required int thangHienTai,
  required int namHienTai,
  required void Function(int thang, int nam) onApply,
  int soNamHienThi = 6,
}) async {
  int thangTam = thangHienTai;
  int namTam = namHienTai;

  final namHienTaiHeThong = DateTime.now().year;
  final danhSachNam = List.generate(soNamHienThi, (i) => namHienTaiHeThong - i);

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Chọn tháng / năm",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tháng",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: thangTam,
                                items: List.generate(12, (i) => i + 1)
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          "Tháng ${t.toString().padLeft(2, '0')}",
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setModalState(() => thangTam = value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Năm",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8F8F8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: namTam,
                                items: danhSachNam
                                    .map(
                                      (n) => DropdownMenuItem(
                                        value: n,
                                        child: Text("$n"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setModalState(() => namTam = value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      onApply(thangTam, namTam);
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      "Áp dụng",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
