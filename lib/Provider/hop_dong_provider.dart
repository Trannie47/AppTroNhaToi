import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/repositories/hopdong_repository.dart';
import 'package:flutter/cupertino.dart';

class HopDongProvider extends ChangeNotifier {
  final HopdongRepository hopdongRepository= HopdongRepository();

  List<HopDongDTO> _listHD= [];
  List<HopDongDTO> get listHD => _listHD;

  Future<List<HopDongDTO>> fetchListHD() async{
    try{
      final list =await hopdongRepository.getListHopDong();
      _listHD= list;
      notifyListeners();
      return list;
    }catch(e){
      rethrow;
    }
  }
}