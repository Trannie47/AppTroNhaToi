import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../../Provider/hoa_don_phong_provider.dart';
import '../../../../../../modelviews/MainPage/KhacPage/taoHoaDonPhongPage/taoHoaDonPhongPageViewModel.dart';
import 'ChiTietHoaDonPage.dart';

class TaoHoaDonPage extends StatefulWidget {
  final int phongId;
  final String? thangNam;

  const TaoHoaDonPage({super.key, required this.phongId, this.thangNam});

  @override
  State<TaoHoaDonPage> createState() => _TaoHoaDonPageState();
}

class _TaoHoaDonPageState extends State<TaoHoaDonPage> {
  late String _currentThangNam;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentThangNam =
        widget.thangNam ??
        "${now.month.toString().padLeft(2, '0')}/${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HoadonPhongProvider())],
      child: Consumer<HoadonPhongProvider>(
        builder: (context, hoaDonProvider, child) {
          return ChangeNotifierProvider(
            create: (_) {
              final vm = TaoHoaDonPhongPageViewModel(
                hoaDonProvider: hoaDonProvider,
              );
              vm.fetchInitData(widget.phongId, _currentThangNam);
              return vm;
            },
            child: Consumer<TaoHoaDonPhongPageViewModel>(
              builder: (context, vm, child) {
                final countPending = vm.listContracts
                    .where((hd) => !hd.isAlreadyBilled)
                    .length;

                return Scaffold(
                  backgroundColor: const Color(0xffF4F6F8),
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.5,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    title: Consumer<TaoHoaDonPhongPageViewModel>(
                      builder: (context, vm, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tạo hóa đơn - ${vm.tenPhong}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Kỳ hóa đơn: Tháng ${vm.thangNam}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            //NÚT BẤM ĐỔI KỲ HÓA ĐƠN
                            InkWell(
                              onTap: () => vm.chonKyHoaDon(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEAF3EB),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xffC8E6C9),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      size: 14,
                                      color: Color(0xff2E7D32),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Đổi kỳ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2E7D32),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  body: vm.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff2E7D32),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // KHUNG THÔNG BÁO MÀU VÀNG KÈM NÚT "XEM"
                              if (vm.isAllContractsBilled &&
                                  vm.isTinhTienHopDong)
                                InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChiTietHoaDonPage(
                                          phongId: widget.phongId,
                                          thangNam: _currentThangNam,
                                        ),
                                      ),
                                    );

                                    if (mounted) {
                                      vm.fetchInitData(
                                        widget.phongId,
                                        _currentThangNam,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF8E1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xffFFE082),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Color(0xff8D6E63),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Expanded(
                                          child: Text(
                                            "Tất cả hợp đồng trong phòng này đã được tạo hóa đơn cho kỳ này.",
                                            style: TextStyle(
                                              color: Color(0xff8D6E63),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFE082),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Row(
                                            children: [
                                              Text(
                                                "Xem",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff5D4037),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 10,
                                                color: Color(0xff5D4037),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // HEADER DÙNG CHUNG: NGÀY LẬP HÓA ĐƠN
                              Container(
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ngày lập hóa đơn:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: vm.ngayLapSelected,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (picked != null)
                                          vm.setNgayLap(picked);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF8F9FA),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month_outlined,
                                              size: 16,
                                              color: Color(0xff2E7D32),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              formatDate(vm.ngayLapSelected),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color(0xff2E7D32),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ĐIỆN NƯỚC CẢ PHÒNG
                              // ĐIỆN NƯỚC CẢ PHÒNG
                              _buildCardSection(
                                title: "1. Chốt chỉ số Điện Nước (Cả Phòng)",
                                trailing: Switch(
                                  value: vm.canCreateDienNuoc
                                      ? vm.isChotDienNuoc
                                      : false,
                                  activeColor: const Color(0xff2E7D32),
                                  onChanged: vm.canCreateDienNuoc
                                      ? (val) => vm.toggleChotDienNuoc(val)
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // THƯỜNG HỢP 1: Đã tạo hóa đơn điện nước kỳ này nhưng chưa thanh toán (bị khóa cứng, hiện nút XEM)
                                    if (!vm.canCreateDienNuoc) ...[
                                      InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChiTietHoaDonPage(
                                                    phongId: widget.phongId,
                                                    thangNam: _currentThangNam,
                                                  ),
                                            ),
                                          );

                                          if (mounted) {
                                            vm.fetchInitData(
                                              widget.phongId,
                                              _currentThangNam,
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffEBF3FE),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue.shade200,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.bolt,
                                                color: Color(0xff1565C0),
                                                size: 22,
                                              ),
                                              const SizedBox(width: 10),
                                              const Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Hóa đơn Điện Nước kỳ này đã được tạo.",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xff1565C0,
                                                        ),
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      "Chưa thanh toán. Nhấn để xem chi tiết.",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      "XEM",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xff1565C0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 10,
                                                      color: Color(0xff1565C0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]
                                    // Được phép tạo VÀ người dùng đang BẬT công tắc chốt điện nước -> HIỂN THỊ Ô NHẬP CHỈ SỐ
                                    else if (vm.isChotDienNuoc &&
                                        vm.canCreateDienNuoc) ...[
                                      _buildMeterInput(
                                        label: "Chỉ số Điện (kWh)",
                                        cuCtrl: vm.txtDienChiSoCu,
                                        moiCtrl: vm.txtDienChiSoMoi,
                                        giaCtrl: vm.txtDienDonGia,
                                        calculatedMoney: vm.tienDienPhong,
                                        imageFile: vm.imgDien,
                                        hasError: vm.isDienError,
                                        onPickImage: () =>
                                            vm.pickMeterImage(true),
                                        onChanged: () => vm.clearErrors(),
                                      ),
                                      const Divider(height: 24),
                                      _buildMeterInput(
                                        label: "Chỉ số Nước (m³)",
                                        cuCtrl: vm.txtNuocChiSoCu,
                                        moiCtrl: vm.txtNuocChiSoMoi,
                                        giaCtrl: vm.txtNuocDonGia,
                                        calculatedMoney: vm.tienNuocPhong,
                                        imageFile: vm.imgNuoc,
                                        hasError: vm.isNuocError,
                                        onPickImage: () =>
                                            vm.pickMeterImage(false),
                                        onChanged: () => vm.clearErrors(),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Tổng Điện + Nước cả phòng:",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              formatMoney(
                                                vm.tongTienDienNuocPhong,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2E7D32),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                    // TRƯỜNG HỢP 3: Người dùng chủ động TẮT công tắc chốt điện nước
                                    else ...[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Đã tắt chốt điện nước. Hệ thống không tính tiền điện nước cho lần tạo này.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // TÍNH TIỀN HỢP ĐỒNG
                              _buildCardSection(
                                title: "2. Tính tiền Hợp đồng (Nhà & Xe)",
                                trailing: Switch(
                                  value: vm.isTinhTienHopDong,
                                  activeColor: const Color(0xff2E7D32),
                                  onChanged: (val) =>
                                      vm.toggleTinhTienHopDong(val),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (vm.isTinhTienHopDong) ...[
                                      ...vm.listContracts.map((hd) {
                                        if (hd.isAlreadyBilled) {
                                          return InkWell(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChiTietHoaDonPage(
                                                        phongId: widget.phongId,
                                                        thangNam:
                                                            _currentThangNam,
                                                      ),
                                                ),
                                              );

                                              if (mounted) {
                                                vm.fetchInitData(
                                                  widget.phongId,
                                                  _currentThangNam,
                                                );
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${hd.hoTen} (${hd.hopDongId})",
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        const Text(
                                                          "Hợp đồng này đã được lập hóa đơn",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 5,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "XEM",
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                              0xff2E7D32,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 2),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 10,
                                                          color: Color(
                                                            0xff2E7D32,
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

                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFAFAFA),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${hd.hoTen} (${hd.hopDongId})",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      "CHỜ TẠO",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                          0xff2E7D32,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),

                                              Row(
                                                children: [
                                                  const Text(
                                                    "Tiền phòng:",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 38,
                                                      child: TextField(
                                                        controller:
                                                            hd.txtTienPhongCtrl,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                          color: Color(
                                                            0xff2E7D32,
                                                          ),
                                                        ),
                                                        decoration: InputDecoration(
                                                          suffixText: "đ",
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 8,
                                                              ),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                        ),
                                                        onChanged: (_) =>
                                                            vm.notifyUI(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                hd.noteFormula,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),

                                              if (hd.danhSachXe.isNotEmpty) ...[
                                                const Divider(height: 16),
                                                const Text(
                                                  "Phương tiện đăng ký:",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                ...hd.danhSachXe.map(
                                                  (xe) => Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 2,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () =>
                                                          vm.toggleVehicle(
                                                            xe,
                                                            !xe.isEnabled,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: Checkbox(
                                                              value:
                                                                  xe.isEnabled,
                                                              activeColor:
                                                                  const Color(
                                                                    0xff2E7D32,
                                                                  ),
                                                              onChanged: (val) =>
                                                                  vm.toggleVehicle(
                                                                    xe,
                                                                    val ?? true,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              "${xe.hangXe} - BKS: ${xe.bienSo}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    xe.isEnabled
                                                                    ? Colors
                                                                          .black87
                                                                    : Colors
                                                                          .grey,
                                                                decoration:
                                                                    xe.isEnabled
                                                                    ? null
                                                                    : TextDecoration
                                                                          .lineThrough,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            formatMoney(
                                                              xe.price,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  xe.isEnabled
                                                                  ? Colors
                                                                        .black87
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],

                                              // Ô NHẬP GHI CHÚ RIÊNG CHO TỪNG HỢP ĐỒNG
                                              const SizedBox(height: 12),
                                              TextField(
                                                controller: hd.txtGhiChuCtrl,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Nhập ghi chú riêng cho hóa đơn này...",
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              const Divider(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Tạm tính cá nhân:",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    formatMoney(
                                                      hd.tamTinhCaNhan,
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Color(0xff2E7D32),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ] else ...[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Đã TẮT tính tiền Hợp đồng. Hệ thống chỉ thực hiện tính tiền Điện Nước đợt này.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // DỊCH VỤ PHÁT SINH THÊM
                              if (vm.isTinhTienHopDong &&
                                  !vm.isAllContractsBilled)
                                _buildCardSection(
                                  title:
                                      "3. Dịch vụ phát sinh thêm (Mỗi Hợp đồng)",
                                  child: Column(
                                    children: [
                                      _buildPriceRow(
                                        "Tiền dịch vụ thêm / khách",
                                        vm.txtTienDichVuKhac,
                                        () => vm.notifyUI(),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 80),
                            ],
                          ),
                        ),

                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "XUẤT HÓA ĐƠN",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                () {
                                  int hopDongCount = vm.isTinhTienHopDong
                                      ? countPending
                                      : 0;
                                  bool dienNuocActive =
                                      vm.isChotDienNuoc && vm.canCreateDienNuoc;

                                  if (hopDongCount > 0 && dienNuocActive) {
                                    return "${hopDongCount + 1} Hóa đơn sẽ tạo"; // Gồm hợp đồng + 1 điện nước
                                  } else if (hopDongCount > 0) {
                                    return "$hopDongCount Hóa đơn Hợp đồng";
                                  } else if (dienNuocActive) {
                                    return "1 Hóa đơn Điện Nước";
                                  } else {
                                    return "0 Hóa đơn";
                                  }
                                }(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed:
                              (vm.isLoading ||
                                  (!vm.isChotDienNuoc && !vm.isTinhTienHopDong))
                              ? null
                              : () async {
                                  final success = await vm.createBatchHoaDon();
                                  if (mounted) {
                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Tạo hóa đơn đợt này thành công!",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChiTietHoaDonPage(
                                                phongId: widget.phongId,
                                                thangNam: _currentThangNam,
                                              ),
                                        ),
                                      );

                                      if (mounted) {
                                        vm.fetchInitData(
                                          widget.phongId,
                                          _currentThangNam,
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            vm.errorMessage ??
                                                "Tạo hóa đơn thất bại!",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (vm.isLoading ||
                                    (!vm.isChotDienNuoc &&
                                        !vm.isTinhTienHopDong) ||
                                    (vm.isTinhTienHopDong &&
                                        countPending == 0 &&
                                        (!vm.isChotDienNuoc ||
                                            !vm.canCreateDienNuoc)))
                                ? Colors.grey.shade400
                                : const Color(0xff2E7D32),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  () {
                                    int hopDongCount = vm.isTinhTienHopDong
                                        ? countPending
                                        : 0;
                                    bool dienNuocActive =
                                        vm.isChotDienNuoc &&
                                        vm.canCreateDienNuoc;

                                    if (hopDongCount > 0 && dienNuocActive) {
                                      return "TẠO ${hopDongCount + 1} HÓA ĐƠN";
                                    } else if (hopDongCount > 0) {
                                      return "TẠO $hopDongCount HÓA ĐƠN";
                                    } else if (dienNuocActive) {
                                      return "CHỐT ĐIỆN NƯỚC";
                                    } else {
                                      return "HẾT HÓA ĐƠN ĐỂ TẠO";
                                    }
                                  }(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xff2E7D32),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildMeterInput({
    required String label,
    required TextEditingController cuCtrl,
    required TextEditingController moiCtrl,
    required TextEditingController giaCtrl,
    required double calculatedMoney,
    required dynamic imageFile,
    required bool hasError,
    required VoidCallback onPickImage,
    required VoidCallback onChanged,
  }) {
    int cu = int.tryParse(cuCtrl.text) ?? 0;
    int moi = int.tryParse(moiCtrl.text) ?? 0;
    int suDung = (moi - cu) > 0 ? (moi - cu) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSmallInput("Chỉ số cũ", cuCtrl, false, onChanged),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallInput(
                "Chỉ số mới",
                moiCtrl,
                hasError,
                onChanged,
              ),
            ), // Tô đỏ nếu có lỗi
            const SizedBox(width: 8),
            Expanded(child: _buildMoneyInput("Đơn giá", giaCtrl, onChanged)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tiêu thụ: $suDung | Thành tiền:",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(
              formatMoney(calculatedMoney),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff2E7D32),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPickImage,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffF8F9FA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              imageFile != null
                  ? "Đã đính kèm ảnh bằng chứng"
                  : "Tải ảnh đồng hồ làm bằng chứng",
              style: TextStyle(
                fontSize: 12,
                color: imageFile != null
                    ? Colors.green.shade700
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallInput(
    String label,
    TextEditingController ctrl,
    bool hasError,
    VoidCallback onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: hasError ? Colors.red : Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 36,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: hasError ? Colors.red : Colors.black87,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade400,
                  width: hasError ? 2.0 : 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade400,
                  width: hasError ? 2.0 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xff2E7D32),
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyInput(
    String label,
    TextEditingController ctrl,
    VoidCallback onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        SizedBox(
          height: 36,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              suffixText: "đ",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onChanged: (val) {
              String clean = val.replaceAll('.', '').replaceAll(',', '');
              if (clean.isNotEmpty) {
                num? number = num.tryParse(clean);
                if (number != null) {
                  String formatted = number.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]}.',
                  );
                  if (formatted != val) {
                    ctrl.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                }
              }
              onChanged();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    TextEditingController ctrl,
    VoidCallback onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        SizedBox(
          width: 120,
          height: 36,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              suffixText: "đ",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onChanged: (_) => onChanged(),
          ),
        ),
      ],
    );
  }
}
