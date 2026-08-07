// import 'package:AppTroNhaToi/Provider/SuCoProvider.dart';
// import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/PhongHopDongVM.dart';
// import 'package:AppTroNhaToi/modelviews/MainPage/PhongPage/ChiTietPhongPage/LuanChuyenPage/luanChuyenPageModelViews.dart';
// import 'package:AppTroNhaToi/widgets/itemChiTietLuanChuyen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LuanChuyenPage extends StatefulWidget {
//   final int suCoId;

//   const LuanChuyenPage({super.key, required this.suCoId});

//   @override
//   State<LuanChuyenPage> createState() => _LuanChuyenPageState();
// }

// class _LuanChuyenPageState extends State<LuanChuyenPage> {
//   late final LuanChuyenViewModel vm;

//   @override
//   void initState() {
//     super.initState();

//     vm = LuanChuyenViewModel(context.read<SuCoProvider>(), widget.suCoId);
//   }

//   @override
//   void dispose() {
//     vm.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: vm,
//       builder: (context, _) {
//         return Scaffold(
//           backgroundColor: const Color(0xffF5F6FA),

//           // backgroundColor: const Color(0xffFAFAFA),
//           appBar: AppBar(
//             elevation: 0,
//             centerTitle: false,
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: Colors.black,
//               ),
//             ),
//             title: const Text(
//               "Luân chuyển tạm thời",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           bottomNavigationBar: SafeArea(
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//               child: SizedBox(
//                 height: 54,
//                 child: ElevatedButton.icon(
//                   onPressed: vm.luu,
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     backgroundColor: const Color(0xff2D7A3A),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   icon: const Icon(Icons.save_rounded, color: Colors.white),
//                   label: const Text(
//                     "LƯU LUÂN CHUYỂN",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   _buildThongTinSuCo(),

//                   const SizedBox(height: 16),

//                   _buildDanhSachHopDong(),

//                   const SizedBox(height: 16),

//                   _buildNgayLuanChuyen(),

//                   const SizedBox(height: 16),

//                   _buildGhiChu(),

//                   const SizedBox(height: 16),

//                   _buildTomTat(),

//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildThongTinSuCo() {
//     return Card(
//       color: Colors.white,

//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.warning_amber_rounded, color: Color(0xff2D7A3A)),

//                 SizedBox(width: 8),

//                 Text(
//                   "THÔNG TIN SỰ CỐ",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xff2D7A3A),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             _rowInfo("Tên sự cố", vm.tenSuCo),

//             const Divider(),

//             _rowInfo("Phòng xảy ra", vm.tenPhong),

//             const Divider(),

//             _rowInfo("Ngày bắt đầu", vm.ngayBatDauText),

//             const Divider(),

//             _rowInfo("Trạng thái", vm.trangThaiText),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDanhSachHopDong() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.assignment_rounded, color: Color(0xff2D7A3A)),
//                 SizedBox(width: 8),
//                 Text(
//                   "DANH SÁCH HỢP ĐỒNG",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xff2D7A3A),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: vm.dsHopDong.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 final item = vm.dsHopDong[index];

//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: const Color(0xffE5E5E5)),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 54,
//                             height: 54,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: const Color(0xffEAF5EC),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Text(
//                               item.maHopDong ?? "",
//                               style: const TextStyle(
//                                 color: Color(0xff2D7A3A),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),

//                           const SizedBox(width: 12),

//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item.tenNguoiDaiDien ?? "",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 3),

//                                 Text(
//                                   "${item.soThanhVien} thành viên",
//                                   style: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xffEAF5EC),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Text(
//                               item.trangThaiText ?? "",
//                               style: const TextStyle(
//                                 color: Color(0xff2D7A3A),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 16),

//                       Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffF8F9FA),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.home_work_outlined,
//                               size: 18,
//                               color: Color(0xff2D7A3A),
//                             ),
//                             const SizedBox(width: 8),
//                             const Expanded(child: Text("Phòng hiện tại")),
//                             Text(
//                               item.phongCuText ?? "",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       ExpansionTile(
//                         tilePadding: EdgeInsets.zero,
//                         childrenPadding: EdgeInsets.zero,
//                         leading: const Icon(
//                           Icons.groups_rounded,
//                           color: Color(0xff2D7A3A),
//                         ),
//                         title: Text(
//                           "Danh sách thành viên (${item.dsThanhVien!.length})",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         children: item.dsThanhVien!
//                             .map(
//                               (e) => ListTile(
//                                 dense: true,
//                                 contentPadding: EdgeInsets.zero,
//                                 leading: const CircleAvatar(
//                                   radius: 18,
//                                   backgroundColor: Color(0xffEAF5EC),
//                                   child: Icon(
//                                     Icons.person,
//                                     size: 18,
//                                     color: Color(0xff2D7A3A),
//                                   ),
//                                 ),
//                                 title: Text(e),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                       const SizedBox(height: 16),

