import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/NguoiThueForm/NguoiThueForm.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/PhuongTienNguoiThuePage/PhuongTienNguoiThuePage.dart';
import 'package:AppTroNhaToi/utils/date_formatter.dart';
import 'package:AppTroNhaToi/utils/string_formatter.dart';
import 'package:AppTroNhaToi/widget/itemHoaDonGuiXe.dart';

import 'package:AppTroNhaToi/widget/itemNguoiThue.dart';
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
  State<ChiTietNguoiThuePage> createState() => _ChiTietNguoiThuePageState();
}

class _ChiTietNguoiThuePageState extends State<ChiTietNguoiThuePage> {
  List<NguoiThuePhong> dsOGhep = [];

  List<PhuongTien> dsXe = [];

  List<HoaDonGuiXe> dsHoaDon = [];
  late final NguoiThue nguoiThue;
  late final Phong phong;

  @override
  void initState() {
    super.initState();

    fakeData();
    setState(() {
      nguoiThue = widget.nguoiThue;
      phong = widget.phong;
    });
  }

  void fakeData() {
    //// NGƯỜI Ở GHÉP
    dsOGhep = [
      NguoiThuePhong(
        nguoiThue: NguoiThue(
          idnt: 2,

          /// ID người chính
          idntc: 1,

          hoTen: "Trần Văn Bảo",

          sdt: "0912 345 678",

          cccd: "07900123480",
        ),

        phong: [widget.phong],
      ),
    ];


    /// XE từng người
    if (widget.nguoiThue.idntc != null) {

      /// NGƯỜI Ở GHÉP
      dsXe = [

        PhuongTien(
          ID: 2,

          bienSo: "",

          hangXe: "Xe đạp điện",

          mauSac: "Màu trắng",

          giaGui: 30000,

          loaiXe: 2,
        ),
        PhuongTien(
          ID: 1,

          bienSo: "",

          hangXe: "Xe ô tô",

          mauSac: "Màu trắng",

          giaGui: 70000,

          loaiXe: 1,
        ),

        PhuongTien(
          ID: 0,

          bienSo: "59B1-123.45",

          hangXe: "Honda vision",

          mauSac: "Màu kem trắng",

          giaGui: 50000,

          loaiXe: 0,
        ),
      ];



    } else {

      /// NGƯỜI CHÍNH
      dsXe = [

        PhuongTien(
          ID: 1,

          bienSo: "59B1-123.45",

          hangXe: "Honda Wave 110",

          mauSac: "Màu đen",

          giaGui: 50000,

          loaiXe: 1,
        ),

        PhuongTien(
          ID: 2,

          bienSo: "",

          hangXe: "Xe đạp điện",

          mauSac: "Màu trắng",

          giaGui: 30000,

          loaiXe: 2,
        ),
        PhuongTien(
          ID: 3,
          bienSo: "59A1-99999",
          hangXe: "SH Mode",
          mauSac: "Đen",
          giaGui: 120000,
          loaiXe: 0,
        ),
        PhuongTien(
          ID: 4,
          bienSo: "51G-12345",
          hangXe: "Toyota Vios",
          mauSac: "Bạc",
          giaGui: 700000,
          loaiXe: 1,
        ),


      ];
    }

    /// HÓA ĐƠN
    dsHoaDon = [
      HoaDonGuiXe(
        maHoaDon: 1,
        thangNam: "Tháng 4/2025",
        trangThai: 0,
        idPhuongTien: 1,
      ),

      HoaDonGuiXe(
        maHoaDon: 2,
        thangNam: "Tháng 3/2025",
        trangThai: 1,
        idPhuongTien: 2,
      ),
    ];
  }

  void Test() {
    print("Hello");
  }

