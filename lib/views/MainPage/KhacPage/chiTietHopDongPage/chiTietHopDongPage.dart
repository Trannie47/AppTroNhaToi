import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/xemAnhHopDong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../PhongPage/ChiTietPhongPage/phongChiTiet.dart';

class ChiTietHopDongPage extends StatefulWidget {
  final HopDongDTO hopDong;
  const ChiTietHopDongPage({super.key, required this.hopDong});

  @override
  State<ChiTietHopDongPage> createState() => _ChiTietHopDongPageState();
}

class _ChiTietHopDongPageState extends State<ChiTietHopDongPage> {
  late ChiTietHopDongViewModel vm;

  @override
  void initState() {

     super.initState();
     //final phongProvider = Provider.of<PhongProvider>(context, listen: false);
     vm = ChiTietHopDongViewModel(context.read<PhongProvider>());
     vm.init(widget.hopDong);
    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(36),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),

        titleSpacing: 16,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chi tiết hợp đồng",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff111111),
              ),
            ),
            Text(
              vm.hopDong.hopDongID,
              style: TextStyle(fontSize: 14, color: Color(0xff888888)),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(36),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Center(
                  child: Icon(Icons.more_vert, color: Colors.black, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _tenantInfo(vm.hopDong),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _thongTinThuePhong(vm.hopDong),
                  const SizedBox(height: 16),
                  _anhHopDong(context, vm.hopDong.dsAnhHopDong),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xffF3F3F3),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _chiTietPhongButton(context,vm),
            const SizedBox(height: 16),
            _ketThucHopDongButton(),
          ],
        ),
      ),
    );
  }
}

Widget _tenantInfo(HopDongDTO hopDong) {
  // Mặc định màu sắc và chữ dựa theo trạng thái hợp đồng
  String statusText = "Không rõ";
  Color textColor = Colors.black;
  Color bgColor = Colors.grey.shade200;

  switch (hopDong.trangThai) {
    case 0:
      statusText = "Chờ hiệu lực";
      textColor = const Color(0xffB45309); // vàng
      bgColor = const Color(0xffFEF3C7);
      break;
    case 1:
      statusText = "Đang hoạt động";
      textColor = Colors.green[700]!; // Xanh lá
      bgColor = const Color(0xffE8F3E7);
      break;
    case 2:
      statusText = "Đã kết thúc";
      textColor = const Color(0xff4B5563); // Xám
      bgColor = const Color(0xffF3F4F6);
      break;
  }
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Color(0xffDCE6FF),
            borderRadius: BorderRadius.circular(35),
          ),
          alignment: Alignment.center,

          child: Text(
            vietTat(hopDong.nguoithue.hoTen),
            style: TextStyle(
              color: Color(0xff3B5DD8),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hopDong.nguoithue.hoTen,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Phòng ${hopDong.phong.tenPhong}",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: textColor, size: 10),
                  SizedBox(width: 5),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _thongTinThuePhong(HopDongDTO hopDong) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        const Text(
          "Thông tin thuê phòng",
          style: TextStyle(
            color: Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),

        _item(
          "Giá thuê",
          "${formatMoney(hopDong.giaPhongThucTe)}/tháng",
          color: Color(0xff2E7D32),
        ),
        _item("Tiền đặt cọc", formatMoney(hopDong.tienCoc)),
        _item("Ngày bắt đầu", formatDate(hopDong.ngayKy)),
        _item("Hạn hợp đồng", formatDate(hopDong.ngayHetHan)),
        _item(
          "Ghi chú",
          hopDong.ghiChu??'',
          color: Color(0xff888888),
        ),
      ],
    ),
  );
}

Widget _item(String title, String value, {Color color = Colors.black}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ),
      Expanded(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Widget _anhHopDong(BuildContext context, List<String> dsAnh) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hợp đồng đã ký",
          style: TextStyle(
            color: Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 12),

        if (dsAnh.isEmpty)
          Row(
            children: [
              Icon(Icons.image_not_supported_outlined,
                  color: Colors.grey.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                "Chưa có ảnh hợp đồng",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => XemAnhHopDong(dsAnh: dsAnh),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffEAEAEA)),
              ),
              child: Row(
                children: [
                  //anhr bìa là ảnh đầu tiên
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          dsAnh.first,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.broken_image,
                                color: Colors.grey.shade400),
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
                          "Bản hợp đồng giấy",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green.shade600, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              "${dsAnh.length} ảnh đã upload",
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Nút xem
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xffF0F7F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_library_outlined,
                              size: 14, color: Color(0xff2E7D32)),
                          SizedBox(width: 4),
                          Text(
                            "Xem",
                            style: TextStyle(
                              color: Color(0xff2E7D32),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}


Widget _chiTietPhongButton(BuildContext context, ChiTietHopDongViewModel vm) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: vm.isLoadingPhong
          ? null // Khóa nút khi đang gọi API
          : () async {
        final itemPhong = await vm.getInforPhong(vm.hopDong.phongID);
        if (!context.mounted) return;

        if (itemPhong != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhongChiTiet(room: itemPhong),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Không tìm thấy thông tin phòng!"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: vm.isLoadingPhong
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xff2E7D32),
        ),
      ):Text(
        "Chi tiết Phòng ${vm.hopDong.phong.tenPhong}",
        style: TextStyle(
          color: Color(0xff1D2433),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _ketThucHopDongButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffE53E3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
      child: const Text(
        "Kết thúc hợp đồng",
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
