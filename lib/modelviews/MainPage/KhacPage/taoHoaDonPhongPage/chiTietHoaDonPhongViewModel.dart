import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../Provider/hoa_don_phong_provider.dart';
import '../../../../Provider/phong_provider.dart';

class ChiTietHoaDonPhongViewModel extends ChangeNotifier {
  final HoadonPhongProvider provider;
  final PhongProvider _phongProvider;

  bool isLoading = false;
  bool isDeleting = false;
  String? errorMessage;

  // Theo dõi riêng từng hóa đơn đang gửi (theo mã hóa đơn) để chỉ icon Gửi
  // của đúng item đó xoay loading, không ảnh hưởng các item khác trong list.
  final Set<String> _dangGuiMaHoaDon = {};
  bool isSendingInvoice(String maHoaDon) => _dangGuiMaHoaDon.contains(maHoaDon);

  int phongId = 0;
  String thangNam = "";
  String tenPhong = "";

  List<Map<String, dynamic>> listHoaDon = [];

  ChiTietHoaDonPhongViewModel({
    required this.provider,
    required PhongProvider phongProvider,
  }) : _phongProvider = phongProvider;

  double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }

  //TẢI DANH SÁCH HÓA ĐƠN THẬT TỪ BACKEND
  Future<void> fetchInvoicesByPhong({
    required int pId,
    required String tNam,
  }) async {
    phongId = pId;
    thangNam = tNam;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final phongInList = _phongProvider.listPhong
          .where((p) => p.phongId == phongId)
          .firstOrNull;

      if (phongInList != null) {
        tenPhong = phongInList.tenPhong;
      } else {
        try {
          final info = await _phongProvider.getInforPhong(phongId);
          tenPhong = info.tenPhong;
        } catch (_) {
          tenPhong = "Phòng $phongId";
        }
      }
      await provider.fetchDanhSachByPhong(phongId: phongId, thangNam: thangNam);

      listHoaDon = provider.danhSachHoaDonByPhong.map((inv) {
        Map<String, dynamic> parsedJson = {};
        if (inv['chiTietJson'] != null &&
            inv['chiTietJson'].toString().isNotEmpty) {
          try {
            parsedJson = jsonDecode(inv['chiTietJson']);
          } catch (_) {}
        }

        bool isDienNuoc =
            parsedJson['type'] == 'DIEN_NUOC' ||
            parsedJson['isDienNuocOnly'] == true;

        double tongTien = _toDouble(inv['soTien']) > 0
            ? _toDouble(inv['soTien'])
            : _toDouble(parsedJson['tongThanhToan']);

        double tongDaThu = _toDouble(inv['tongDaThu']);
        double conNo = _toDouble(inv['conNo']);

        int lanGhi = _toInt(parsedJson['lanGhi']) > 0
            ? _toInt(parsedJson['lanGhi'])
            : 1;

        String finalGhiChu = inv['ghiChu'] ?? parsedJson['ghiChu'] ?? '';
        if (isDienNuoc && finalGhiChu.isEmpty) {
          finalGhiChu = "Chốt chỉ số điện nước tháng $thangNam (Lần $lanGhi)";
        }

        return {
          "maHoaDon": inv['maHoaDon'] ?? parsedJson['maHoaDon'] ?? '',
          "hopDongId": inv['hopDongId'] ?? parsedJson['hopDongId'] ?? '',
          "isDienNuoc": isDienNuoc,
          "lanGhi": lanGhi,
          "hoTen": inv['hoTenKhach'] ?? parsedJson['hoTen'] ?? 'Khách thuê',
          "tenPhong":
              inv['tenPhong'] ?? parsedJson['tenPhong'] ?? 'Phòng $phongId',
          "thangNam": inv['thangNam'] ?? thangNam,
          "ngayLap": inv['ngayLap'] ?? parsedJson['ngayLap'],
          "tongTien": tongTien,
          "tongDaThu": tongDaThu,
          "conNo": conNo,
          "trangThai": _toInt(inv['trangThai']),
          "formulaText":
              parsedJson['danhSachKhachThue'] != null &&
                  (parsedJson['danhSachKhachThue'] as List).isNotEmpty
              ? parsedJson['danhSachKhachThue'][0]['noteFormula']
              : null,
          "danhSachXe": parsedJson['danhSachXe'] ?? [],
          "tienDichVuKhac": _toDouble(parsedJson['tienDichVuKhac']),
          "tongTienPhong": _toDouble(parsedJson['tongTienPhong']),
          "ghiChu": finalGhiChu,
          "chiTietDienNuoc": parsedJson['chiTietDienNuoc'],
        };
      }).toList();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatMoney(num? amount) {
    if (amount == null) return "0đ";
    final integerPart = amount.round().toString();
    final formatted = integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return "${formatted}đ";
  }

  String _formatDateStr(String? isoString) {
    if (isoString == null) return "";
    try {
      final dt = DateTime.parse(isoString);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return isoString;
    }
  }

  //HÀM XỬ LÝ TẠO VÀ XUẤT FILE PDF HÓA ĐƠN CHI TIẾT TỪNG KHOẢN PHÍ
  Future<void> exportOrSharePdf(Map<String, dynamic> item) async {
    final maHoaDon = item['maHoaDon'] ?? '';
    final bytes = await _buildPdfBytes(item);

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
      name: 'HoaDon_$maHoaDon.pdf',
    );
  }

  //HÀM TẠO PDF RỒI MỞ BẢNG CHIA SẺ CỦA HỆ ĐIỀU HÀNH (GỬI QUA ZALO/MESSENGER/...)
  Future<bool> shareInvoicePdf(Map<String, dynamic> item) async {
    final maHoaDon = item['maHoaDon'] ?? '';
    _dangGuiMaHoaDon.add(maHoaDon);
    notifyListeners();

    try {
      final tNam = item['thangNam'] ?? thangNam;
      final bytes = await _buildPdfBytes(item);

      return await Printing.sharePdf(
        bytes: bytes,
        filename: 'HoaDon_$maHoaDon.pdf',
        subject: 'Hóa đơn tháng $tNam - $tenPhong',
        body: 'Hóa đơn tháng $tNam - Phòng $tenPhong.',
      );
    } finally {
      _dangGuiMaHoaDon.remove(maHoaDon);
      notifyListeners();
    }
  }

  Future<Uint8List> _buildPdfBytes(Map<String, dynamic> item) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontItalic = await PdfGoogleFonts.robotoItalic();

    final bool isDienNuoc = item['isDienNuoc'] == true;
    final String hoTen = item['hoTen'] ?? 'Khách thuê';
    final String maHoaDon = item['maHoaDon'] ?? '';
    final String tenPhong = item['tenPhong'] ?? 'Phòng';
    final String thangNam = item['thangNam'] ?? '';
    final String ngayLap = _formatDateStr(item['ngayLap']?.toString());
    final double tongTien = _toDouble(item['tongTien']);
    final double tongDaThu = _toDouble(item['tongDaThu']);
    final double conNo = _toDouble(item['conNo']);
    final String ghiChu = item['ghiChu'] ?? '';

    // Dữ liệu riêng cho Hợp đồng
    final double tongTienPhong = _toDouble(item['tongTienPhong']);
    final double tienDichVuKhac = _toDouble(item['tienDichVuKhac']);
    final List danhSachXe = item['danhSachXe'] ?? [];
    final double tongTienXe = danhSachXe.fold(
      0.0,
      (sum, x) => sum + _toDouble(x['price']),
    );
    final String formulaText = item['formulaText'] ?? '';

    // Dữ liệu riêng cho Điện Nước
    final chiTietDN = item['chiTietDienNuoc'];
    final dien = chiTietDN?['dien'] ?? {};
    final nuoc = chiTietDN?['nuoc'] ?? {};

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
          italic: fontItalic,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              pw.Center(
                child: pw.Text(
                  isDienNuoc
                      ? "HÓA ĐƠN TIỀN ĐIỆN NƯỚC"
                      : "HÓA ĐƠN THUÊ PHÒNG TRỌ",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  "Kỳ hóa đơn: Tháng $thangNam",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Mã hóa đơn: $maHoaDon",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text("Ngày lập: $ngayLap"),
                ],
              ),
              pw.Divider(),
              pw.Text("Phòng: $tenPhong"),
              if (!isDienNuoc) pw.Text("Khách thuê: $hoTen"),
              pw.SizedBox(height: 10),

              //PHÂN TÁCH HIỂN THỊ CHI TIẾT GIỮA ĐIỆN NƯỚC VÀ HỢP ĐỒNG
              if (isDienNuoc) ...[
                pw.Text(
                  "CHI TIẾT TIÊU THỤ ĐIỆN NƯỚC:",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 6),

                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(6),
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "• Điện (kWh):",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            _formatMoney(dien['thanhTien']),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        "Chỉ số: ${dien['cu'] ?? 0} - ${dien['moi'] ?? 0} (Sử dụng: ${dien['suDung'] ?? 0}) | Đơn giá: ${_formatMoney(dien['donGia'])}",
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "• Nước (m³):",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            _formatMoney(nuoc['thanhTien']),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        "Chỉ số: ${nuoc['cu'] ?? 0} - ${nuoc['moi'] ?? 0} (Sử dụng: ${nuoc['suDung'] ?? 0}) | Đơn giá: ${_formatMoney(nuoc['donGia'])}",
                        style: const pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                pw.Text(
                  "CHI TIẾT CÁC KHOẢN PHÍ:",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.green800,
                  ),
                ),
                pw.SizedBox(height: 6),

                // Tiền phòng
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "• Tiền phòng:",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          if (formulaText.isNotEmpty)
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(
                                left: 10,
                                top: 2,
                              ),
                              child: pw.Text(
                                formulaText,
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    pw.Text(
                      _formatMoney(tongTienPhong),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),

                // Tiền xe
                if (danhSachXe.isNotEmpty) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "• Tiền gửi xe (${danhSachXe.length} chiếc):",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        _formatMoney(tongTienXe),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  ...danhSachXe.map(
                    (xe) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10, top: 2),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "- ${xe['hangXe'] ?? 'Xe'} (${xe['bienSo'] ?? ''})",
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            _formatMoney(xe['price']),
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                ],

                // Dịch vụ phát sinh
                if (tienDichVuKhac > 0) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "• Dịch vụ phát sinh thêm:",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        _formatMoney(tienDichVuKhac),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 6),
                ],
              ],

              if (ghiChu.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  "Ghi chú: $ghiChu",
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    fontSize: 10,
                    color: PdfColors.grey800,
                  ),
                ),
              ],

              pw.SizedBox(height: 10),
              pw.Divider(),

              // Tổng kết
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Tổng hóa đơn:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    _formatMoney(tongTien),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Đã thanh toán:"),
                  pw.Text(_formatMoney(tongDaThu)),
                ],
              ),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "CÒN LẠI PHẢI NỘP:",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 13,
                      color: PdfColors.red900,
                    ),
                  ),
                  pw.Text(
                    _formatMoney(conNo),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 13,
                      color: PdfColors.red900,
                    ),
                  ),
                ],
              ),

              pw.Spacer(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Người lập phiếu",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 25),
                        pw.Text(
                          "(Ký, ghi rõ họ tên)",
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Khách thuê",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 25),
                        pw.Text(
                          "(Ký, ghi rõ họ tên)",
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<bool> deleteHoaDonByMa(String maHoaDon) async {
    isDeleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await provider.deleteHoaDon(maHoaDon: maHoaDon);
      if (success) {
        listHoaDon.removeWhere((item) => item['maHoaDon'] == maHoaDon);
      } else {
        errorMessage = provider.errorMessage ?? "Xóa hóa đơn thất bại!";
      }
      return success;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}
