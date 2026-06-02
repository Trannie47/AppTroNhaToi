``
`dart
import 'package:flutter/material.dart';

class TaoHopDongPage extends StatefulWidget {
const TaoHopDongPage({super.key});

@override
State<TaoHopDongPage> createState() => _TaoHopDongPageState();
}

class _TaoHopDongPageState extends State<TaoHopDongPage> {
final txtPhong = TextEditingController(text: "Phòng 101");
final txtNguoiThue = TextEditingController(text: "Trần Văn Bảo");
final txtNgayKy = TextEditingController(text: "20/05/2026");
final txtNgayHetHan = TextEditingController(text: "01/01/2028");

final txtTongGiaPhong = TextEditingController(text: "4,000,000");
final txtGiaHopDong = TextEditingController(text: "2,500,000");
final txtGiaDeXuat = TextEditingController(text: "1,500,000");

final txtTienCoc = TextEditingController(text: "2,500,000");
final txtGhiChu = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xffF3F3F3),

appBar: AppBar(
backgroundColor: Colors.white,
elevation: 0,
scrolledUnderElevation: 0,

leading: IconButton(
onPressed: () {
Navigator.pop(context);
},
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
color: Colors.black,
size: 18,
),
),

title: const Text(
"Tạo hợp đồng",
style: TextStyle(
color: Colors.black,
fontWeight: FontWeight.w700,
fontSize: 22,
),
),
),

body: Padding(
padding: const EdgeInsets.all(12),

child: Column(
children: [
Expanded(
child: SingleChildScrollView(
child: Column(
children: [
/// THÔNG TIN THUÊ
_section(
title: "Thông tin thuê",
child: Column(
children: [
_input(
"Phòng thuê",
txtPhong,
),

_input(
"Người thuê chính",
txtNguoiThue,
),

Row(
children: [
Expanded(
child: _dateInput(
"Ngày ký",
txtNgayKy,
),
),

const SizedBox(width: 10),

Expanded(
child: _dateInput(
"Ngày hết hạn",
txtNgayHetHan,
),
),
],
),
],
),
),

const SizedBox(height: 12),

/// GIÁ THUÊ
_section(
title: "Thiết lập giá thuê",
child: Column(
children: [
_moneyInput(
"Tổng giá phòng",
txtTongGiaPhong,
),

_moneyInput(
"Giá thuê của hợp đồng",
txtGiaHopDong,
isGreen: true,
),

_moneyInput(
"Giá thuê đề xuất cho người đang ở",
txtGiaDeXuat,
),
],
),
),

const SizedBox(height: 12),

/// CỌC & GHI CHÚ
_section(
title: "Cọc & ghi chú",
child: Column(
children: [
_moneyInput(
"Tiền cọc",
txtTienCoc,
),

const SizedBox(height: 12),

const Align(
alignment: Alignment.centerLeft,
child: Text(
"Ghi chú",
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w500,
),
),
),

const SizedBox(height: 6),

TextField(
controller: txtGhiChu,
maxLines: 4,
decoration: InputDecoration(
filled: true,
fillColor: const Color(0xffF4F4F4),

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(10),
borderSide: BorderSide.none,
),
),
),
],
),
),
],
),
),
),

const SizedBox(height: 12),

SizedBox(
width: double.infinity,
height: 52,

child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xff2E7D32),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
onPressed: () {},
child: const Text(
"Tạo hợp đồng",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.w700,
),
),
),
),

const SizedBox(height: 10),

SizedBox(
width: double.infinity,
height: 52,

child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xffC62828),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
onPressed: () {},
child: const Text(
"Hủy bỏ",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.w700,
),
),
),
),
],
),
),
);
}

Widget _section({
required String title,
required Widget child,
}) {
return Container(
width: double.infinity,

padding: const EdgeInsets.all(14),

decoration: BoxDecoration(
color: const Color(0xffECECEC),
borderRadius: BorderRadius.circular(16),
),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
color: Color(0xff2E7D32),
fontWeight: FontWeight.w700,
fontSize: 12,
),
),

const SizedBox(height: 10),

child,
],
),
);
}

Widget _input(
String title,
TextEditingController controller,
) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
Text(title),

const SizedBox(height: 6),

TextField(
controller: controller,

decoration: InputDecoration(
filled: true,
fillColor: const Color(0xffF4F4F4),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
borderSide: BorderSide.none,
),
),
),
],
),
);
}

Widget _dateInput(
String title,
TextEditingController controller,
) {
return _input(title, controller);
}

Widget _moneyInput(
String title,
TextEditingController controller, {
bool isGreen = false,
}) {
return Padding(
padding: const EdgeInsets.only(bottom: 12),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [
Text(title),

const SizedBox(height: 6),

TextField(
controller: controller,

style: TextStyle(
color: isGreen
? const Color(0xff2E7D32)
    : Colors.black,
fontWeight: FontWeight.w600,
),

decoration: InputDecoration(
suffixText: "đ/tháng",

filled: true,
fillColor: const Color(0xffF4F4F4),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(10),
borderSide: BorderSide.none,
),
),
),
],
),
);
}
}

