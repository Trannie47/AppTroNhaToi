import 'dart:io';

import 'package:AppTroNhaToi/core/network/HopDongApiClient.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';

class HopdongRepository {
  final HopDongApiClient hopDongApiClient = HopDongApiClient();

  Future<List<HopDongDTO>> getListHopDong() {
    return hopDongApiClient.getListHopDong();
  }

  Future<HopDong> createContract(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) {
    return hopDongApiClient.createContract(hopDongPayload, imageHopDong);
  }

  Future<HopDong> updateContract(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) {
    return hopDongApiClient.updateContract(hopDongPayload, imageHopDong);
  }

  Future<HopDong> renewContract({
    required String hopDongId,
    required DateTime ngayHetHanMoi,
    String? ghiChu,
    List<File>? files,
  }) {
    return hopDongApiClient.renewContract(
      hopDongId: hopDongId,
      ngayHetHanMoi: ngayHetHanMoi,
      ghiChu: ghiChu,
      files: files,
    );
  }

  Future<HopDong> deleteContract(String hopDongId) {
    return hopDongApiClient.deleteContract(hopDongId);
  }

  Future<HopDong> cancelContract(String hopDongId) {
    return hopDongApiClient.cancelContract(hopDongId);
  }

  //kết thúc hợp đồng
  Future<HopDong> terminateContract(String hopDongId) {
    return hopDongApiClient.terminateContract(hopDongId);
  }

  Future<List<RoomAvailableDTO>> getRoomsAvailableForContract() {
    return hopDongApiClient.getRoomsAvailableForContract();
  }

  Future<List<HopDong>> getRoomByNguoiThue(int idnt) {
    final result = hopDongApiClient.getRoomByNguoithue(idnt);
    return result;
  }

  Future<List<HopDongDTO>> getLichSuThuePhong(int phongId) async {
    try {
      return await hopDongApiClient.getLichSuThuePhong(phongId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getNguoiOGhep(String hopDongId) {
    return hopDongApiClient.getNguoiOGhep(hopDongId);
  }

  Future<void> addNguoiOGhep(
    String hopDongId,
    List<Map<String, dynamic>> danhSachNguoiOGhep,
  ) {
    return hopDongApiClient.addNguoiOGhep(hopDongId, danhSachNguoiOGhep);
  }

  Future<void> removeNguoiOGhep(String hopDongId, String cccd) {
    return hopDongApiClient.removeNguoiOGhep(hopDongId, cccd);
  }

}
