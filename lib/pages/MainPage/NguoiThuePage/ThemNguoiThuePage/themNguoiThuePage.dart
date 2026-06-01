import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/NguoiThueForm/formNguoiThue.dart';
import 'package:AppTroNhaToi/pages/MainPage/NguoiThuePage/qr_cccd_scanner_page/qr_cccd_scanner_page.dart';
import 'package:flutter/material.dart';

class ThemNguoiThuePage
    extends StatefulWidget {

  final NguoiThue? nguoiThueSua;

  const ThemNguoiThuePage({

    super.key,

    this.nguoiThueSua,
  });

  @override
  State<ThemNguoiThuePage>
  createState() =>
      _ThemNguoiThuePageState();
}

class _ThemNguoiThuePageState
    extends State<ThemNguoiThuePage> {

  final txtHoTen =
  TextEditingController();

  final txtSDT =
  TextEditingController();

  final txtCCCD =
  TextEditingController();

  final txtNgaySinh =
  TextEditingController();

  final txtQueQuan =
  TextEditingController();

  final txtPhong =
  TextEditingController();

  final txtVaiTro =
  TextEditingController();

  final txtGhiChu =
  TextEditingController();

  bool? gioiTinh = true;

  @override
  void initState() {

    super.initState();

    if(widget.nguoiThueSua != null) {

      final nguoi =
      widget.nguoiThueSua!;

      txtHoTen.text =
          nguoi.hoTen ?? "";

      txtSDT.text =
          nguoi.sdt ?? "";

      txtCCCD.text =
          nguoi.cccd ?? "";

      txtQueQuan.text =
          nguoi.queQuan ?? "";

      txtGhiChu.text =
          nguoi.ghiChu ?? "";

      gioiTinh =
          nguoi.gioiTinh;

      if(nguoi.ngaySinh != null) {

        txtNgaySinh.text =
            nguoi.ngaySinh!
                .toString()
                .split(" ")
                .first;
      }
    }
  }

  void luuNguoiThue() {

    final nguoiThueMoi =
    NguoiThue(

      hoTen:
      txtHoTen.text,

      sdt:
      txtSDT.text,

      cccd:
      txtCCCD.text,

      queQuan:
      txtQueQuan.text,

      ghiChu:
      txtGhiChu.text,

      gioiTinh:
      gioiTinh,

      ngaySinh:
      DateTime.tryParse(
        txtNgaySinh.text,
      ),
    );

    Navigator.pop(
      context,
      nguoiThueMoi,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF6F7F9),

      appBar: AppBar(

        backgroundColor:
        const Color(0xffF6F7F9),

        elevation: 0,

        leading: IconButton(

          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 18,
          ),
        ),

        title: Text(

          widget.nguoiThueSua != null
              ? "Sửa người thuê"
              : "Thêm người thuê",

          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

      ),


      body: Column(

        children: [

          Expanded(

            child: SingleChildScrollView(

              padding: const EdgeInsets.all(16),

              child: Column(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                          const QRCCCDScannerPage(),
                        ),
                      );
                    },

                    child: Container(

                      height: 72,

                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),

                      decoration: BoxDecoration(

                        color: const Color(
                          0xff4C469D,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),

                      child: const Row(

                        children: [

                          SizedBox(width: 16),

                          Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                          ),

                          SizedBox(width: 12),

                          Expanded(

                            child: Column(

                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  "Quét mã QR trên thẻ CCCD",

                                  style: TextStyle(

                                    color: Colors.white,

                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),

                                Text(

                                  "Tự động điền nhanh họ tên, ngày sinh, địa chỉ...",

                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),

                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),

                  FormNguoiThue(

                    txtHoTen: txtHoTen,
                    txtSDT: txtSDT,
                    txtCCCD: txtCCCD,
                    txtNgaySinh: txtNgaySinh,
                    txtQueQuan: txtQueQuan,
                    txtPhong: txtPhong,
                    txtVaiTro: txtVaiTro,
                    txtGhiChu: txtGhiChu,

                    gioiTinh: gioiTinh,

                    onChangedGioiTinh: (value) {

                      setState(() {

                        gioiTinh = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(

            padding: const EdgeInsets.all(16),

            child: SizedBox(

              width: double.infinity,

              height: 56,

              child: ElevatedButton(

                onPressed: luuNguoiThue,

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

                child: Text(

                  widget.nguoiThueSua != null
                      ? "Cập nhật người thuê"
                      : "Lưu người thuê",

                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight:
                    FontWeight.w700,

                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}