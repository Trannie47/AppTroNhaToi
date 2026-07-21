import 'dart:ffi';

import 'package:AppTroNhaToi/core/network/NguoiThueApiClient.dart';
import 'package:retrofit/http.dart';

import '../models/nguoi_thue.dart';

class NguoithueRepository {
  final NguoiThueApiClient nguoiThueApiClient= NguoiThueApiClient();

  Future<List<NguoiThue>> getListNguoiThue() async{
    final result= await nguoiThueApiClient.getListNguoiThue();
    return result ;
  }
  Future<bool> themNguoiThue(NguoiThue nguoiThue) async {
   return await nguoiThueApiClient.themNguoiThue(nguoiThue);
  }

  Future<bool> xoaNguoiThue(int idnt) async{
    return await nguoiThueApiClient.xoaNguoiThue(idnt);
  }
  Future<NguoiThue?> updateNguoiThue(int idnt, NguoiThue nguoiThue) async {
    return await nguoiThueApiClient.updateNguoiThue(idnt, nguoiThue);
  }

  Future<List<NguoiThue>> getListNguoiThueFromIdPhong(int idPhong) async{
    return await nguoiThueApiClient.getListNguoiThueFromIdPhong(idPhong);
  }

  Future<List<NguoiThue>> getListNguoiThueAvailableForContract(){
    return nguoiThueApiClient.getNguoiThueAvailableForContract();
  }
}