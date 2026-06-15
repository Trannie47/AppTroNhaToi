import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/core/utils/string_formatter.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDong_Model.dart';
import 'package:flutter/material.dart';

class ChiTietHopDongPage extends StatefulWidget {
  final HopDong hopDong;
  const ChiTietHopDongPage({super.key, required this.hopDong});

  @override
  State<ChiTietHopDongPage> createState() => _ChiTietHopDongPageState();
}

class _ChiTietHopDongPageState extends State<ChiTietHopDongPage> {
  late ChiTietHopDongViewModel vm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm = ChiTietHopDongViewModel();
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
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
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

        titleSpacing: 16,

        title: const Column(
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
              "HD-101-AN-01",
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
            _tenantInfo(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _thongTinThuePhong(vm.hopDong),
                  const SizedBox(height: 20),
                  _thanhVienCungPhong(vm.danhSachChungPhong),
                  const SizedBox(height: 150),
                  // _chiTietPhongButton(),
                  // const SizedBox(height: 16),
                  // _ketThucHopDongButton(),
                  // const SizedBox(height: 16),
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
            _chiTietPhongButton(),
            const SizedBox(height: 16),
            _ketThucHopDongButton(),
          ],
        ),
      ),
    );
  }
}

Widget _tenantInfo() {
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
            "NA",
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
              "Nguyễn Văn An",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Phòng 101",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffE8F3E7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 10),
                  SizedBox(width: 5),
                  Text(
                    "Đang hoạt động",
                    style: TextStyle(
                      color: Colors.green[700],
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

Widget _thongTinThuePhong(HopDong hopDong) {
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
          formatMoney(hopDong.giaPhongThucTe ?? 0) + "/tháng",
          color: Color(0xff2E7D32),
        ),
        _item("Tiền đặt cọc", formatMoney(hopDong.tienCoc ?? 0)),
        _item("Ngày bắt đầu", formatDate(hopDong.ngayKy)),
        _item("Hạn hợp đồng", formatDate(hopDong.ngayHetHan)),
        _item(
          "Ghi chú",
          "Hợp đồng ban đầu chỉ ở 1 người.",
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

Widget _thanhVienCungPhong(List<chiTietHopDongModel> danhSachChungPhong) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thành viên cùng phòng (${danhSachChungPhong.length})",
          style: const TextStyle(
            color: Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        if (danhSachChungPhong.isEmpty)
          Container(
            height: 90,
            alignment: Alignment.center,
            child: const Text(
              "Chưa có thành viên",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...danhSachChungPhong.map((item) {
            final NguoiThue nguoiThue = item.nguoiThue;
            final HopDong hopDong = item.hopDong;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xffDCE6FF),
                    child: Text(vietTat(nguoiThue.hoTen ?? "")),
                  ),
                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nguoiThue.hoTen ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Mã HĐ: ${hopDong.hopDongID ?? ""}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F3E7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      formatMoney(hopDong.giaPhongThucTe ?? 0),
                      style: const TextStyle(
                        color: Color(0xff2E7D32),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    ),
  );
}

Widget _chiTietPhongButton() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
      child: const Text(
        "Chi tiết Phòng 101",
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
