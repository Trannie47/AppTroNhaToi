import 'dart:io';

import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
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
import '../../../../models/DTO/ThanhVienHopDongDTO.dart';
import '../../../../states/hop_dong_update_state.dart';

class HopDongFormViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final NguoiThueProvider _nguoiThueProvider;

  HopDongFormViewModel(this._hopDongProvider, this._nguoiThueProvider) {
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

  // Quản lý danh sách thành viên ở chung
  List<Map<String, dynamic>> listThanhVienOChung = [];

  void addThanhVienOChung(NguoiThueAvailableDTO nguoiThue, String quanHe) {
    listThanhVienOChung.add({
      'nguoiThue': nguoiThue,
      'quanHe': quanHe,
    });
    notifyListeners();
  }

  void removeThanhVienOChung(int index) {
    listThanhVienOChung.removeAt(index);
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

  // Lấy danh sách thành viên ở cùng (loại trừ đại diện đang chọn và những người đã được thêm vào danh sách ở chung)
  Future<List<NguoiThueAvailableDTO>> getAvailableMembers() async {
    try {
      //Tổng hợp các IDNT cần loại bỏ (gồm người đại diện và các thành viên đã chọn ở chung)
      final List<int> excludedIds = [];
      if (selectedNguoiThue?.idnt != null) {
        excludedIds.add(selectedNguoiThue!.idnt!);
      }
      for (var tv in listThanhVienOChung) {
        NguoiThueAvailableDTO nt = tv['nguoiThue'];
        if (nt.idnt != null) {
          excludedIds.add(nt.idnt!);
        }
      }

      //Gọi API lấy danh sách những người chưa có phòng
      final result = await _nguoiThueProvider.getAvailableMembers(
        excludeIdnt: selectedNguoiThue?.idnt,
      );

      //Lọc bỏ hoàn toàn những ai đã có mặt trong danh sách ở cùng hiện tại
      return result.where((e) => !excludedIds.contains(e.idnt)).toList();
    } catch (e) {
      if (kDebugMode) print("Lỗi lấy danh sách thành viên: $e");
      return [];
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
      _updateContractState = HopDongUpdateSuccess(result);
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

  void onSelectedPhong(RoomAvailableDTO? phong) {
    selectedPhong = phong;
    errPhong = null;
    if (phong != null) {
      txtTongGiaPhong.text = NumberFormat('#,###', 'vi_VN').format(phong.giaPhongGoc).replaceAll(',', '.');
    } else {
      txtTongGiaPhong.text = "0";
    }
    notifyListeners();
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
      final now = DateTime.now();

      if (hopDong.trangThai == 1) {
        txtNgayKy.text = formatDate(now);
      } else {
        txtNgayKy.text = formatDate(hopDong.ngayKy);
      }

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
        idnt: hopDong.idnt,
        hoTen: hopDong.nguoithue.hoTen,
        tuoi: 18,
        coTheLamDaiDien: true,
      );
    } else {
      txtNgayKy.text = formatDate(DateTime.now());
    }

    notifyListeners();
  }

  Map<String, dynamic>? getInforContractPayload() {
    if (selectedPhong == null || selectedNguoiThue == null) return null;
    DateTime? ngayKyParsed = chuyenNgay(txtNgayKy.text);
    DateTime? ngayHetHanParsed = chuyenNgay(txtNgayHetHan.text);

    double tienCocParsed = double.tryParse(txtTienCoc.text.replaceAll('.', '')) ?? 0.0;
    double giaHopDongParsed = double.tryParse(txtGiaHopDong.text.replaceAll('.', '')) ?? 0.0;

    // Dùng Set để theo dõi các idnt đã được thêm vào, đảm bảo không bao giờ bị trùng
    final Set<int> addedIdnts = {};
    List<Map<String, dynamic>> danhSachThanhVien = [];

    int daiDienIdnt = selectedNguoiThue!.idnt!;
    addedIdnts.add(daiDienIdnt);
    danhSachThanhVien.add(
      ThanhVienHopDongDTO(
        idnt: daiDienIdnt,
        laDaiDien: true,
        quanHeVoiDaiDien: null, // Hoặc gán chuỗi nếu nghiệp vụ yêu cầu
      ).toJson(),
    );

    //Thêm các thành viên ở chung (chỉ thêm nếu idnt chưa từng xuất hiện)
    for (var tv in listThanhVienOChung) {
      NguoiThueAvailableDTO nt = tv['nguoiThue'];
      String quanHe = tv['quanHe'];

      if (nt.idnt != null && !addedIdnts.contains(nt.idnt!)) {
        addedIdnts.add(nt.idnt!);
        danhSachThanhVien.add(
          ThanhVienHopDongDTO(
            idnt: nt.idnt!,
            laDaiDien: false,
            quanHeVoiDaiDien: quanHe,
          ).toJson(),
        );
      }
    }

    return {
      "hopDongId": hdDTO?.hopDongID,
      "trangThai": hdDTO?.trangThai,
      "phongId": selectedPhong?.id,
      "ngayKy": ngayKyParsed?.toIso8601String(),
      "ngayHetHan": ngayHetHanParsed?.toIso8601String(),
      "tienCoc": tienCocParsed,
      "giaPhongThucTe": giaHopDongParsed,
      "ghiChu": txtGhiChu.text.toString(),
      "danhSachThanhVien": danhSachThanhVien,
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
          listThanhVienOChung.isNotEmpty;

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
        }
      } else if (hdDTO?.trangThai == 1) {
        final rawNgayKyGoc = hdDTO?.ngayKy ?? dauThangHienTai;
        final ngayKyGoc = DateTime(rawNgayKyGoc.year, rawNgayKyGoc.month, rawNgayKyGoc.day);

        DateTime minAllowedDate = (ngayKyGoc.year == now.year && ngayKyGoc.month == now.month)
            ? ngayKyGoc.add(const Duration(days: 1))
            : dauThangHienTai;

        final ngayKyOnly = DateTime(ngayKy.year, ngayKy.month, ngayKy.day);

        if (ngayKyOnly.isBefore(minAllowedDate) || ngayKyOnly.isAfter(today)) {
          errNgayKy = "Ngày bắt đầu phải từ ngày ${formatDate(minAllowedDate)} đến hôm nay";
          hopLe = false;
        }
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

    if (listImageContract.isEmpty) {
      errImageContract = "Vui lòng chụp hoặc thêm ít nhất một ảnh hợp đồng";
      hopLe = false;
    }

    notifyListeners();
    return hopLe;
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