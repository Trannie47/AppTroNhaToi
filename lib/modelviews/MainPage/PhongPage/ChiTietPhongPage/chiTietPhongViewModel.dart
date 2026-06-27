import 'package:AppTroNhaToi/models/loaiphong.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:AppTroNhaToi/models/phong.dart';
import 'package:AppTroNhaToi/modelviews/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDongViewModel.dart';
import 'package:AppTroNhaToi/views/MainPage/KhacPage/chiTietHopDongPage/chiTietHopDong_Model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../Provider/phong_provider.dart';
import '../../../../Provider/nguoi_thue_provider.dart';
import '../../../../states/NguoiThueState.dart';


class ChiTietPhongViewModel extends ChangeNotifier {
  final PhongProvider _phongService;
  final NguoiThueProvider _nguoiThueService;
  final int _phongId;
  NguoiThueState _nguoiThueState= NguoiThueLoading();
  NguoiThueState get nguoiThueState => _nguoiThueState;

  ChiTietPhongViewModel(this._phongService, this._nguoiThueService, this._phongId) {
    _phongService.addListener(_onProviderUpdate);
  }


  Future<void> getListNguoiThueFromIdPhong(int idPhong)async{
    _nguoiThueState= NguoiThueLoading();
    notifyListeners();
    try{
      final result= await _nguoiThueService.getListNguoiThueFromIdPhong(idPhong);
      _nguoiThueState= NguoiThueSuccess(result);
    }catch(e){
      if (kDebugMode) {
        print("Lỗi NguoiThueViewModel $e");
      }
      _nguoiThueState= NguoiThueError(e.toString().replaceFirst('Exception: ', ''));
    }finally{
      notifyListeners();
    }
  }
  void _onProviderUpdate() {
    notifyListeners();
  }
  @override
  void dispose() {
    _phongService.removeListener(_onProviderUpdate);
    super.dispose();
  }
}
