// import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/HopDongLuanChuyenVM.dart';
// import 'package:flutter/material.dart';

// class ItemChiTietLuanChuyen extends StatelessWidget {
//   final HopDongLuanChuyenVM item;

//   const ItemChiTietLuanChuyen({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xffF8F9FA),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   item.maHopDong ?? "",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 item.tenNguoiDaiDien ?? "",
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Từ phòng",
//                         style: TextStyle(
//                           color: Color(0xFF514D4D),
//                           fontSize: 13,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         item.phongCuText ?? "",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 child: Icon(
//                   Icons.arrow_forward,
//                   color: Color(0xff2D7A3A),
//                   size: 28,
//                 ),
//               ),

//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xffEAF5EC),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Đến phòng",
//                         style: TextStyle(
//                           color: Color(0xFF514D4D),
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         item.phongMoiText ?? "",
//                         style: const TextStyle(
//                           color: Color(0xff2D7A3A),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
