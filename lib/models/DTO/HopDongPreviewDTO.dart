import 'package:flutter/material.dart';
import 'PhuongTienPreviewDTO.dart';

class HopDongPreviewDTO {
  final String hopDongId;
  final int idnt;
  final String hoTen;
  final String sdt;
  final double giaPhongGoc;
  final int soNgayO;
  final int soNgayTrongThang;
  final double calculatedTienPhong;
  final String noteFormula;
  final List<PhuongTienPreviewDTO> danhSachXe;
  final bool isAlreadyBilled;
  final Map<String, dynamic>? existingInvoice;

  // Controller riêng để chỉnh sửa tiền phòng và ghi chú trực tiếp trên UI
  late TextEditingController txtTienPhongCtrl;
  late TextEditingController txtGhiChuCtrl;

  HopDongPreviewDTO({
    required this.hopDongId,
    required this.idnt,
    required this.hoTen,
    required this.sdt,
    required this.giaPhongGoc,
    required this.soNgayO,
    required this.soNgayTrongThang,
    required this.calculatedTienPhong,
    required this.noteFormula,
    required this.danhSachXe,
    required this.isAlreadyBilled,
    this.existingInvoice,
  }) {
    txtTienPhongCtrl = TextEditingController(
      text: _formatNumber(calculatedTienPhong),
    );
    txtGhiChuCtrl = TextEditingController();
  }

  static String _formatNumber(double amount) {
    final integerPart = amount.round().toString();
    return integerPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }

  factory HopDongPreviewDTO.fromMap(Map<String, dynamic> map) {
    final rawXe = map['danhSachXe'] as List? ?? [];
    return HopDongPreviewDTO(
      hopDongId: map['hopDongId']?.toString() ?? '',
      idnt: map['idnt'] ?? 0,
      hoTen: map['hoTen'] ?? 'Khách thuê',
      sdt: map['sdt'] ?? '',
      giaPhongGoc: (map['giaPhongGoc'] as num?)?.toDouble() ?? 0,
      soNgayO: map['soNgayO'] ?? 0,
      soNgayTrongThang: map['soNgayTrongThang'] ?? 30,
      calculatedTienPhong: (map['calculatedTienPhong'] as num?)?.toDouble() ?? 0,
      noteFormula: map['noteFormula'] ?? '',
      danhSachXe: rawXe.map((x) => PhuongTienPreviewDTO.fromMap(x)).toList(),
      isAlreadyBilled: map['isAlreadyBilled'] ?? false,
      existingInvoice: map['existingInvoice'],
    );
  }

  double get tienPhongCurrent {
    String cleanText = txtTienPhongCtrl.text.replaceAll('.', '').replaceAll(',', '').trim();
    return double.tryParse(cleanText) ?? 0;
  }

  double get tongTienXeCurrent {
    return danhSachXe
        .where((x) => x.isEnabled)
        .fold(0.0, (sum, x) => sum + x.price);
  }

  double get tamTinhCaNhan => tienPhongCurrent + tongTienXeCurrent;
}