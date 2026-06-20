import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/repositories/loaiphong_repository.dart';
import 'package:AppTroNhaToi/states/loaiphong_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';


class LoaiPhongViewModel extends ChangeNotifier{
  final LoaiPhongRepository loaiPhongRepository= LoaiPhongRepository();

   TextEditingController nameController= TextEditingController();
   TextEditingController descController=TextEditingController();

    int _idLoaiPhong= 0;
    int get idLoaiPhong=> _idLoaiPhong;

    int _trangThai=0;
    int get trangThai => _trangThai;

  String? _errTenPhong;
  String? get errTenPhong => _errTenPhong;


  LoaiphongState _loaiphongState= LoaiPhongLoading();
  LoaiphongState get loaiphongState => _loaiphongState;
  List<LoaiPhong> listLoaiPhong= [];
  Future<void> getListLoaiPhong() async{
    try{
      _loaiphongState= LoaiPhongLoading();
      notifyListeners();
      listLoaiPhong= await loaiPhongRepository.getListLoaiPhong();
      _loaiphongState= LoaiPhongSuccess(listLoaiPhong);
      if (kDebugMode) {
        print("DS loại phòng lấy được là $listLoaiPhong");
      }
    }catch(e){
      if (kDebugMode) {
        print("Lỗi LoaiPhongViewModel $e");
      }
      _loaiphongState=LoaiPhongError(e.toString().replaceFirst('Exception: ', ''));
    }finally{
      notifyListeners();
    }
  }

  void setIdLoaiPhong(int idLoaiPhong){
    _idLoaiPhong= idLoaiPhong;
    notifyListeners();
  }
  void setTrangThai(int trangThai){
    _trangThai=trangThai;
    notifyListeners();
  }

  void saveRoom(){
    Phong p= Phong(phongID: 10, tenPhong: nameController.text.toString(), trangThai: _trangThai, maLoaiPhong: _idLoaiPhong,moTa: descController.text.toString());
    print("Phong lays được là $p");
  }

  bool kiemTraDuLieu() {
    bool hopLe = true;
    if (nameController.text.trim().isEmpty) {
      _errTenPhong = "Vui lòng nhập tên phòng trọ!";
      hopLe = false;
    } else {
      _errTenPhong = null;
    }
    notifyListeners();
    return hopLe;
  }
}