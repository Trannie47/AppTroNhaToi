import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/map_dio_error_to_message.dart';

class HopDongFormViewModel extends ChangeNotifier {
   final HopDongProvider _hopDongProvider= HopDongProvider();
   final NguoiThueProvider _nguoiThueProvider= NguoiThueProvider();
  final txtPhong = TextEditingController();
  final txtNguoiThue = TextEditingController();

  final txtNgayKy = TextEditingController();
  final txtNgayHetHan = TextEditingController();

  final txtTongGiaPhong = TextEditingController();
  final txtGiaHopDong = TextEditingController();


  final txtTienCoc = TextEditingController();
  final txtGhiChu = TextEditingController();

  int soNguoiHienTai = 0;

  HopDongState _roomsAvailable= HopDongInitial();
  HopDongState get roomsAvailable => _roomsAvailable;

  HopDongState _tenantsAvailable= HopDongInitial();
  HopDongState get tenantsAvailable=> _tenantsAvailable;

  // hàm gọi api để hiênr thị list phòng khi tạo hợp đồng mới
  Future<void> getRoomsAvailableForContract() async{
    _roomsAvailable= HopDongLoading();
    notifyListeners();
    try{
        final result= await _hopDongProvider.getRoomsAvailable();
        _roomsAvailable= HopDongSuccess(result); //Nếu hệ thôngs không lỗi thì trả về ds phòng available

    }catch(e){
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if(e is DioException){
        loi= mapDioErrorToMessage(e);
      }else{
        if (kDebugMode) {
          print("Lỗi logic hệ thôngs trong HopDongFormViewModel: $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _roomsAvailable= HopDongError(loi);
    }finally{
      notifyListeners();
    }
  }

  Future<void> getNguoiThueAvailableForContract() async{
    _tenantsAvailable= HopDongLoading();
    notifyListeners();
    try{
      final result= await  _nguoiThueProvider.getListNguoiThueAvailableForContract();
      _tenantsAvailable=HopDongSuccess(result);
    }catch(e){
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if(e is DioException){
        loi= mapDioErrorToMessage(e);
      }else{
        if (kDebugMode) {
          print("Lỗi logic hệ thôngs trong HopDongFormViewModel: $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _tenantsAvailable= HopDongError(loi);
    }finally{
      notifyListeners();
    }
  }

  //Ds Phòng có thể thuê
  List<Phong> dsPhong = [
    Phong(
      phongID: 1,
      tenPhong: "Phòng 101",
      trangThai: 1,
      maLoaiPhong: 101,
      moTa: "Phòng có ban công",
    ),
    Phong(
      phongID: 2,
      tenPhong: "Phòng 102",
      trangThai: 2,
      maLoaiPhong: 102,
      moTa: "Phòng có bếp",
    ),
    Phong(
      phongID: 3,
      tenPhong: "Phòng 103",
      trangThai: 0,
      maLoaiPhong: 103,
      moTa: "Phòng có sân thượng",
    ),
  ];


  List<LoaiPhong> dsLoaiPhong = [
    LoaiPhong(
      maLoaiPhong: 101,
      tenLoaiPhong: "Loại 1",
      dienTich: 12,
      soNguoiToiDa: 5,
      giaTien: 12,
    ),
    LoaiPhong(
      maLoaiPhong: 102,
      tenLoaiPhong: "Loại 2",
      dienTich: 15,
      soNguoiToiDa: 3,
      giaTien: 15,
    ),
    LoaiPhong(
      maLoaiPhong: 103,
      tenLoaiPhong: "Loại 3",
      dienTich: 20,
      soNguoiToiDa: 2,
      giaTien: 20,
    ),
  ];

  //Danh sách người thuê
  List<NguoiThue> dsNguoiThue = [
    NguoiThue(
      idnt: 1,
      hoTen: "Nguyễn Văn A",
      cccd: "079001234567",
      sdt: "0901234567",
      ghiChu: "",
    ),
    NguoiThue(
      idnt: 2,
      hoTen: "Trần Thị B",
      cccd: "079001234890",
      sdt: "0912345678",
      ghiChu: "Ở ghép",
    ),
    NguoiThue(
      idnt: 3,
      hoTen: "Lê Văn C",
      cccd: "079001234567",
      sdt: "0901234567",
      ghiChu: "",
    ),
  ];

  NguoiThue? selectedNguoiThue;
  bool get isEdit => hopDong != null;

   RoomAvailableDTO? selectedPhong;
  //Chọn phòng sẽ tự động tính tổng giá phòng
  void onSelectedPhong(RoomAvailableDTO? phong) {
    selectedPhong = phong;
    if (phong != null) {
      txtTongGiaPhong.text =formatMoney(phong.giaPhongGoc);
    } else {
      txtTongGiaPhong.text = "0";
    }
    notifyListeners();
  }

  HopDong? hopDong;
  String? errNgayKy;
  String? errNgayHetHan;
  String? errPhong;
  String? errNguoiThue;
  String? errTongGiaPhong;
  String? errGiaHopDong;
  String? errTienCoc;
  String? errGiaDeXuat;
  String? errGhiChu;

  void init({HopDong? hopDong}) {
    this.hopDong = hopDong;

    if (hopDong != null) {
      txtNgayKy.text = formatDate(hopDong.ngayKy);
      txtNgayHetHan.text = formatDate(hopDong.ngayHetHan);

      txtGiaHopDong.text = (hopDong.giaPhongThucTe ?? 0).toString();

      txtTienCoc.text = (hopDong.tienCoc ?? 0).toString();

      txtGhiChu.text = "";
    }

    notifyListeners();
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
    TextEditingController controller,
  ) async {
    DateTime? ngay = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (ngay != null) {
      controller.text = formatDate(ngay);

      notifyListeners();
    }
  }

  bool kiemTraDuLieu() {
    errPhong = null;
    errNguoiThue = null;
    errNgayKy = null;
    errNgayHetHan = null;
    errGiaHopDong = null;
    errTienCoc = null;
    errGhiChu = null;
    errTongGiaPhong = null;
    errGiaDeXuat = null;

    bool hopLe = true;

    errNgayKy = kiemTraNgay(txtNgayKy.text, minYear: 2000);

    if (errNgayKy != null) {
      hopLe = false;
    }

    errNgayHetHan = kiemTraNgay(txtNgayHetHan.text, minYear: 1);

    if (errNgayHetHan != null) {
      hopLe = false;
    }

    if (hopLe) {
      DateTime ngayKy = chuyenNgay(txtNgayKy.text)!;

      DateTime ngayHetHan = chuyenNgay(txtNgayHetHan.text)!;

      if (!ngayHetHan.isAfter(ngayKy)) {
        errNgayHetHan = "Ngày hết hạn phải lớn hơn ngày ký";

        hopLe = false;
      }
    }
    double? tongGiaPhong = double.tryParse(txtTongGiaPhong.text);

    if (tongGiaPhong == null || tongGiaPhong < 0) {
      errTongGiaPhong = "Tổng giá phòng phải là số ≥ 0";

      hopLe = false;
    }

    double? giaHopDong = double.tryParse(txtGiaHopDong.text);

    if (giaHopDong == null || giaHopDong < 0) {
      errGiaHopDong = "Giá thuê phải là số ≥ 0";

      hopLe = false;
    }

    double? tienCoc = double.tryParse(txtTienCoc.text);

    if (tienCoc == null || tienCoc < 0) {
      errTienCoc = "Tiền cọc phải là số ≥ 0";

      hopLe = false;
    }


    if (txtPhong.text.trim().isEmpty) {
      errPhong = "Vui lòng nhập phòng thuê";

      hopLe = false;
    }

    if (txtNguoiThue.text.trim().isEmpty) {
      errNguoiThue = "Vui lòng nhập người thuê";

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
