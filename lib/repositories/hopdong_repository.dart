
import 'dart:io';

import 'package:AppTroNhaToi/core/network/HopDongApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';

class HopdongRepository {
  final HopDongApiClient hopDongApiClient= HopDongApiClient();

  Future<List<HopDongDTO>> getListHopDong(){
    return hopDongApiClient.fetchListHopDong();
  }
  Future<HopDong> createContract(HopDong hopDong, List<File> imageHopDong){
    return hopDongApiClient.createContract(hopDong, imageHopDong);
  }

  Future<List<RoomAvailableDTO>> getRoomsAvailableForContract(){
    return hopDongApiClient.getRoomsAvailableForContract();
  }

  Future<List<HopDong>> fetchRoomByNguoiThue(int idnt){
    final result= hopDongApiClient.fetchRoomByNguoithue(idnt);
    return result;
  }
}