import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/DTO/HopDongPreviewDTO.dart';
import '../../../../models/DTO/PhuongTienPreviewDTO.dart';
import '../../../../models/hoa_don_phong.dart';
import '../../../../Provider/hoa_don_phong_provider.dart';

class TaoHoaDonPhongPageViewModel extends ChangeNotifier {
  final HoadonPhongProvider _hoaDonProvider;
  TaoHoaDonPhongPageViewModel({required HoadonPhongProvider hoaDonProvider})
      : _hoaDonProvider = hoaDonProvider;

  final ImagePicker _picker = ImagePicker();

  bool get isLoading => _hoaDonProvider.isLoading;
  String? get errorMessage => _hoaDonProvider.errorMessage;

  //giá trị khởi tạo
  int phongId = 101;
  String thangNam = "07/2026";
  String tenPhong = "Phòng 101";

  DateTime ngayLapSelected = DateTime.now();

  // CÔNG TẮC BẬT/TẮT TÁCH BIỆT
  bool isChotDienNuoc = true;     // Mục 1: Điện Nước
  bool isTinhTienHopDong = true;  // Mục 2: Tiền Nhà & Xe Hợp đồng

  bool _canCreateDienNuoc = true;
  bool get canCreateDienNuoc => _canCreateDienNuoc;


  final txtDienChiSoCu = TextEditingController(text: "0");
  final txtDienChiSoMoi = TextEditingController(text: "0");
  final txtDienDonGia = TextEditingController(text: "3.500");
  File? imgDien;

  final txtNuocChiSoCu = TextEditingController(text: "0");
  final txtNuocChiSoMoi = TextEditingController(text: "0");
  final txtNuocDonGia = TextEditingController(text: "15.000");
  File? imgNuoc;

  // Chi phí dịch vụ thêm cho mỗi khách & Ghi chú
  final txtTienDichVuKhac = TextEditingController(text: "0");
  final txtGhiChu = TextEditingController();

  List<HopDongPreviewDTO> listContracts = [];
  List<HoaDonPhong> createdHoaDonList = [];

  // Tính tiền Điện phòng
  double get tienDienPhong {
    if (!isChotDienNuoc) return 0;
    int cu = int.tryParse(txtDienChiSoCu.text) ?? 0;
    int moi = int.tryParse(txtDienChiSoMoi.text) ?? 0;
    double gia = double.tryParse(txtDienDonGia.text.replaceAll('.', '')) ?? 0;
    int kw = (moi - cu) > 0 ? (moi - cu) : 0;
    return kw * gia;
  }

  // Tính tiền Nước phòng
  double get tienNuocPhong {
    if (!isChotDienNuoc) return 0;
    int cu = int.tryParse(txtNuocChiSoCu.text) ?? 0;
    int moi = int.tryParse(txtNuocChiSoMoi.text) ?? 0;
    double gia = double.tryParse(txtNuocDonGia.text.replaceAll('.', '')) ?? 0;
    int m3 = (moi - cu) > 0 ? (moi - cu) : 0;
    return m3 * gia;
  }

  double get tongTienDienNuocPhong => tienDienPhong + tienNuocPhong;

  bool get isAllContractsBilled {
    if (listContracts.isEmpty) return false;
    return listContracts.every((hd) => hd.isAlreadyBilled);
  }

  // Tính tổng số hóa đơn thực tế sẽ được tạo ra dựa trên các toggle đang bật
  int get totalInvoicesToCreate {
    int count = 0;
    // Nếu bật tính tiền hợp đồng, cộng thêm số lượng hợp đồng chưa có hóa đơn
    if (isTinhTienHopDong) {
      count += listContracts.where((hd) => !hd.isAlreadyBilled).length;
    }
    // Nếu bật chốt điện nước VÀ được phép tạo (không bị khóa do nợ cũ), cộng thêm 1 hóa đơn Điện Nước
    if (isChotDienNuoc && canCreateDienNuoc) {
      count += 1;
    }
    return count;
  }

  void notifyUI() {
    notifyListeners();
  }

  void toggleChotDienNuoc(bool val) {
    isChotDienNuoc = val;
    notifyListeners();
  }

  void toggleTinhTienHopDong(bool val) {
    isTinhTienHopDong = val;
    notifyListeners();
  }

  void toggleVehicle(PhuongTienPreviewDTO vehicle, bool val) {
    vehicle.isEnabled = val;
    notifyListeners();
  }

  //NẠP DỮ LIỆU BAN ĐẦU
  Future<void> fetchInitData(int pId, String tNam) async {
    phongId = pId;
    thangNam = tNam;

    // lấy dữ liệu init
    await _hoaDonProvider.fetchInitData(phongId: phongId, thangNam: thangNam);

    final data = _hoaDonProvider.initData;
    if (data != null) {
      tenPhong = data['tenPhong'] ?? "Phòng $phongId";

      num rawGiaDien = data['giaDien'] ?? 3500;
      num rawGiaNuoc = data['giaNuoc'] ?? 15000;

      txtDienDonGia.text = rawGiaDien.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
      );

      txtNuocDonGia.text = rawGiaNuoc.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
      );

