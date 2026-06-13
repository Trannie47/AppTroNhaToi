
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/repositories/hopdong_repository.dart';
import 'package:AppTroNhaToi/states/chi_tiet_nguoi_thue_state.dart';
import 'package:flutter/cupertino.dart';

class HopdongViewModel extends ChangeNotifier{
  HopdongRepository hopdongRepository= HopdongRepository();
  List<HopDong> _listHopDongNguoiThue= [];
  List<HopDong> get listHopDongNguoiThue=> _listHopDongNguoiThue;
  bool _isLoading= false;
  bool get isLoading => _isLoading;

  //Giữ và cập nhật trạng thái dữ liệu để vẽ lên UI
  ChiTietNguoiThueState _chiTietNguoiThueState= ChiTietNguoiThueLoading();
  ChiTietNguoiThueState get chiTietNguoiThueState => _chiTietNguoiThueState;

  Future<void> fetchRoomByNguoiThue(int idnt)async{
    try{
      _chiTietNguoiThueState= ChiTietNguoiThueLoading();
      _isLoading=true;
      notifyListeners();
      _listHopDongNguoiThue= await hopdongRepository.fetchRoomByNguoiThue(idnt);
      _chiTietNguoiThueState= ChiTietNguoiThueSuccess(_listHopDongNguoiThue);
      print("LIST HOP DONG LAY DUOC LA: $_listHopDongNguoiThue");
    }catch(e){
      print("Loi nguoi thue $e");
      _listHopDongNguoiThue=[];
      String errorMessage= "Mat ket noi voi may chu. Vui long ket noi lai";
      if(e.toString().contains("connection timeout")){
        errorMessage= "Kết nối quá hạn. Vui lòng kiểm tra lại internet hoặc server";
      }else if(e.toString().contains("SocketException")){
        errorMessage= "Không có Internet. Vui lòng kiểm tra Wi-Fi/4G!";
      }
      _chiTietNguoiThueState= ChiTietNguoithueError(errorMessage);
    }finally{
      _isLoading= false;
      notifyListeners();
    }
  }
}