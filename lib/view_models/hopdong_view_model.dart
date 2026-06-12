
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/repositories/hopdong_repository.dart';
import 'package:flutter/cupertino.dart';

class HopdongViewModel extends ChangeNotifier{
  HopdongRepository hopdongRepository= HopdongRepository();

  List<HopDong> _listHopDongNguoiThue= [];
  List<HopDong> get listHopDongNguoiThue=> _listHopDongNguoiThue;

  Future<void> fetchRoomByNguoiThue(int idnt)async{
    try{
      _listHopDongNguoiThue= await hopdongRepository.fetchRoomByNguoiThue(idnt);
      print("LIST HOP DONG LAY DUOC LA: $_listHopDongNguoiThue");
    }catch(e){
      print("Loi nguoi thue $e");
      _listHopDongNguoiThue=[];

    }finally{
      notifyListeners();
    }
  }
}