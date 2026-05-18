
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/widget/itemPhuongTien.dart';
import 'package:flutter/material.dart';

class PhuongTienNguoiThuePage extends StatefulWidget {
  final NguoiThue nguoiThue;

  final List<PhuongTien> dsPhuongTien;

  const PhuongTienNguoiThuePage({
    super.key,
    required this.nguoiThue,
    required this.dsPhuongTien,
  });

  @override
  State<PhuongTienNguoiThuePage> createState() =>
      _PhuongTienNguoiThuePageState();
}

class _PhuongTienNguoiThuePageState
    extends State<PhuongTienNguoiThuePage> {
  late List<PhuongTien> dsPhuongTien;

  @override
  void initState() {
    super.initState();

    dsPhuongTien = widget.dsPhuongTien;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 61,
              color: Colors.white,

              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(
                      width: 36,
                      height: 36,

                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      alignment: Alignment.center,

                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// TITLE
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Phương tiện",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1C1C1E),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "${widget.nguoiThue.hoTen ?? ""} · ${dsPhuongTien.length} xe",

                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xff8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},

                    child: Container(
                      width: 36,
                      height: 36,

                      decoration: BoxDecoration(
                        color: const Color(0xffEEF5EF),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      alignment: Alignment.center,

                      child: const Icon(
                        Icons.add_business_rounded,
                        size: 18,
                        color: Color(0xff2D7A3A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  120,
                ),

                children: [

                  /// XE MÁY
                  if(dsPhuongTien.where((e) => e.loaiXe == 0).isNotEmpty)
                    _groupXe(
                      title: "Xe máy",
                      dsXe:
                      dsPhuongTien.where((e) => e.loaiXe == 0).toList(),
                    ),

                  /// Ô TÔ
                  if(dsPhuongTien.where((e) => e.loaiXe == 1).isNotEmpty)
                    _groupXe(
                      title: "Xe ô tô",
                      dsXe:
                      dsPhuongTien.where((e) => e.loaiXe == 1).toList(),
                    ),

                  /// XE ĐẠP ĐIỆN
                  if(dsPhuongTien.where((e) => e.loaiXe == 2).isNotEmpty)
                    _groupXe(
                      title: "Xe đạp điện",
                      dsXe:
                      dsPhuongTien.where((e) => e.loaiXe == 2).toList(),
                    ),
                ],
              ),
            ),

          ],
        ),
      ),

      /// BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),

          child: SizedBox(
            height: 48,

            child: OutlinedButton(
              onPressed: () {},

              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xffF7FFF8),

                side: const BorderSide(
                  color: Color(0xffB7D8BC),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 18,
                    color: Color(0xff2D7A3A),
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Thêm phương tiện",

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2D7A3A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _groupXe({
    required String title,
    required List<PhuongTien> dsXe,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        /// TITLE
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
            top: 8,
          ),

          child: Text(
            "$title (${dsXe.length})",

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff2D7A3A),
            ),
          ),
        ),

        /// LIST XE
        ...List.generate(dsXe.length, (index) {

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),

            child: ItemPhuongTien(

              phuongTien: dsXe[index],

              delete: () {

                setState(() {

                  dsPhuongTien.remove(dsXe[index]);

                });

              },

              edit: () {

                final txtHangXe =
                TextEditingController(
                  text: dsXe[index].hangXe,
                );

                final txtBienSo =
                TextEditingController(
                  text: dsXe[index].bienSo,
                );

                final txtMauSac =
                TextEditingController(
                  text: dsXe[index].mauSac,
                );

                final txtGiaGui =
                TextEditingController(
                  text:
                  dsXe[index].giaGui.toString(),
                );


                showDialog(

                  context: context,

                  builder: (dialogContext) {

                    return AlertDialog(

                      shape: RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(24),
                      ),

                      title: const Center(

                        child: Text(

                          "Sửa phương tiện",

                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      content: SingleChildScrollView(

                        child: Column(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            TextField(

                              controller: txtHangXe,

                              decoration: const InputDecoration(
                                labelText: "Hãng xe",
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(

                              controller: txtBienSo,

                              decoration: const InputDecoration(
                                labelText: "Biển số",
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(

                              controller: txtMauSac,

                              decoration: const InputDecoration(
                                labelText: "Màu sắc",
                              ),
                            ),

                            const SizedBox(height: 14),

                            TextField(

                              controller: txtGiaGui,

                              decoration: const InputDecoration(
                                labelText: "Giá gửi",
                              ),
                            ),

                            const SizedBox(height: 22),

                            SizedBox(

                              width: double.infinity,

                              height: 48,

                              child: ElevatedButton(

                                onPressed: () {

                                  setState(() {

                                    final xeMoi =
                                    dsXe[index].copyWith(

                                      hangXe:
                                      txtHangXe.text,

                                      bienSo:
                                      txtBienSo.text,

                                      mauSac:
                                      txtMauSac.text,

                                      giaGui:
                                      double.tryParse(
                                        txtGiaGui.text,
                                      ) ?? 0,
                                    );



                                    final viTri =
                                    dsPhuongTien.indexOf(
                                      dsXe[index],
                                    );



                                    dsPhuongTien[viTri] =
                                        xeMoi;
                                  });

                                  Navigator.pop(dialogContext);
                                },

                                child: const Text(
                                  "Lưu thay đổi",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

              },
            ),
          );
        }),
      ],
    );
  }
}