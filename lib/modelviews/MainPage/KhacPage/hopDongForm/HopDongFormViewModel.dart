import 'dart:convert';
import 'dart:io';

import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/Provider/phong_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/DTO/NguoiThueAvailableDTO.dart';
import 'package:AppTroNhaToi/states/create_contract_state.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/map_dio_error_to_message.dart';
import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../models/DTO/NguoiOGhepDTO.dart';
import '../../../../states/hop_dong_update_state.dart';

class HopDongFormViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final NguoiThueProvider _nguoiThueProvider;
  final PhongProvider _phongProvider;

  HopDongFormViewModel(this._hopDongProvider, this._nguoiThueProvider, this._phongProvider) {
    txtGiaHopDong.addListener(() {
      if (errGiaHopDong != null) {
        errGiaHopDong = null;
        notifyListeners();
      }
    });
    txtTienCoc.addListener(() {
      if (errTienCoc != null) {
        errTienCoc = null;
        notifyListeners();
      }
    });
    txtGhiChu.addListener(() {
      if (errGhiChu != null) {
        errGhiChu = null;
        notifyListeners();
      }
    });
    txtNgayKy.addListener(() {
      if (errNgayKy != null) {
        errNgayKy = null;
        notifyListeners();
      }
    });
    txtNgayHetHan.addListener(() {
      if (errNgayHetHan != null) {
        errNgayHetHan = null;
        notifyListeners();
      }
    });
  }

  final txtPhong = TextEditingController();
  final txtNguoiThue = TextEditingController();

  final txtNgayKy = TextEditingController();
  final txtNgayHetHan = TextEditingController();

  final txtTongGiaPhong = TextEditingController();
  final txtGiaHopDong = TextEditingController();

  final txtTienCoc = TextEditingController();
  final txtGhiChu = TextEditingController();

  int soNguoiHienTai = 0;

  HopDongState _roomsAvailable = HopDongInitial();
  HopDongState get roomsAvailable => _roomsAvailable;

  HopDongState _representativesAvailable = HopDongInitial();
  HopDongState get representativesAvailable => _representativesAvailable;

  HopDongUpdateState _updateContractState = HopDongUpdateInitial();
  HopDongUpdateState get updateContractState => _updateContractState;

  CreateContractState _createContractState = CreateContractInitial();
  CreateContractState get createContractState => _createContractState;

  List<NguoiOGhepDTO> listNguoiOGhep = [];
  String? errNguoiOGhep;

  Map<String, String> addNguoiOGhep({
    required String cccd,
    String? hoTen,
    String? sdt,
    String? quanHeVoiDaiDien,
  }) {
    final Map<String, String> loi = {};

    final cccdTrim = cccd.trim();
    if (cccdTrim.isEmpty) {
      loi['cccd'] = "Vui lòng nhập CCCD/Mã định danh cá nhân";
    } else if (!RegExp(r'^\d{12}$').hasMatch(cccdTrim)) {
      loi['cccd'] = "CCCD/Mã định danh cá nhân phải gồm đúng 12 số";
    } else if (listNguoiOGhep.any((ng) => ng.cccd == cccdTrim)) {
      loi['cccd'] = "Số này đã có trong danh sách người ở ghép";
    }

    final hoTenTrim = hoTen?.trim() ?? '';
    if (hoTenTrim.isEmpty) {
      loi['hoTen'] = "Vui lòng nhập họ tên";
    }

    final sdtTrim = sdt?.trim() ?? '';
    if (sdtTrim.isNotEmpty) {
      if (!RegExp(r'^\d{10}$').hasMatch(sdtTrim)) {
        loi['sdt'] = "Số điện thoại phải gồm đúng 10 số";
      } else if (!sdtTrim.startsWith('0')) {
        loi['sdt'] = "Số điện thoại phải bắt đầu bằng số 0";
      }
    }

    final quanHeTrim = quanHeVoiDaiDien?.trim() ?? '';
    if (quanHeTrim.isEmpty) {
      loi['quanHe'] = "Vui lòng nhập mối quan hệ với đại diện";
    }

    if (loi.isNotEmpty) {
      return loi;
    }

    listNguoiOGhep.add(
      NguoiOGhepDTO(
        cccd: cccdTrim,
        hoTen: hoTenTrim,
        sdt: sdtTrim.isEmpty ? null : sdtTrim,
        quanHeVoiDaiDien: quanHeTrim,
      ),
    );
    notifyListeners();
    return {};
  }

  void removeNguoiOGhep(int index) {
    listNguoiOGhep.removeAt(index);
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  List<File> listImageContract = [];
  String? errImageContract;

  HopDongDTO? hdDTO;

  //gọi hiển thị list phòng khi tạo hợp đồng mới
  Future<void> getRoomsAvailableForContract() async {
    _roomsAvailable = HopDongLoading();
    notifyListeners();
    try {
      final result = await _hopDongProvider.getRoomsAvailable();
      _roomsAvailable = HopDongSuccess(result);
    } catch (e) {
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if (e is DioException) {
        loi = mapDioErrorToMessage(e);
      } else {
        if (kDebugMode) print("Lỗi logic hệ thống trong HopDongFormViewModel: $e");
      }
      _roomsAvailable = HopDongError(loi);
    } finally {
      notifyListeners();
    }
  }

  // Lấy danh sách người đủ điều kiện làm đại diện (có kiểm tra tuổi >= 18 theo ngày ký)
  Future<void> getAvailableRepresentatives() async {
    _representativesAvailable = HopDongLoading();
    notifyListeners();

    try {
      final ngayKy = chuyenNgay(txtNgayKy.text);
      final result = await _nguoiThueProvider.getAvailableRepresentatives(
        ngayKy: ngayKy,
        phongId: selectedPhong?.id,
      );
      _representativesAvailable = HopDongSuccess(result);
    } catch (e) {
      _representativesAvailable = HopDongError(
        "Không thể tải danh sách người đại diện",
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> createHopDong() async {
    final hopDongInfor = getInforContractPayload();
    if (hopDongInfor == null) return;
    _createContractState = CreateContractLoading();
    notifyListeners();
    try {
      final result = await _hopDongProvider.createHopDong(hopDongInfor, listImageContract);
      _createContractState = CreateContractSuccess(result);
      await _phongProvider.getListPhong();
      await _nguoiThueProvider.fetchAll();
    } catch (e) {
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if (e is DioException) {
        loi = mapDioErrorToMessage(e);
      }
      _createContractState = CreateContractError(loi);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateHopDong() async {
    final hopDongInfor = getInforContractPayload();
    if (hopDongInfor == null) return;
    _updateContractState = HopDongUpdateLoading();
    notifyListeners();
    try {
      final result = await _hopDongProvider.updateHopDong(hopDongInfor, listImageContract);
      await _phongProvider.getListPhong();
      _updateContractState = HopDongUpdateSuccess(result);
      await _nguoiThueProvider.fetchAll();
    } catch (e) {
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if (e is DioException) {
        loi = mapDioErrorToMessage(e);
      }
      _updateContractState = HopDongUpdateError(loi);
    } finally {
      notifyListeners();
    }
  }

  Future<void> selectImageCotract() async {
    final List<XFile> imageSelect = await _picker.pickMultiImage(imageQuality: 80);
    if (imageSelect.isNotEmpty) {
      listImageContract.addAll(imageSelect.map((x) => File(x.path)));
      errImageContract = null;
      notifyListeners();
    }
  }

  void deleteImageContract(int index) {
    listImageContract.removeAt(index);
    notifyListeners();
  }

  NguoiThueAvailableDTO? selectedNguoiThue;
  bool get isEdit => hdDTO != null;

  RoomAvailableDTO? selectedPhong;

  String? thongBaoNguoiDaiDien;

  void xoaThongBaoNguoiDaiDien() {
    thongBaoNguoiDaiDien = null;
  }

  void onSelectedPhong(RoomAvailableDTO? phong) async {
    selectedPhong = phong;
    errPhong = null;
    if (phong != null) {
      txtTongGiaPhong.text = NumberFormat('#,###', 'vi_VN').format(phong.giaPhongGoc).replaceAll(',', '.');
    } else {
      txtTongGiaPhong.text = "0";
    }
    notifyListeners();

    if (selectedNguoiThue != null && phong != null) {
      final nguoiThueDangChon = selectedNguoiThue!;
      await getAvailableRepresentatives();
      final ds = representativesAvailable;
      if (ds is HopDongSuccess<NguoiThueAvailableDTO>) {
        final conHopLe = ds.data.any(
          (nt) => nt.idnt == nguoiThueDangChon.idnt,
        );
        if (!conHopLe) {
          selectedNguoiThue = null;
          thongBaoNguoiDaiDien =
              "Người này đang đại diện 1 hợp đồng khác với phòng vừa chọn, vui lòng chọn lại.";
          notifyListeners();
        }
      }
    }
  }

  void onSelectedNguoiThue(NguoiThueAvailableDTO? nguoiThue) {
    selectedNguoiThue = nguoiThue;
    errNguoiThue = null;
    notifyListeners();
  }

  String? errNgayKy;
  String? errNgayHetHan;
  String? errPhong;
  String? errNguoiThue;
  String? errTongGiaPhong;
  String? errGiaHopDong;
  String? errTienCoc;
  String? errGhiChu;

  void init({HopDongDTO? hopDong}) {
    hdDTO = hopDong;

    if (hopDong != null) {
      txtNgayKy.text = formatDate(hopDong.ngayKy);

      txtNgayHetHan.text = formatDate(hopDong.ngayHetHan);
      final giaThucTe = hopDong.giaPhongThucTe.toInt();
      txtGiaHopDong.text = giaThucTe > 0 ? NumberFormat('#,###', 'vi_VN').format(giaThucTe).replaceAll(',', '.') : "";
      final tienCocVal = hopDong.tienCoc.toInt();
      txtTienCoc.text = tienCocVal > 0 ? NumberFormat('#,###', 'vi_VN').format(tienCocVal).replaceAll(',', '.') : "";
      txtGhiChu.text = hopDong.ghiChu ?? "";

      selectedPhong = RoomAvailableDTO(
        id: hopDong.phongID,
        tenPhong: hopDong.phong.tenPhong,
        giaPhongGoc: hopDong.phong.giaPhongGoc,
      );
      txtTongGiaPhong.text = formatMoney(hopDong.phong.giaPhongGoc);

      selectedNguoiThue = NguoiThueAvailableDTO(
        idnt: hopDong.idntDaiDien,
        hoTen: hopDong.nguoiDaiDien.hoTen,
        tuoi: 18,
        coTheLamDaiDien: true,
      );

      listNguoiOGhep = List.of(hopDong.nguoiOGhepConHieuLuc);
    } else {
      txtNgayKy.text = formatDate(DateTime.now());
    }

    notifyListeners();
  }
  // Kiểm tra xem người dùng có thay đổi Giá phòng hoặc Tiền cọc so với ban đầu không
  bool get hasPriceChanged {
    if (hdDTO == null) return false;

    double oldGia = hdDTO!.giaPhongThucTe;
    double oldCoc = hdDTO!.tienCoc;

    double newGia = double.tryParse(txtGiaHopDong.text.replaceAll('.', '')) ?? 0.0;
    double newCoc = double.tryParse(txtTienCoc.text.replaceAll('.', '')) ?? 0.0;

    return oldGia != newGia || oldCoc != newCoc;
  }

  Map<String, dynamic>? getInforContractPayload() {
    if (selectedPhong == null || selectedNguoiThue == null) return null;
    DateTime? ngayKyParsed = chuyenNgay(txtNgayKy.text);
    DateTime? ngayHetHanParsed = chuyenNgay(txtNgayHetHan.text);

    double tienCocParsed = double.tryParse(txtTienCoc.text.replaceAll('.', '')) ?? 0.0;
    double giaHopDongParsed = double.tryParse(txtGiaHopDong.text.replaceAll('.', '')) ?? 0.0;

    return {
      "hopDongId": hdDTO?.hopDongID,
      "trangThai": hdDTO?.trangThai,
      "phongId": selectedPhong?.id,
      "idntDaiDien": selectedNguoiThue!.idnt,
      "ngayKy": _formatDateOnly(ngayKyParsed),
      "ngayHetHan": _formatDateOnly(ngayHetHanParsed),
      "tienCoc": tienCocParsed,
      "giaPhongThucTe": giaHopDongParsed,
      "ghiChu": txtGhiChu.text.toString(),
      "danhSachNguoiOGhep": listNguoiOGhep.map((e) => e.toJson()).toList(),
    };
  }

  DateTime? chuyenNgay(String ngay) {
    try {
      final tach = ngay.split('/');
      return DateTime(
        int.parse(tach[2]),
        int.parse(tach[1]),
        int.parse(tach[0]),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> chonNgay(
      BuildContext context,
      TextEditingController controller, {
        DateTime? firstDate,
        DateTime? lastDate,
      }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime initDate = chuyenNgay(controller.text) ?? today;
    DateTime minDate = firstDate ?? DateTime(2020);
    DateTime maxDate = lastDate ?? DateTime(2100);

    if (initDate.isBefore(minDate)) initDate = minDate;
    else if (initDate.isAfter(maxDate)) initDate = maxDate;

    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (ngay != null) {
      controller.text = formatDate(ngay);
      if (controller == txtNgayKy) errNgayKy = null;
      if (controller == txtNgayHetHan) errNgayHetHan = null;
      notifyListeners();
    }
  }

  bool get coThayDoi =>
      selectedPhong != null ||
          selectedNguoiThue != null ||
          txtNgayHetHan.text.isNotEmpty ||
          txtGiaHopDong.text.isNotEmpty ||
          txtTienCoc.text.isNotEmpty ||
          txtGhiChu.text.isNotEmpty ||
          listImageContract.isNotEmpty ||
          listNguoiOGhep.isNotEmpty;

  bool kiemTraDuLieu() {
    errPhong = null;
    errNguoiThue = null;
    errNgayKy = null;
    errNgayHetHan = null;
    errGiaHopDong = null;
    errTienCoc = null;
    errGhiChu = null;

    bool hopLe = true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dauThangHienTai = DateTime(now.year, now.month, 1);

    DateTime? ngayKy = chuyenNgay(txtNgayKy.text);
    if (txtNgayKy.text.isEmpty || ngayKy == null) {
      errNgayKy = "Ngày ký không đúng định dạng";
      hopLe = false;
    } else {
      if (!isEdit) {
        final maxTuongLai = today.add(const Duration(days: 30));
        if (ngayKy.isBefore(dauThangHienTai)) {
          errNgayKy = "Chỉ được chọn lùi tối đa về ngày 01 tháng này";
          hopLe = false;
        } else if (ngayKy.isAfter(maxTuongLai)) {
          errNgayKy = "Chỉ được phép đặt trước phòng tối đa 30 ngày ở tương lai";
          hopLe = false;
        }
      } else if (hdDTO?.trangThai == 0) {
        if (ngayKy.isBefore(today)) {
          errNgayKy = "Phải từ ngày hiện tại trở đi";
          hopLe = false;
        } else if (ngayKy.isAfter(hdDTO!.ngayKy)) {
          errNgayKy = "Không được vượt quá ngày bắt đầu dự kiến ban đầu";
          hopLe = false;
        }
      } else if (hdDTO?.trangThai == 1) {
        errNgayKy = null;
      }
    }

    DateTime? ngayHetHan = chuyenNgay(txtNgayHetHan.text);
    if (txtNgayHetHan.text.isEmpty || ngayHetHan == null) {
      errNgayHetHan = "Ngày hết hạn không đúng định dạng";
      hopLe = false;
    }

    if (ngayKy != null && ngayHetHan != null) {
      if (!ngayHetHan.isAfter(ngayKy)) {
        errNgayHetHan = "Ngày hết hạn phải lớn hơn ngày ký";
        hopLe = false;
      } else {
        final khoangCach = ngayHetHan.difference(ngayKy).inDays;
        if (khoangCach < 30) {
          errNgayHetHan = "Hợp đồng tối thiểu phải 30 ngày";
          hopLe = false;
        } else if (khoangCach > 3650) {
          errNgayHetHan = "Hợp đồng không được vượt quá 10 năm";
          hopLe = false;
        }
      }
    }

    final giaThue = txtGiaHopDong.text.replaceAll('.', '');
    double? giaHopDong = double.tryParse(giaThue);
    if (txtGiaHopDong.text.isEmpty || giaHopDong == null || giaHopDong <= 0) {
      errGiaHopDong = "Giá thuê phải lớn hơn 0";
      hopLe = false;
    }

    final tienCocnha = txtTienCoc.text.replaceAll('.', '');
    double? tienCoc = double.tryParse(tienCocnha);
    if (txtTienCoc.text.isEmpty || tienCoc == null || tienCoc < 0) {
      errTienCoc = "Tiền cọc phải là số ≥ 0";
      hopLe = false;
    }

    if (selectedPhong == null) {
      errPhong = "Vui lòng chọn phòng thuê";
      hopLe = false;
    }

    if (selectedNguoiThue == null) {
      errNguoiThue = "Vui lòng chọn người đại diện";
      hopLe = false;
    }
    // Chỉ bắt buộc ảnh khi tạo hợp đồng mới.
    // Khi cập nhật, không cần thêm ảnh mới.
    if (!isEdit && listImageContract.isEmpty) {
      errImageContract = "Vui lòng chụp hoặc thêm ít nhất một ảnh hợp đồng";
      hopLe = false;
    }

    notifyListeners();
    return hopLe;
  }
  String? _formatDateOnly(DateTime? date) {
    if (date == null) return null;

    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    txtPhong.dispose();
    txtNguoiThue.dispose();
    txtNgayKy.dispose();
    txtNgayHetHan.dispose();
    txtTongGiaPhong.dispose();
    txtGiaHopDong.dispose();
    txtTienCoc.dispose();
    txtGhiChu.dispose();
    super.dispose();
  }
}