//                       DropdownButtonFormField<PhongHopDongVM>(
//                         isExpanded: true,
//                         itemHeight: 60,

//                         value: item.phongMoiText!.isEmpty
//                             ? null
//                             : vm.dsPhong.firstWhere(
//                                 (e) => e.tenPhong == item.phongMoiText,
//                               ),

//                         selectedItemBuilder: (context) {
//                           return vm.dsPhong.map((e) {
//                             return Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 e.tenPhong ?? "",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             );
//                           }).toList();
//                         },

//                         decoration: InputDecoration(
//                           labelText: "Phòng chuyển đến",
//                           prefixIcon: const Icon(Icons.compare_arrows_rounded),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 16,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(
//                               color: Color(0xffDDDDDD),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: const BorderSide(
//                               color: Color(0xff2D7A3A),
//                             ),
//                           ),
//                         ),

//                         items: vm.dsPhong.map((e) {
//                           return DropdownMenuItem<PhongHopDongVM>(
//                             value: e,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   e.tenPhong ?? "",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(
//                                   "Đang ở ${e.soNguoiDangO}/${e.sucChua} người",
//                                   style: const TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),

//                         onChanged: (value) {
//                           if (value == null) return;

//                           vm.chonPhongMoi(index, value);
//                         },
//                       ),

//                       const SizedBox(height: 16),

//                       if (item.coNhieuHopDong)
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: const Color(0xffFFF8E6),
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: const Color(0xffF5C542)),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Icon(
//                                 Icons.info_outline,
//                                 color: Colors.orange,
//                                 size: 20,
//                               ),

//                               const SizedBox(width: 10),

//                               Expanded(
//                                 child: Text(
//                                   "Người thuê đang có hợp đồng tại: "
//                                   "${item.dsPhongHopDong!.map((e) => e.tenPhong).join(", ")}.\n",

//                                   style: const TextStyle(fontSize: 13),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       const SizedBox(height: 16),

//                       Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffF8F9FA),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 const Expanded(child: Text("Sức chứa")),
//                                 Text(
//                                   "${item.sucChua} người",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 8),

//                             Row(
//                               children: [
//                                 const Expanded(child: Text("Đang ở")),
//                                 Text(
//                                   "${item.soNguoiDangO} người",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 8),

//                             Row(
//                               children: [
//                                 const Expanded(child: Text("Còn trống")),
//                                 Text(
//                                   "${item.soChoTrong} chỗ",
//                                   style: const TextStyle(
//                                     color: Color(0xff2D7A3A),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNgayLuanChuyen() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.calendar_month_rounded, color: Color(0xff2D7A3A)),
//                 SizedBox(width: 8),
//                 Text(
//                   "NGÀY LUÂN CHUYỂN",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xff2D7A3A),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             InkWell(
//               onTap: () => vm.chonNgay(context),
//               borderRadius: BorderRadius.circular(14),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 15,
//                 ),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: const Color(0xffDDDDDD)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.event, color: Color(0xff2D7A3A)),

//                     const SizedBox(width: 10),

//                     Expanded(
//                       child: Text(
//                         vm.ngayLuanChuyenText,
//                         style: const TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),

//                     const Icon(Icons.keyboard_arrow_down_rounded),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGhiChu() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.notes_rounded, color: Color(0xff2D7A3A)),
//                 SizedBox(width: 8),
//                 Text(
//                   "GHI CHÚ",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xff2D7A3A),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             TextField(
//               controller: vm.txtGhiChu,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: "Nhập ghi chú...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: Color(0xffDDDDDD)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: Color(0xff2D7A3A)),
//                 ),
//                 filled: true,
//                 fillColor: const Color(0xffF8F9FA),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTomTat() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.fact_check_outlined, color: Color(0xff2D7A3A)),
//                 SizedBox(width: 8),
//                 Text(
//                   "TÓM TẮT LUÂN CHUYỂN",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Color(0xff2D7A3A),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 18),

//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: vm.dsHopDong.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 return ItemChiTietLuanChuyen(item: vm.dsHopDong[index]);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _rowInfo(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }
