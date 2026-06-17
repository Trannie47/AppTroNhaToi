import 'package:AppTroNhaToi/models/item_phong.dart';
import 'package:AppTroNhaToi/repositories/phong_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PhongViewModel extends ChangeNotifier{
  final PhongRepository phongRepository= PhongRepository();
  List<ItemPhong> _listPhong= [];
  List<ItemPhong> get listPhong => _listPhong;

  bool _isLoading= false;
  bool get isLoading  => _isLoading;

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
}