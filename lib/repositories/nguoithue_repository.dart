import 'package:AppTroNhaToi/core/network/NguoiThueApiClient.dart';

import '../models/nguoi_thue.dart';

class NguoithueRepository {
  final NguoiThueApiClient nguoiThueApiClient= NguoiThueApiClient();

  Future<List<NguoiThue>> getListNguoiThue() async{
    final result= await nguoiThueApiClient.getListNguoiThue();
    return result ;
  }
}