      if (data['dienNuoc'] != null) {
        final dn = data['dienNuoc'];
        txtDienChiSoCu.text = (dn['chiSoDienCu'] ?? 0).toString();
        txtDienChiSoMoi.text = (dn['chiSoDienMoi'] ?? 0).toString();
        txtNuocChiSoCu.text = (dn['chiSoNuocCu'] ?? 0).toString();
        txtNuocChiSoMoi.text = (dn['chiSoNuocMoi'] ?? 0).toString();
      }
      _canCreateDienNuoc = data['canCreateDienNuoc'] ?? true;
      if (!_canCreateDienNuoc) {
        isChotDienNuoc = false; // Tự động tắt toggle nếu chưa thanh toán tiền điện nước cũ
      }

      if (data['danhSachHopDong'] != null) {
        final rawList = data['danhSachHopDong'] as List? ?? [];
        listContracts = rawList.map((e) => HopDongPreviewDTO.fromMap(e)).toList();
      }

      txtTienDichVuKhac.text = (data['tienDichVuKhacDefault'] ?? 0).toString();
    }

    notifyListeners();
  }

  //CHỌN ẢNH ĐỒNG HỒ
  Future<void> pickMeterImage(bool isDien) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      if (isDien) {
        imgDien = File(image.path);
      } else {
        imgNuoc = File(image.path);
      }
      notifyListeners();
    }
  }


  Future<bool> createBatchHoaDon() async {
    if (!isChotDienNuoc && !isTinhTienHopDong) {
      return false;
    }

    final customContractsPayload = listContracts.map((hd) {
      return {
        'hopDongId': hd.hopDongId,
        'idnt': hd.idnt,
        'calculatedTienPhong': hd.tienPhongCurrent,
        'ghiChu': hd.txtGhiChuCtrl.text,
        'danhSachXe': hd.danhSachXe
            .where((x) => x.isEnabled)
            .map((x) => {
          'id': x.id,
          'bienSo': x.bienSo,
          'hangXe': x.hangXe,
          'chuXe': x.chuXe,
          'price': x.price,
        })
            .toList(),
      };
    }).toList();

    final jsonPayloadStr = jsonEncode(customContractsPayload);
    debugPrint("[FLUTTER PAYLOAD] $jsonPayloadStr");

    bool success = false;
    if (isTinhTienHopDong) {
      success = await _hoaDonProvider.createHoaDonBatch(
        phongId: phongId,
        thangNam: thangNam,
        ngayLap: ngayLapSelected.toIso8601String(),
        isChotDienNuoc: isChotDienNuoc,
        chiSoDienCu: int.tryParse(txtDienChiSoCu.text) ?? 0,
        chiSoDienMoi: int.tryParse(txtDienChiSoMoi.text) ?? 0,
        chiSoNuocCu: int.tryParse(txtNuocChiSoCu.text) ?? 0,
        chiSoNuocMoi: int.tryParse(txtNuocChiSoMoi.text) ?? 0,
        tienDichVuKhac: double.tryParse(txtTienDichVuKhac.text) ?? 0,
        ghiChu: txtGhiChu.text,
        danhSachHopDongJson: jsonPayloadStr,
        anhDienMoi: isChotDienNuoc ? imgDien : null,
        anhNuocMoi: isChotDienNuoc ? imgNuoc : null,
      );
    } else {
      success = await _hoaDonProvider.createHoaDonBatch(
        phongId: phongId,
        thangNam: thangNam,
        ngayLap: ngayLapSelected.toIso8601String(),
        isChotDienNuoc: true,
        chiSoDienCu: int.tryParse(txtDienChiSoCu.text) ?? 0,
        chiSoDienMoi: int.tryParse(txtDienChiSoMoi.text) ?? 0,
        chiSoNuocCu: int.tryParse(txtNuocChiSoCu.text) ?? 0,
        chiSoNuocMoi: int.tryParse(txtNuocChiSoMoi.text) ?? 0,
        tienDichVuKhac: 0,
        ghiChu: txtGhiChu.text,
        danhSachHopDongJson: jsonPayloadStr,
        anhDienMoi: imgDien,
        anhNuocMoi: imgNuoc,
      );
    }

    if (success) {
      createdHoaDonList = _hoaDonProvider.createdHoaDonList;
    }
    notifyListeners();
    return success;
  }

  void setNgayLap(DateTime date) {
    ngayLapSelected = date;
    notifyListeners();
  }
}