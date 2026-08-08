import 'package:AppTroNhaToi/Provider/lap_rap_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/Provider/sua_chua_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/hoa_don_sua_chua.dart';
import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/models/lap_rap.dart';
import 'package:AppTroNhaToi/models/loai_phong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/models/sua_chua.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/PhieuSuaChuaForm/PhieuSuaChuaFormViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/LapRapPage/LapRapPageModel.dart';
import 'package:AppTroNhaToi/widgets/customDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PhieuSuaChuaForm extends StatefulWidget {
  final ThietBi thietBi;
  final SuaChua? suaChua;
  final HoaDonSuaChua? hoaDonSuaChua;
  final LapRap? lapRap;

  const PhieuSuaChuaForm({
    super.key,
    required this.thietBi,
    this.suaChua,
    this.hoaDonSuaChua,
    this.lapRap,
  });

  @override
  State<PhieuSuaChuaForm> createState() => _PhieuSuaChuaFormState();
}

class _PhieuSuaChuaFormState extends State<PhieuSuaChuaForm> {
  late PhieuSuaChuaViewModel vm;

  @override
  void initState() {
    super.initState();

    vm = PhieuSuaChuaViewModel(
      phongProvider: context.read<PhongProvider>(),
      suaChuaProvider: context.read<SuaChuaProvider>(),
      lapRapProvider: context.read<LapRapProvider>(),
    );

    vm.init(
      widget.thietBi,
      suaChuaData: widget.suaChua,
      hoaDonData: widget.hoaDonSuaChua,
      lapRapCoDinhData: widget.lapRap,
    );

    vm.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  Widget _dropDownPhong() {
    final ItemPhong? itemPhongCoDinh =
        vm.lapDatBiKhoa && vm.phongDaChonId != null
        ? ItemPhong(
            phongId: vm.phongDaChonId!,
            tenPhong: vm.tenPhongCoDinh ?? "Phòng #${vm.phongDaChonId}",
            trangThai: 1,
            moTa: '',
            maLoaiPhong: 0,
            loaiPhong: LoaiPhong(
              maLoaiPhong: 0,
              tenLoaiPhong: 'Chưa rõ',
              dienTich: 0,
              soNguoiToiDa: 0,
              giaTien: 0,
            ),
            dsHopDong: [],
            giahientai: 0.0,
          )
        : null;

    final danhSachHienThi = vm.lapDatBiKhoa && itemPhongCoDinh != null
        ? [itemPhongCoDinh]
        : vm.dsPhong;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdownSearch<ItemPhong>(
          label: "Phòng lắp đặt",
          hintText: "-- Chọn phòng --",
          items: danhSachHienThi,
          selectedItem: vm.lapDatBiKhoa
              ? itemPhongCoDinh
              : vm.dsPhong
                    .where((e) => e.phongId == vm.phongDaChonId)
                    .cast<ItemPhong?>()
                    .firstOrNull,
          enabled: !vm.lapDatBiKhoa,
          itemAsString: (item) => item.tenPhong,
          onChanged: (value) {
            vm.chonPhong(value?.phongId);
          },
        ),

        if (vm.errPhong != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              vm.errPhong!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _dropDownLapDat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        const Text(
          "Lắp đặt",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),

        IgnorePointer(
          ignoring: !vm.coThePhongLapDat,
          child: Opacity(
            opacity: vm.coThePhongLapDat ? 1 : 0.5,
            child: CustomDropdownSearch<LapRapPageModel>(
              hintText: "-- Chọn lắp đặt --",
              items: vm.dsLapRapTheoPhong,
              enabled: !vm.lapDatBiKhoa,
              selectedItem: vm.dsLapRapTheoPhong
                  .where((e) => e.lapRap.id == vm.lapRapDaChonId)
                  .cast<LapRapPageModel?>()
                  .firstOrNull,
              itemAsString: (item) =>
                  "#${item.lapRap.id} - ${formatDate(item.lapRap.ngayLap)}",
              onChanged: (value) {
                vm.chonLapRap(value?.lapRap.id);
              },
            ),
          ),
        ),

        if (vm.errPhong != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              vm.errPhong!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: false,

        leadingWidth: 52,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, color: Colors.black),
            ),
          ),
        ),

