import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/repositories/nguoithue_repository.dart';
import 'package:flutter/cupertino.dart';

class NguoithueViewModel extends ChangeNotifier{
  final NguoithueRepository nguoithueRepository= NguoithueRepository();

  List<NguoiThue> _listNguoiThue= [];
  List<NguoiThue> get listNguoithu=> _listNguoiThue;

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  Future<void> fetchAllNguoiThue() async {

    if(_isLoading) return;  // Nếu hệ thống đang load thì ko cho spam gọi api
    _isLoading= true;
    notifyListeners();

    try{
      _listNguoiThue= await nguoithueRepository.getListNguoiThue();
      print("List Nguoiw thue lay duwojc la $_listNguoiThue");
    }catch(e){
      print("Loi NguoiThueViewModel $e");
      _listNguoiThue=[];
    }finally{
      _isLoading= false;
      notifyListeners();
    }
  }



}