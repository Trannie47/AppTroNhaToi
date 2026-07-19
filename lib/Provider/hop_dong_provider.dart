import 'dart:io';

import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/repositories/hopdong_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/hop_dong.dart';

class HopDongProvider extends ChangeNotifier {
  final HopdongRepository hopdongRepository= HopdongRepository();

  List<HopDongDTO> _listHD= [];
  List<HopDongDTO> get listHD => _listHD;

  Future<List<HopDongDTO>> getListHD() async{
    try{
      final list =await hopdongRepository.getListHopDong();
      _listHD= list;
      notifyListeners();
      return list;
    }catch(e){
      rethrow;
    }
  }
  Future<HopDong> createHopDong(HopDong hopDong, List<File> imageHopDong) async{
    try{
      final result= await hopdongRepository.createContract(hopDong, imageHopDong);
      return result;
    }catch(e){
      rethrow;
    }
  }
  Future<HopDong> updateHopDong(HopDong hopDong, List<File> imageHopDong) async{
    try{
      final result = await hopdongRepository.updateContract(hopDong, imageHopDong);
      return result;
    }catch(e){
      rethrow;
    }
  }
  Future<List<RoomAvailableDTO>> getRoomsAvailable() async{
    try{
      final list= await hopdongRepository.getRoomsAvailableForContract();
      return list;
    }catch(e){
      rethrow;
    }
  }

  Future<List<HopDongDTO>> getLichSuThuePhong(int phongId) async {
    try {
      final list = await hopdongRepository.getLichSuThuePhong(phongId);
      return list;
    } catch (e) {
      rethrow;
    }
  }
}