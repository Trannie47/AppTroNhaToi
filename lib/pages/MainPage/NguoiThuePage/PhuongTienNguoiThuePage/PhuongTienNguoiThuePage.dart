import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/PhuongTienForm/PhuongTienForm.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePage.dart';
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

  void themPhuongTien() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => ThemPhuongTienPage(

          nguoiThue: widget.nguoiThue,

          onSave: (xeMoi) {

            setState(() {

              dsPhuongTien.add(xeMoi);

            });
          },
        ),
      ),
    );
  }

  void openHoaDonGuiXe() {

    Navigator.push(

      context,

      MaterialPageRoute(
        builder: (_) => HoaDonGuiXePage(

          dsPhuongTien: dsPhuongTien,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF7F9F7),

      body: SafeArea(

        child: Column(

          children: [


            /// HEADER
            Container(

              height: 62,

              color: Colors.white,

              padding: const EdgeInsets.only(
                left: 20,
                right: 16,
              ),

              child: Row(
                children: [

                  /// BACK
                  GestureDetector(

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: Container(

                      width: 30,
                      height: 30,

                      decoration: BoxDecoration(

                        color:
                        const Color(0xffF5F5F5),

                        borderRadius:
                        BorderRadius.circular(15),
                      ),

                      alignment: Alignment.center,

                      child: const Icon(

                        Icons.arrow_back_ios_new_rounded,

                        size: 13,

                        color: Color(0xff1C1C1E),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// TITLE
                  Expanded(

                    child: Container(
                     color: Colors.white,
                      child: Column(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Phương tiện",

                            style: TextStyle(

                              fontSize: 21,

                              fontWeight:
                              FontWeight.w700,

                              height: 1,

                              color:
                              Color(0xff1C1C1E),
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(

                            widget.nguoiThue.hoTen ?? "",

                            style: const TextStyle(

                              fontSize: 14,

                              fontWeight:
                              FontWeight.w400,

                              height: 1,

                              color:
                              Color(0xff8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ADD
                  GestureDetector(

                    onTap: openHoaDonGuiXe,

                    child: Container(

                      width: 32,
                      height: 32,

                      decoration: BoxDecoration(

                        color:
                        const Color(0xffEEF5EF),

                        borderRadius:
                        BorderRadius.circular(5),
                      ),

                      alignment: Alignment.center,

                      child:  Image.asset(
                        "assets/images/chitiethd.png"
                        ,width: 25,
                        height: 25,

                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(

              child: ListView(

                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  110,
                ),

                children: [

                  /// XE MÁY
                  if(dsPhuongTien
                      .where(
                        (e) =>
                    e.loaiXe == 0,
                  )
                      .isNotEmpty)

                    _groupXe(

                      title: "Xe máy",

                      dsXe:
                      dsPhuongTien
                          .where(
                            (e) =>
                        e.loaiXe == 0,
                      )
                          .toList(),
                    ),

                  /// Ô TÔ
                  if(dsPhuongTien
                      .where(
                        (e) =>
                    e.loaiXe == 1,
                  )
                      .isNotEmpty)

                    _groupXe(

                      title: "Xe ô tô",

                      dsXe:
                      dsPhuongTien
                          .where(
                            (e) =>
                        e.loaiXe == 1,
                      )
                          .toList(),
                    ),

                  /// XE ĐẠP
                  if(dsPhuongTien
                      .where(
                        (e) =>
                    e.loaiXe == 2,
                  )
                      .isNotEmpty)

                    _groupXe(

                      title: "Xe đạp",

                      dsXe:
                      dsPhuongTien
                          .where(
                            (e) =>
                        e.loaiXe == 2,
                      )
                          .toList(),
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

          padding:
          const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            14,
          ),

          child: SizedBox(

            height: 56,

            child: ElevatedButton(

              onPressed: themPhuongTien,

              style:
              ElevatedButton.styleFrom(

                elevation: 0,

                backgroundColor:
                const Color(
                  0xff2D7A3A,
                ),

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),

              child: const Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(

                    Icons.add_rounded,

                    size: 18,

                    color: Colors.white,
                  ),

                  SizedBox(width: 8),

                  Text(

                    "Thêm phương tiện",

                    style: TextStyle(

                      fontSize: 15,

                      fontWeight:
                      FontWeight.w700,

                      color: Colors.white,
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

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Padding(

          padding:
          const EdgeInsets.only(
            bottom: 12,
            top: 4,
          ),

          child: Text(

            "$title (${dsXe.length})",

            style: const TextStyle(

              fontSize: 17,

              fontWeight:
              FontWeight.w700,

              color:
              Color(0xff2D7A3A),
            ),
          ),
        ),

        ...List.generate(

          dsXe.length,

              (index) {

            final xe = dsXe[index];

            return Padding(

              padding:
              const EdgeInsets.only(
                bottom: 14,
              ),

              child: ItemPhuongTien(

                phuongTien: xe,

                delete: () {

                  setState(() {

                    dsPhuongTien.remove(
                      xe,
                    );
                  });
                },

                edit: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => ThemPhuongTienPage(

                        nguoiThue: widget.nguoiThue, phuongTienSua: xe,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}