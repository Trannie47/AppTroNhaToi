import 'package:AppTroNhaToi/Provider/hop_dong_provider.dart';
import 'package:AppTroNhaToi/states/hop_dong_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/map_dio_error_to_message.dart';

class HopDongPageViewModel extends ChangeNotifier {
  final  HopDongProvider hopDongProvider= HopDongProvider();

  HopDongState _hopDongState = HopDongInitial();
  HopDongState get hopDongState=> _hopDongState;

  Future<void> loadListHD() async{
    _hopDongState= HopDongLoading();
    notifyListeners();
    try{
      final result= await hopDongProvider.getListHD();
      _hopDongState= HopDongSuccess(result);
    }catch(e){
      String loi = "Đã có lỗi xảy ra, vui lòng thử lại sau!";
      if(e is DioException){
        loi= mapDioErrorToMessage(e);
      }else{
        if (kDebugMode) {
          print("Lỗi logic hệ thôngs trong HopDongViewModel: $e");
        } else {
          loi = "Hệ thống đang gặp sự cố kỹ thuật, vui lòng quay lại sau!";
        }
      }
      _hopDongState= HopDongError(loi);
    }finally{
      notifyListeners();
    }
  }
}