  void openPhuongTienPage() {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return PhuongTienNguoiThuePage(
            nguoiThue: nguoiThue,
            dsPhuongTien: dsXe,
          );
        },
      ),
    );
  }

  /// ĐI CHI TIẾT NGƯỜI THUÊ
  void toChiTietNguoiThue(NguoiThue nguoiThue) async {
    await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return ChiTietNguoiThuePage(
            nguoiThue: nguoiThue,

            phong: widget.phong,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOGhep = widget.nguoiThue.idntc != null;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: Colors.white,

        centerTitle: false,

        titleSpacing: 0,

        leadingWidth: 70,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16),

          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xff1C1C1E),
              ),
            ),
          ),
        ),

        title: const Text(
          "Chi tiết người thuê",

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xff1C1C1E),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PROFILE CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(
                children: [
                  /// AVATAR
                  Container(
                    width: 74,
                    height: 74,

                    decoration: BoxDecoration(
                      color: const Color(0xffDCE8FF),
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    alignment: Alignment.center,

                    child: Text(
                      vietTat(nguoiThue.hoTen ?? ""),

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff2F61E7),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          nguoiThue.hoTen ?? "",

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${phong.tenPhong} · "
                          "${isOGhep ? "Người ở ghép" : "Người thuê chính"}",

                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff8E8E93),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xffE8F7ED),
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: const Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Icon(
                                Icons.circle,
                                size: 7,
                                color: Color(0xff2D7A3A),
                              ),

                              SizedBox(width: 6),

                              Text(
                                "Đang thuê · Từ 01/01/2024",

                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2D7A3A),
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

            const SizedBox(height: 20),

            /// THÔNG TIN CÁ NHÂN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _section(
                    title: "Thông tin cá nhân",
                    action: "Sửa",

                    child: Column(
                      children: [
                        _itemInfo(
                          "Số điện thoại",
                          nguoiThue.sdt ?? "",
                          isBlue: true,
                        ),

                        _itemInfo("CCCD", nguoiThue.cccd ?? ""),

                        _itemInfo("Ngày sinh", formatDate(nguoiThue.ngaySinh)),

                        _itemInfo("Quê quán", nguoiThue.queQuan ?? ""),

                        _itemInfo("Ghi chú", nguoiThue.ghiChu ?? ""),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// NGƯỜI Ở GHÉP
                  isOGhep

                      ? _section(

                    title: "Người chính",

                    action: "",

                    child: ItemNguoiThue(

                      nguoiThue: NguoiThue(

                        idnt: 1,

                        hoTen: "Nguyễn Văn An",

                        sdt: "0912 345 678",

                        cccd: "079001234890",
                      ),
                      onTap: null,
                    ),
                  )

                      : _section(

                    title:
                    "Người ở ghép (${dsOGhep.length})",

                    action: "Thêm",

                    child: Column(

                      children: List.generate(

                        dsOGhep.length,

                            (index) {

                          return ItemNguoiThue(

                            nguoiThue:
                            dsOGhep[index]
                                .nguoiThue,

                            onTap: () {

                              toChiTietNguoiThue(

                                dsOGhep[index]
                                    .nguoiThue,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// PHƯƠNG TIỆN
                  _section(
                    title: "Phương tiện (${dsXe.length})",
                    action: "Xem tất cả",
                    onTap: openPhuongTienPage,

                    child: Column(
                      children: List.generate(dsXe.length, (index) {

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                          ),

                          child: ItemPhuongTien(
                            phuongTien: dsXe[index],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// HÓA ĐƠN
                  _section(
                    title: "Hóa đơn giữ xe",
                    action: "Xem tất cả",

                    child: Column(
                      children: List.generate(dsHoaDon.length, (index) {
                        final phuongTien = dsXe.firstWhere(
                          (xe) => xe.ID == dsHoaDon[index].idPhuongTien,
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == dsHoaDon.length - 1 ? 0 : 14,
                          ),

                          child: ItemHoaDonGuiXe(
                            hoaDon: dsHoaDon[index],
                            phuongTien: phuongTien,
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// DELETE
                  Container(
                    width: double.infinity,
                    height: 56,

                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1F1),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: TextButton.icon(
                      onPressed: () {},

                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),

                      label: const Text(
                        "Xóa người thuê này",

                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String action,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        spacing: 4,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff2D7A3A),
                ),
              ),
              onTap != null
                  ? GestureDetector(
                      onTap: onTap,
                      child: Text(
                        action,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2D7A3A),
                        ),
                      ),
                    )
                  : Text(
                      action,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2D7A3A),
                      ),
                    ),
            ],
          ),
          child,
        ],
      ),
    );
  }

  Widget _itemInfo(String title, String value, {bool isBlue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 13, color: Color(0xff999999)),
            ),
          ),

          Text(
            value,

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,

              color: isBlue ? const Color(0xff2F61E7) : const Color(0xff1C1C1E),
            ),
          ),
        ],
      ),
    );
  }
}
