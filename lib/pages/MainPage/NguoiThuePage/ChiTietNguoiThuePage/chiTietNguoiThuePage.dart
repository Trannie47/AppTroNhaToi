import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';

import 'package:AppTroNhaToi/widget/itemNguoiOGhep.dart';
import 'package:AppTroNhaToi/widget/itemPhuongTien.dart';



import 'package:flutter/material.dart';

class ChiTietNguoiThuePage extends StatefulWidget {

  final NguoiThue nguoiThue;

  final Phong phong;

  const ChiTietNguoiThuePage({
    super.key,
    required this.nguoiThue,
    required this.phong,
  });

  @override
  State<ChiTietNguoiThuePage> createState() =>
      _ChiTietNguoiThuePageState();
}

class _ChiTietNguoiThuePageState
    extends State<ChiTietNguoiThuePage> {

  List<NguoiThuePhong> dsOGhep = [];

  List<PhuongTien> dsXe = [];

  List<HoaDonGuiXe> dsHoaDon = [];

  @override
  void initState() {
    super.initState();

    fakeData();
  }

  void fakeData() {

    /// NGƯỜI Ở GHÉP
    dsOGhep = [
      NguoiThuePhong(
        nguoiThue: NguoiThue(
          idnt: 2,
          hoTen: "Trần Văn Bảo",
          sdt: "0912 345 678",
          cccd: "079001234890",
        ),

        phong: widget.phong,
      ),
    ];

    /// XE
    dsXe = [
      PhuongTien(
        bienSo: "59B1-123.45",
        hangXe: "Honda Wave 110",
        mauSac: "Màu đen",
      ),

      PhuongTien(
        bienSo: "",
        hangXe: "Xe đạp điện",
        mauSac: "Màu trắng",
      ),
    ];

    /// HÓA ĐƠN
    dsHoaDon = [
      HoaDonGuiXe(
        maHoaDon: 1,
        thangNam: "Tháng 4/2025",
        soTien: 150000,
        trangThai: 0,
        soLuongXe: 2,
      ),

      HoaDonGuiXe(
        maHoaDon: 2,
        thangNam: "Tháng 3/2025",
        soTien: 150000,
        trangThai: 1,
        soLuongXe: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(0xffF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// HEADER
              Row(
                children: [

                  /// BACK
                  Container(
                    width: 38,
                    height: 38,

                    decoration:
                    const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(
                            context);
                      },

                      icon: const Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Chi tiết người thuê",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// PROFILE
              Row(
                children: [

                  /// AVATAR
                  Container(
                    width: 60,
                    height: 60,

                    decoration:
                    const BoxDecoration(
                      color:
                      Color(0xffDCE8FF),
                      shape: BoxShape.circle,
                    ),

                    alignment:
                    Alignment.center,

                    child: Text(
                      vietTat(
                        widget.nguoiThue
                            .hoTen ??
                            "",
                      ),

                      style:
                      const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        Color(0xff2F61E7),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          widget.nguoiThue
                              .hoTen ??
                              "",

                          style:
                          const TextStyle(
                            fontSize: 28,
                            fontWeight:
                            FontWeight
                                .w800,
                          ),
                        ),

                        const SizedBox(
                            height: 3),

                        Text(
                          "${widget.phong.tenPhong} · Người thuê chính",

                          style:
                          const TextStyle(
                            fontSize: 13,
                            color: Color(
                                0xff8E8E93),
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            const Color(
                                0xffE7F7EC),

                            borderRadius:
                            BorderRadius.circular(
                                30),
                          ),

                          child: const Row(
                            mainAxisSize:
                            MainAxisSize
                                .min,

                            children: [

                              Icon(
                                Icons.circle,
                                size: 10,
                                color: Color(
                                    0xff2D7A3A),
                              ),

                              SizedBox(
                                  width: 6),

                              Text(
                                "Đang thuê · Từ 01/01/2024",

                                style:
                                TextStyle(
                                  fontSize:
                                  12,
                                  fontWeight:
                                  FontWeight
                                      .w700,
                                  color: Color(
                                      0xff2D7A3A),
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

              const SizedBox(height: 24),

              /// THÔNG TIN CÁ NHÂN
              _section(
                title:
                "Thông tin cá nhân",

                action: "Sửa",

                child: Column(
                  children: [

                    _itemInfo(
                      "Số điện thoại",
                      widget.nguoiThue
                          .sdt ??
                          "",
                      isBlue: true,
                    ),

                    _itemInfo(
                      "CCCD",
                      widget.nguoiThue
                          .cccd ??
                          "",
                    ),

                    _itemInfo(
                      "Ngày sinh",
                      "15/06/1998",
                    ),

                    _itemInfo(
                      "Quê quán",
                      widget.nguoiThue
                          .queQuan ??
                          "",
                    ),

                    _itemInfo(
                      "Ghi chú",
                      widget.nguoiThue
                          .ghiChu ??
                          "",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// NGƯỜI Ở GHÉP
              _section(
                title:
                "Người ở ghép (${dsOGhep.length})",

                action: "Thêm",

                child: Column(
                  children: List.generate(
                    dsOGhep.length,
                        (index) {

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          bottom:
                          index ==
                              dsOGhep.length -
                                  1
                              ? 0
                              : 12,
                        ),

                        child:
                        ItemNguoiOGhep(
                          nguoiThue:
                          dsOGhep[index],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// PHƯƠNG TIỆN
              _section(
                title:
                "Phương tiện (${dsXe.length})",

                action: "Xem tất cả",

                child: Column(
                  children: List.generate(
                    dsXe.length,
                        (index) {

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          bottom:
                          index ==
                              dsXe.length - 1
                              ? 0
                              : 14,
                        ),

                        // child: ItemPhuongTien(
                        //   phuongTien:
                        //   dsXe[index],
                        //
                        //   giaTien:
                        //   index == 0
                        //       ? "100,000đ"
                        //       : "50,000đ",
                        // ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// HÓA ĐƠN
              _section(
                title:
                "Hóa đơn giữ xe",

                action: "Xem tất cả",

                child: Column(
                  children: List.generate(
                    dsHoaDon.length,
                        (index) {

                      return Padding(
                        padding:
                        EdgeInsets.only(
                          bottom:
                          index ==
                              dsHoaDon.length -
                                  1
                              ? 0
                              : 14,
                        ),

                        child:
                        ItemHoaDonGuiXe(
                          hoaDon:
                          dsHoaDon[
                          index],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// DELETE
              Container(
                width: double.infinity,
                height: 54,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                      16),
                ),

                child: TextButton(
                  onPressed: () {},

                  child: const Text(
                    "Xóa người thuê này",

                    style: TextStyle(
                      color: Colors.red,
                      fontWeight:
                      FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String action,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          /// HEADER
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [

              Text(
                title,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  Color(0xff2D7A3A),
                ),
              ),

              Text(
                action,

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

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _itemInfo(
      String title,
      String value, {
        bool isBlue = false,
      }) {
    return Padding(
      padding:
      const EdgeInsets.only(
          bottom: 18),

      child: Row(
        children: [

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontSize: 13,
                color:
                Color(0xff999999),
              ),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,

              color: isBlue
                  ? const Color(
                  0xff2F61E7)
                  : const Color(
                  0xff1C1C1E),
            ),
          ),
        ],
      ),
    );
  }

  String vietTat(String name) {

    List<String> arr =
    name.trim().split(" ");

    if (arr.length >= 2) {

      return
        "${arr.first[0]}${arr.last[0]}"
            .toUpperCase();
    }

    return arr.first[0]
        .toUpperCase();
  }
}