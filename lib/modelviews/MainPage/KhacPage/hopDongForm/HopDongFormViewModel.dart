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

import '../../../../core/utils/map_dio_error_to_message.dart';

class HopDongFormViewModel extends ChangeNotifier {
  final HopDongProvider _hopDongProvider;
  final NguoiThueProvider _nguoiThueProvider;

  HopDongFormViewModel(this._hopDongProvider,this._nguoiThueProvider);
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

  CreateContractState _createContractState= CreateContractInitial();
  CreateContractState get createContractState => _createContractState;

  final ImagePicker _picker = ImagePicker();
  List<File> listImageContract = [];
  String? errImageContract;

  HopDong? hopDong;

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
    if (!kiemTraDuLieu()) return;
    final hopDongInfor= getInforContract();
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
  bool get isEdit => hopDong != null;

  RoomAvailableDTO? selectedPhong;
  //Chọn phòng sẽ tự động lấy giá phòng gốc hiển thị lên
  void onSelectedPhong(RoomAvailableDTO? phong) {
    selectedPhong = phong;
    if (phong != null) {
      txtTongGiaPhong.text =formatMoney(phong.giaPhongGoc);
    } else {
      txtTongGiaPhong.text = "0";
    }
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

  void init({HopDong? hopDong}) {
    this.hopDong = hopDong;

    if (hopDong != null) {
      txtNgayKy.text = formatDate(hopDong.ngayKy);
      txtNgayHetHan.text = formatDate(hopDong.ngayHetHan);

      txtGiaHopDong.text = (hopDong.giaPhongThucTe ?? 0).toString();

      txtTienCoc.text = (hopDong.tienCoc ?? 0).toString();

      txtGhiChu.text = "";
    }
    else{
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
    double tienCocParsed = double.tryParse(txtTienCoc.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
    double giaHopDongParsed = double.tryParse(txtGiaHopDong.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

    hopDong= HopDong(
      phongID: selectedPhong?.id,
      idnt: selectedNguoiThue?.idnt,
      ngayKy: ngayKyParsed,
      ngayHetHan:ngayHetHanParsed,
      tienCoc: tienCocParsed,
      giaPhongThucTe: giaHopDongParsed,
      ghiChu: txtGhiChu.text.toString(),
    );
    return hopDong;
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


    DateTime? ngayKy = chuyenNgay(txtNgayKy.text);
    if (txtNgayKy.text.isEmpty || ngayKy == null) {
      errNgayKy = "Ngày ký không đúng định dạng";
      hopLe = false;
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
      }
    }

    final giaThue = txtGiaHopDong.text.replaceAll(RegExp(r'[^0-9]'), '');
    double? giaHopDong = double.tryParse(giaThue);
    if (txtGiaHopDong.text.isEmpty || giaHopDong == null || giaHopDong < 0) {
      errGiaHopDong = "Giá thuê phải là số ≥ 0";
      hopLe = false;
    }

    final tienCocnha = txtTienCoc.text.replaceAll(RegExp(r'[^0-9]'), '');
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
    //check trùng hợp đồng, tránh trươngf hợp ng đó đã tạo hợp dôndgf rồi mà chủ trọ tạo lại
    if (selectedPhong != null && selectedNguoiThue != null) {
      final danhSachHD = _hopDongProvider.listHD; // List đã load sẵn
      final isDuplicate = danhSachHD.any((hd) =>
      hd.phongID == selectedPhong!.id &&
          hd.idnt == selectedNguoiThue!.idnt &&
          hd.trangThai !=2 // chỉ check hợp đồng đang hiệu lực và HD đã khởi tạo
      );

      if (isDuplicate) {
        errPhong = "Người thuê này đã có hợp đồng với phòng đã chọn!";
        hopLe = false;
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
