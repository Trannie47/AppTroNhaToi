import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/repositories/phong_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/phong.dart';

class PhongViewModel extends ChangeNotifier{
  final PhongRepository phongRepository= PhongRepository();
  List<ItemPhong> _listPhong= [];
  List<ItemPhong> get listPhong => _listPhong;

  List<ItemPhong> get listPhongTrong => _listPhong.where((phong)=> phong.trangThai==0).toList();
  List<ItemPhong> get listPhongDangThue=> _listPhong.where((phong)=> phong.trangThai==1).toList();
  List<ItemPhong> get listPhongDangSua=> _listPhong.where((phong)=> phong.trangThai==2).toList();

  int _currentFilter= -1;
  int get currentFilter => _currentFilter;

  bool _isLoading= false;
  bool get isLoading  => _isLoading;

  TextEditingController nameController= TextEditingController();
  TextEditingController descController=TextEditingController();

  int _idLoaiPhong= 0;
  int get idLoaiPhong=> _idLoaiPhong;

  int _trangThai=0;
  int get trangThai => _trangThai;

  String? _errTenPhong;
  String? get errTenPhong => _errTenPhong;

  Future<void> fetchPhong() async{
    if(_isLoading) return;
    _isLoading= true;
    notifyListeners();
    try{
      _listPhong= await phongRepository.fetchPhong();
      if (kDebugMode) {
        print("List Phong lay được là: $_listPhong");
      }
    }catch(e){
      if (kDebugMode) {
        print("Lỗi PhongViewModel $e");
      }
      _listPhong=[];
    }finally{
      _isLoading= false;
      notifyListeners();
    }
  }

  List<ItemPhong> get listPhongHienThi{
    switch(_currentFilter){
      case 0:
        return listPhongTrong;
      case 1:
        return listPhongDangThue;
      case 2:
        return listPhongDangSua;
        default:
          return _listPhong;
    }
  }

  void setFilter(int filterValue){
    if(_currentFilter== filterValue) return;
    _currentFilter= filterValue;
    notifyListeners();
  }

  void setIdLoaiPhong(int idLoaiPhong){
    _idLoaiPhong= idLoaiPhong;
    notifyListeners();
  }
  void setTrangThai(int trangThai){
    _trangThai=trangThai;
    notifyListeners();
  }
  // hàm lưu phòng chưa hoàn thành
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