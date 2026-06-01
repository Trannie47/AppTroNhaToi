import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/widget/itemHoaDonGuiXe.dart';
import 'package:flutter/material.dart';

class HoaDonGuiXePage extends StatefulWidget {

  final List<PhuongTien> dsPhuongTien;

  const HoaDonGuiXePage({
    super.key,
    required this.dsPhuongTien,
  });

  @override
  State<HoaDonGuiXePage> createState() =>
      _HoaDonGuiXePageState();
}

class _HoaDonGuiXePageState
    extends State<HoaDonGuiXePage> {

  String namDangChon = "2025";

  final List<String> dsNam = [
    "2026",
    "2025",
    "2024",
  ];

  final List<HoaDonGuiXe> dsHoaDon = [

    HoaDonGuiXe(
      maHoaDon: 1,
      thangNam: "T5/2025",
      trangThai: 0,
      idPhuongTien: 1,
    ),

    HoaDonGuiXe(
      maHoaDon: 2,
      thangNam: "T4/2025",
      trangThai: 1,
      idPhuongTien: 2,
    ),

    HoaDonGuiXe(
      maHoaDon: 3,
      thangNam: "T3/2025",
      trangThai: 1,
      idPhuongTien: 3,
    ),

    HoaDonGuiXe(
      maHoaDon: 4,
      thangNam: "T2/2025",
      trangThai: 1,
      idPhuongTien: 4,
    ),

    HoaDonGuiXe(
      maHoaDon: 5,
      thangNam: "T1/2025",
      trangThai: 1,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 6,
      thangNam: "T2/2026",
      trangThai: 0,
      idPhuongTien: 4,
    ),

    HoaDonGuiXe(
      maHoaDon: 7,
      thangNam: "T1/2026",
      trangThai: 1,
      idPhuongTien: 4,
    ),
    HoaDonGuiXe(
      maHoaDon: 8,
      thangNam: "T2/2024",
      trangThai: 0,
      idPhuongTien: 4,
    ),

    HoaDonGuiXe(
      maHoaDon: 9,
      thangNam: "T1/2024",
      trangThai: 1,
      idPhuongTien: 4,
    ),
  ];

  /// LỌC THEO NĂM
  List<HoaDonGuiXe> get dsHoaDonTheoNam {

    return dsHoaDon.where((e) {

      if(e.thangNam == null) {
        return false;
      }

      return e.thangNam!
          .contains(namDangChon);

    }).toList();
  }

  /// TỔNG XE
  int get tongSoXe {

    return widget.dsPhuongTien.length;
  }

  /// TỔNG TIỀN THÁNG
  double get tongTienThang {

    double tong = 0;

    for(final xe in widget.dsPhuongTien) {

      tong += xe.giaGui ?? 0;
    }

    return tong;
  }

  /// DS HÓA ĐƠN CHƯA THU
  List<HoaDonGuiXe> get dsHoaDonNo {

    return dsHoaDon.where(
          (e) => e.trangThai == 0,
    ).toList();
  }

  /// TÌM XE
  PhuongTien? getXeTheoHoaDon(
      HoaDonGuiXe hoaDon,
      ) {

    final dsXeTimDuoc =
    widget.dsPhuongTien.where(
          (e) =>
      e.ID ==
          hoaDon.idPhuongTien,
    ).toList();

    if(dsXeTimDuoc.isEmpty) {

      return null;
    }

    return dsXeTimDuoc.first;
  }

  /// TỔNG TIỀN NỢ
  double get tongTienNo {

    double tong = 0;

    for(final hoaDon in dsHoaDonNo) {

      final xe =
      getXeTheoHoaDon(hoaDon);

      if(xe != null) {

        tong += xe.giaGui ?? 0;
      }
    }

    return tong;
  }

  /// TEXT NỢ
  String get textNo {

    if(dsHoaDonNo.isEmpty) {

      return "Không có";
    }

    final hoaDonMoiNhat =
        dsHoaDonNo.first;

    return
      "${tongTienNo.toStringAsFixed(0)}đ • ${hoaDonMoiNhat.thangNam}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF6F7F9),

      body: SafeArea(

        child: Column(

          children: [

            /// HEADER
            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              child: Row(

                children: [

                  Container(

                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: IconButton(

                      onPressed: () {

                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Hóa đơn gửi xe",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            Color(0xff1C1C1E),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(

                          "Nguyễn Văn An • $tongSoXe xe",

                          style: const TextStyle(
                            fontSize: 12,
                            color:
                            Color(0xff8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// THỐNG KÊ
            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: Row(

                children: [

                  /// XE
                  Expanded(

                    child: Container(

                      padding:
                      const EdgeInsets.all(14),

                      decoration: BoxDecoration(

                        color:
                        const Color(0xffEAF7EC),

                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              const Icon(

                                Icons
                                    .directions_bike_rounded,

                                color:
                                Color(0xff2D7A3A),

                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(

                                "$tongSoXe xe",

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight.w700,
                                  color:
                                  Color(0xff2D7A3A),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(

                            "${tongTienThang.toStringAsFixed(0)}đ/tháng",

                            style: const TextStyle(
                              fontSize: 11,
                              color:
                              Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// NỢ
                  Expanded(

                    child: Container(

                      padding:
                      const EdgeInsets.all(14),

                      decoration: BoxDecoration(

                        color:
                        const Color(0xffFFF3E8),

                        borderRadius:
                        BorderRadius.circular(18),
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Row(

                            children: [

                              Icon(

                                Icons
                                    .attach_money_rounded,

                                color:
                                Color(0xffF08A24),

                                size: 18,
                              ),

                              SizedBox(width: 5),

                              Text(

                                "Còn nợ",

                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight.w700,
                                  color:
                                  Color(0xffF08A24),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(

                            textNo,

                            style: const TextStyle(
                              fontSize: 11,
                              color:
                              Color(0xff666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DANH SÁCH
            Expanded(

              child: Container(

                margin:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                padding:
                const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(24),
                ),

                child: Column(

                  children: [

                    /// HEADER
                    Row(

                      children: [

                        const Expanded(

                          child: Text(

                            "Lịch sử hóa đơn",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              Color(0xff2D7A3A),
                            ),
                          ),
                        ),

                        /// DROPDOWN
                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 2,
                          ),

                          decoration: BoxDecoration(

                            color:
                            const Color(0xffF4F5F7),

                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          child:
                          DropdownButtonHideUnderline(

                            child:
                            DropdownButton<String>(

                              value: namDangChon,

                              icon: const Icon(
                                Icons
                                    .keyboard_arrow_down_rounded,
                                size: 18,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),

                              style: const TextStyle(

                                fontSize: 13,

                                fontWeight:
                                FontWeight.w600,

                                color:
                                Color(0xff1C1C1E),
                              ),

                              items:
                              dsNam.map((nam) {

                                return DropdownMenuItem(

                                  value: nam,

                                  child: Text(nam),
                                );
                              }).toList(),

                              onChanged: (value) {

                                setState(() {

                                  namDangChon =
                                  value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// LIST
                    Expanded(

                      child:
                      ListView.separated(

                        itemCount:
                        dsHoaDonTheoNam.length,

                        separatorBuilder:
                            (_, __) =>
                        const Divider(

                          height: 26,

                          color:
                          Color(0xffF1F1F1),
                        ),

                        itemBuilder:
                            (context, index) {

                          final hoaDon =
                          dsHoaDonTheoNam[index];

                          final xe =
                          getXeTheoHoaDon(
                            hoaDon,
                          );

                          if(xe == null) {

                            return const SizedBox();
                          }

                          return ItemHoaDonGuiXe(

                            hoaDon: hoaDon,

                            phuongTien: xe,

                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}