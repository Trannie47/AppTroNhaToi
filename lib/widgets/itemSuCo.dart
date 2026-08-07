// import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
// import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
// import 'package:AppTroNhaToi/models/phieu_su_co.dart';
// import 'package:flutter/material.dart';

// class ItemChietTietLuanChuyen extends StatelessWidget {
//   final PhieuSuCo suCo;

//   final VoidCallback? edit;

//   final VoidCallback? delete;

//   const ItemChietTietLuanChuyen({
//     super.key,
//     required this.suCo,
//     this.edit,
//     this.delete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: const Color(0xffEEEEEE)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: _backgroundColor(),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 alignment: Alignment.center,
//                 child: Icon(_icon(), color: _statusColor(), size: 25),
//               ),

//               const SizedBox(width: 14),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       suCo.tenSuCo ?? "",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xff1C1C1E),
//                       ),
//                     ),

//                     const SizedBox(height: 4),

//                     Text(
//                       suCo.phong?.tenPhong ?? "",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xff8F8F8F),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: _backgroundColor(),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Text(
//                   _statusText(),
//                   style: TextStyle(
//                     color: _statusColor(),
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           Container(height: 1, color: const Color(0xffF2F2F2)),

//           const SizedBox(height: 12),

//           Row(
//             children: [
//               const Icon(
//                 Icons.calendar_month_outlined,
//                 size: 16,
//                 color: Color(0xff9E9E9E),
//               ),

//               const SizedBox(width: 6),

//               Expanded(
//                 child: Text(
//                   formatDate(suCo.ngayBatDau),
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xff4F4F4F),
//                   ),
//                 ),
//               ),

//               Text(
//                 formatMoney(suCo.chiPhi ?? 0),
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),

//           if ((suCo.ghiChu ?? "").isNotEmpty) ...[
//             const SizedBox(height: 10),

//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 suCo.ghiChu!,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 12, color: Color(0xff6A6A6A)),
//               ),
//             ),
//           ],

//           if (edit != null || delete != null) ...[
//             const SizedBox(height: 14),

//             Row(
//               children: [
//                 const Spacer(),

//                 if (edit != null)
//                   GestureDetector(
//                     onTap: edit,
//                     child: const Row(
//                       children: [
//                         Icon(
//                           Icons.edit_outlined,
//                           size: 15,
//                           color: Color(0xffF08A24),
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           "Sửa",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Color(0xffF08A24),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 if (edit != null && delete != null) const SizedBox(width: 14),

//                 if (delete != null)
//                   GestureDetector(
//                     onTap: delete,
//                     child: const Row(
//                       children: [
//                         Icon(Icons.delete_outline, size: 15, color: Colors.red),
//                         SizedBox(width: 4),
//                         Text(
//                           "Xóa",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.red,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   IconData _icon() {
//     switch (suCo.trangThaiThongBao) {
//       case 0:
//         return Icons.warning_amber_rounded;
//       case 1:
//         return Icons.build_circle_outlined;
//       case 2:
//         return Icons.check_circle_outline_rounded;
//       default:
//         return Icons.report_problem_outlined;
//     }
//   }

//   String _statusText() {
//     switch (suCo.trangThaiThongBao) {
//       case 0:
//         return "Chưa xử lý";
//       case 1:
//         return "Đang xử lý";
//       case 2:
//         return "Hoàn thành";
//       default:
//         return "Không xác định";
//     }
//   }

//   Color _statusColor() {
//     switch (suCo.trangThaiThongBao) {
//       case 0:
//         return Colors.orange;
//       case 1:
//         return Colors.blue;
//       case 2:
//         return const Color(0xff2D7A3A);
//       default:
//         return Colors.grey;
//     }
//   }

//   Color _backgroundColor() {
//     switch (suCo.trangThaiThongBao) {
//       case 0:
//         return const Color(0xffFFF5E9);
//       case 1:
//         return const Color(0xffEEF6FF);
//       case 2:
//         return const Color(0xffEDF8F0);
//       default:
//         return const Color(0xffF4F4F4);
//     }
//   }
// }