        titleSpacing: 12,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lịch sử sửa chữa",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            Text(
              "${widget.thietBi.tenThietBi} ",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// THÔNG TIN SỰ CỐ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin sự cố",
                    style: TextStyle(
                      color: Color(0xff2D7A3A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),
                  _dropDownPhong(),
                  const SizedBox(height: 18),
                  _dropDownLapDat(),
                  const SizedBox(height: 18),
                  _input(
                    title: "Ngày sửa chữa",
                    hint: "dd/MM/yyyy",
                    readOnly: true,
                    controller: vm.txtNgaySuaChua,
                    errorText: vm.errNgaySuaChua,
                    keyboardType: TextInputType.number,
                    inputFormatters: [MaskedInputFormatter('##/##/####')],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined, size: 20),
                      onPressed: () async {
                        await vm.chonNgay(context, vm.txtNgaySuaChua);
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  _input(
                    title: "Nguyên nhân / Triệu chứng",
                    controller: vm.txtNguyenNhan,
                    errorText: vm.errNguyenNhan,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// TẠO HÓA ĐƠN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tạo hóa đơn",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  Switch(
                    value: vm.taoHoaDon,
                    activeColor: const Color(0xff2D7A3A),
                    onChanged: (value) {
                      vm.doiTrangThaiTaoHoaDon(value);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (vm.taoHoaDon)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thông tin hóa đơn",
                      style: TextStyle(
                        color: Color(0xff2D7A3A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _input(
                      title: "Ngày lập hóa đơn",
                      hint: "dd/MM/yyyy",
                      controller: vm.txtNgayHoaDon,
                      errorText: vm.errNgayHoaDon,

                      keyboardType: TextInputType.number,
                      inputFormatters: [MaskedInputFormatter('##/##/####')],
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        onPressed: () async {
                          await vm.chonNgay(context, vm.txtNgayHoaDon);
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    _input(
                      title: "Giá tiền sửa chữa",
                      hint: "0",
                      controller: vm.txtChiPhi,
                      errorText: vm.errChiPhi,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        DinhDangGiaVN(),
                      ],
                      suffixText: "Vnd",
                    ),

                    const SizedBox(height: 18),

                    /// Dropdown Loại sửa chữa
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          "Loai Sửa Chửa",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CustomDropdownSearch<int>(
                          items: vm.dsLoaiSua.keys.toList(),
                          selectedItem: vm.loaiSua!,
                          itemAsString: (item) => vm.dsLoaiSua[item]!,
                          onChanged: (value) {
                            if (value != null) {
                              vm.setLoaiSua(value);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    /// Dropdown trạng thái
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(
                          "Trạng thái",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CustomDropdownSearch<int>(
                          items: vm.dsTrangThai.keys.toList(),
                          selectedItem: vm.trangThai,
                          itemAsString: (item) => vm.dsTrangThai[item]!,
                          onChanged: (value) {
                            if (value != null) {
                              vm.setTrangThai(value);
                            }
                          },
                          popupHeight: 200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2D7A3A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () async {
              final result = await vm.luu();

              if (result != null && mounted) {
                Navigator.pop(context, result);
              }
            },
            child: const Text(
              "Lưu phiếu sửa chữa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget _input({
    required String title,
    String? hint,
    required TextEditingController controller,
    String? errorText,
    Widget? suffixIcon,
    String? suffixText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    bool readOnly = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff4A4A4A),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            errorText: null,

            suffixIcon: suffixIcon,

            suffixText: suffixText,

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 14,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffE5E5E5)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xff2D7A3A)),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),

        if (errorText != null) ...[
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }
}
