import 'package:AppTroNhaToi/models/hoa_don_gui_xe.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phuong_tien.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/view_model/nguoi_thue_phong.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/PhuongTienNguoiThuePage/PhuongTienNguoiThuePage.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/ThemNguoiThuePage/themNguoiThuePage.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/hoaDonGuiXePage/hoaDonGuiXePage.dart';
import 'package:AppTroNhaToi/utils/date_formatter.dart';
import 'package:AppTroNhaToi/utils/string_formatter.dart';
import 'package:AppTroNhaToi/widget/itemHoaDonGuiXe.dart';

import 'package:AppTroNhaToi/widget/itemNguoiThue.dart';
import 'package:AppTroNhaToi/widget/itemPhuongTien.dart';

import 'package:flutter/material.dart';

class ChiTietNguoiThuePage extends StatefulWidget {
  final NguoiThue nguoiThue;

  final List<Phong> dsPhong;

  const ChiTietNguoiThuePage({
    super.key,
    required this.nguoiThue,
    required this.dsPhong,
  });

  @override
  State<ChiTietNguoiThuePage> createState() => _ChiTietNguoiThuePageState();
}

class _ChiTietNguoiThuePageState extends State<ChiTietNguoiThuePage> {


  List<PhuongTien> dsXe = [];

  List<HoaDonGuiXe> dsHoaDon = [];
  late final NguoiThue nguoiThue;
  late final List<Phong> dsPhong;

  @override
  void initState() {
    super.initState();


    setState(() {
      nguoiThue = widget.nguoiThue;
      dsPhong = widget.dsPhong;
    });
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



  @override
  Widget build(BuildContext context) {


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

        actions: [

          Padding(

            padding: const EdgeInsets.only(
              right: 16,
            ),

            child: Container(

              width: 38,
              height: 38,

              decoration: const BoxDecoration(
                color: Color(0xffF4F4F4),
                shape: BoxShape.circle,
              ),

              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Color(0xff666666),
                ),
              ),
            ),
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
        Padding(

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        child: Container(

          width: double.infinity,

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(24),

            boxShadow: [

              BoxShadow(

                color:
                Colors.black.withOpacity(
                  0.03,
                ),

                blurRadius: 10,

                offset: const Offset(
                  0,
                  2,
                ),
              ),
            ],
          ),

          child: Column(

            children: [

              Container(

                width: 72,
                height: 72,

                decoration: const BoxDecoration(
                  color: Color(0xff1F9D3A),
                  shape: BoxShape.circle,
                ),

                alignment: Alignment.center,

                child: Text(

                  vietTat(
                    nguoiThue.hoTen ?? "",
                  ),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(

                nguoiThue.hoTen ?? "",

                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              const Text(

                "Đang thuê hoạt động",

                style: TextStyle(
                  color: Color(0xff1F9D3A),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              Row(

                children: [

                  Expanded(
                    child: _actionButton(
                      const Icon(
                        Icons.call_outlined,
                        color: Color(0xff2F61E7),
                      ),
                      "Gọi điện",
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _actionButton(
                      const Icon(
                        Icons.message_outlined,
                        color: Color(0xff2F61E7),
                      ),
                      "Nhắn tin",
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _actionButton(
                      Image.asset(
                        "assets/images/zalo.png",
                        width: 20,
                        height: 20,
                      ),
                      "Zalo",
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                    // thêm sữa thông tin cá nhân
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              ThemNguoiThuePage(nguoiThueSua: widget.nguoiThue),
                        ),
                      );
                    },

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

                  _section(

                    title:
                    "Phòng đang thuê (${dsPhong.length})",

                    action: "Xem thêm",

                    child: Column(

                      children:

                      dsPhong.asMap().entries.map((e) {

                        final phong = e.value;

                        return Column(

                          children: [

                            _itemPhong(

                              phong.tenPhong,

                              "Phòng ${phong.tenPhong.replaceAll("P", "")}",

                              "",
                            ),

                            if (e.key !=
                                dsPhong.length - 1)

                              const Divider(
                                height: 1,
                              ),
                          ],
                        );
                      }).toList(),
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
  Widget _itemPhong(
      String maPhong,
      String tenPhong,
      String ngayThue,
      ) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),

      child: Row(

        children: [

          Container(

            width: 42,
            height: 42,

            decoration: BoxDecoration(

              color:
              const Color(
                0xffEEF6EF,
              ),

              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),

            alignment: Alignment.center,

            child: Text(

              maPhong,

              style: const TextStyle(

                color:
                Color(
                  0xff2D7A3A,
                ),

                fontWeight:
                FontWeight.w700,

                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Text(

              tenPhong,

              style: const TextStyle(

                fontSize: 15,

                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xffC7C7CC),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      Widget icon,
      String title,
      ) {

    return Container(

      height: 72,

      decoration: BoxDecoration(

        color:
        const Color(
          0xffF7F8FC,
        ),

        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          SizedBox(

            width: 22,
            height: 22,

            child: Center(
              child: icon,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(

            title,

            style: const TextStyle(

              fontSize: 12,

              color:
              Color(
                0xff555555,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
