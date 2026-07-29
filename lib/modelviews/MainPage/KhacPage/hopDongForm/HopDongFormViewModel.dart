import 'dart:ffi';
import 'dart:io';

import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/Provider/nguoi_thue_provider.dart';
import 'package:AppTroNhaToi/core/utils/currency_formatter.dart';
import 'package:AppTroNhaToi/core/utils/date_formatter.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/states/create_contract_state.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/map_dio_error_to_message.dart';
import '../../../../models/DTO/HopDongDTO.dart';
import '../../../../states/hop_dong_update_state.dart';

class HopDongFormViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final NguoiThueProvider _nguoiThueProvider;

  HopDongFormViewModel(this._hopDongProvider,this._nguoiThueProvider){
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

  HopDongState _roomsAvailable= HopDongInitial();
  HopDongState get roomsAvailable => _roomsAvailable;

  HopDongState _tenantsAvailable= HopDongInitial();
  HopDongState get tenantsAvailable=> _tenantsAvailable;

  HopDongUpdateState _updateContractState = HopDongUpdateInitial();
  HopDongUpdateState get updateContractState => _updateContractState;

  CreateContractState _createContractState= CreateContractInitial();
  CreateContractState get createContractState => _createContractState;

  final ImagePicker _picker = ImagePicker();
  List<File> listImageContract = [];
  String? errImageContract;

  HopDongDTO? hdDTO;

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
  Future<void> createHopDong() async{
    final hopDongInfor= getInforContract();
    print("Lays duwojc infro laf $hopDongInfor");
    if(hopDongInfor== null) return;
    _createContractState= CreateContractLoading();
    notifyListeners();
    try{
     final result= await _hopDongProvider.createHopDong(hopDongInfor, listImageContract);
      _createContractState= CreateContractSuccess(result);
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
      _createContractState= CreateContractError(loi);
    }finally{
      notifyListeners();
    }
  }
  Future<void> updateHopDong() async{
    final hopDongInfor= getInforContract();
    if(hopDongInfor== null) return;
    _updateContractState= HopDongUpdateLoading();
    notifyListeners();
    try{
      final result= await _hopDongProvider.updateHopDong(hopDongInfor, listImageContract);
      _updateContractState= HopDongUpdateSuccess(result);
    }catch(e){
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if(e is DioException){
        loi= mapDioErrorToMessage(e);
      }else{
        if (kDebugMode) {
          print("Lỗi logic hệ thống trong HopDongFormViewModel (Update): $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _updateContractState= HopDongUpdateError(loi);
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


  Future<void> selectImageCotract() async{
    final List<XFile> imageSelect= await _picker.pickMultiImage(imageQuality: 80); //cho phep chon nhieu anh
    if(imageSelect.isNotEmpty){
      listImageContract.addAll(imageSelect.map((x)=> File(x.path)));
      errImageContract=null;
      notifyListeners();
    }
  }

  void deleteImageContract(int index){
    listImageContract.removeAt(index);
    notifyListeners();
  }


  NguoiThue? selectedNguoiThue;
  bool get isEdit => hdDTO != null;

  RoomAvailableDTO? selectedPhong;
  //Chọn phòng sẽ tự động lấy giá phòng gốc hiển thị lên
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
  void onSelectedNguoiThue(NguoiThue? nguoiThue) {
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
  String? errGiaDeXuat;
  String? errGhiChu;

  void init({HopDongDTO? hopDong}) {
    hdDTO = hopDong;

    if (hopDong != null) {
      final now = DateTime.now();

      // Khi Cập nhật hợp đồng đang hoạt động (trangThai == 1),
      // Mặc định hiển thị Ngày bắt đầu là HÔM NAY (DateTime.now())
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

      selectedNguoiThue = NguoiThue(
        idnt: hopDong.idnt,
        hoTen: hopDong.nguoithue.hoTen,
      );
    } else {
      txtNgayKy.text = formatDate(DateTime.now());
    }

    notifyListeners();
  }
  //Lấy thông tin của hợp đồng trên form
  HopDong? getInforContract(){
    if (selectedPhong == null || selectedNguoiThue == null) return null;
    DateTime? ngayKyParsed= chuyenNgay(txtNgayKy.text);
    DateTime? ngayHetHanParsed= chuyenNgay(txtNgayHetHan.text);

    //Parse số tiền từ text controller và bỏ qua các định dạng
    double tienCocParsed = double.tryParse(txtTienCoc.text.replaceAll('.', '')) ?? 0.0;
    double giaHopDongParsed = double.tryParse(txtGiaHopDong.text.replaceAll('.', '')) ?? 0.0;

    return HopDong(
      hopDongID: hdDTO?.hopDongID,
      trangThai: hdDTO?.trangThai,
      phongID: selectedPhong?.id,
      idnt: selectedNguoiThue?.idnt,
      ngayKy: ngayKyParsed,
      ngayHetHan:ngayHetHanParsed,
      tienCoc: tienCocParsed,
      giaPhongThucTe: giaHopDongParsed,
      ghiChu: txtGhiChu.text.toString(),
    );

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

    if (initDate.isBefore(minDate)) {
      initDate = minDate;
    } else if (initDate.isAfter(maxDate)) {
      initDate = maxDate;
    }

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
  //check xem trên form có dữ liệu không để code hàm thoát
  bool get coThayDoi =>
      selectedPhong != null ||
          selectedNguoiThue != null ||
          txtNgayHetHan.text.isNotEmpty ||
          txtGiaHopDong.text.isNotEmpty ||
          txtTienCoc.text.isNotEmpty ||
          txtGhiChu.text.isNotEmpty ||
          listImageContract.isNotEmpty;

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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dauThangHienTai = DateTime(now.year, now.month, 1);
    final cuoiThangHienTai = DateTime(now.year, now.month + 1, 0);
    DateTime? ngayKy = chuyenNgay(txtNgayKy.text);
    if (txtNgayKy.text.isEmpty || ngayKy == null) {
      errNgayKy = "Ngày ký không đúng định dạng";
      hopLe = false;
    }else{
      if (!isEdit) {
        // TH1 TẠO MỚI HỢP ĐỒNG
        // Cho phép lùi ngày dọn vào, nhưng tối đa chỉ lùi tới ngày 01 tháng này và ko quá 30 ngày trong tương lai
        final maxTuongLai = today.add(const Duration(days: 30));
        if (ngayKy.isBefore(dauThangHienTai)) {
          errNgayKy = "Chỉ được chọn lùi tối đa về ngày 01 tháng này";
          hopLe = false;
        } else if (ngayKy.isAfter(maxTuongLai)) {
          errNgayKy = "Chỉ được phép đặt trước phòng tối đa 30 ngày ở tương lai";
          hopLe = false;
        }
      } else if (hdDTO?.trangThai == 0) {
        // TH2 CẬP NHẬT HỢP ĐỒNG CHỜ HIỆU LỰC
        // Giữ nguyên ràng buộc cũ: Không cho chọn lùi về quá khứ (phải từ hôm nay trở đi)
        if (ngayKy.isBefore(today)) {
          errNgayKy = "Phải từ ngày hiện tại trở đi";
          hopLe = false;
        }
      }
      else if (hdDTO?.trangThai == 1) {
        //TH3: CẬP NHẬT HỢP ĐỒNG ĐANG HOẠT ĐỘNG
        // Bắt buộc Ngày bắt đầu phải nằm trong THÁNG HIỆN TẠI
        if (ngayKy.isBefore(dauThangHienTai) ||
            ngayKy.isAfter(today)) {
          errNgayKy =
          "Ngày bắt đầu phải từ ngày 01/${now.month} đến hôm nay (${formatDate(now)})";
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
      errNguoiThue = "Vui lòng chọn người thuê";
      hopLe = false;
    }
    if (listImageContract.isEmpty) {
      errImageContract = "Vui lòng chụp hoặc thêm ít nhất một ảnh hợp đồng";
      hopLe = false;
    }
    // Check trùng hợp đồng khi tạo mới còn update thì ko
    if (selectedPhong != null && selectedNguoiThue != null && !isEdit) {
      final danhSachHD = _hopDongProvider.listHD; // List đã load sẵn
      final isDuplicate = danhSachHD.any((hd) =>
      hd.phongID == selectedPhong!.id &&
          hd.idnt == selectedNguoiThue!.idnt &&
          hd.trangThai != 2 // chỉ check hợp đồng đang hiệu lực và HD đã khởi tạo
      );

      if (isDuplicate) {
        errPhong = "Người thuê này đã có hợp đồng với phòng đã chọn!";
        hopLe = false;
      }
    }
    // Khi update: Không cho phép đổi phòng khác
    if (isEdit && selectedPhong != null && hdDTO != null) {
      if (selectedPhong!.id != hdDTO!.phongID) {
        errPhong = "Không thể chuyển hợp đồng sang phòng khác. Vui lòng tạo hợp đồng mới!";
        hopLe = false;
      }
    }
    if(isEdit && selectedNguoiThue!=null && hdDTO!=null){
      if(selectedNguoiThue!.idnt != hdDTO!.idnt){
        errNguoiThue= "Không thể sửa hợp đồng sang người thuê khác. Vui lòng tạo hợp đồng mới";
        hopLe=false;
      }
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
