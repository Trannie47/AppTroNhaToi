import 'dart:io';

import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/repositories/hopdong_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/hop_dong.dart';

class HopDongProvider extends ChangeNotifier {
  final HopdongRepository hopdongRepository = HopdongRepository();

  List<HopDongDTO> _listHD = [];
  List<HopDongDTO> get listHD => _listHD;

  Future<List<HopDongDTO>> getListHD() async {
    try {
      final list = await hopdongRepository.getListHopDong();
      _listHD = list;
      notifyListeners();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<HopDong> createHopDong(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) async {
    try {
      final result = await hopdongRepository.createContract(
        hopDongPayload,
        imageHopDong,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<HopDong> updateHopDong(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) async {
    try {
      final result = await hopdongRepository.updateContract(
        hopDongPayload,
        imageHopDong,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<HopDong> renewHopDong({
    required String hopDongId,
    required DateTime ngayHetHanMoi,
    String? ghiChu,
    List<File>? files,
  }) async {
    try {
      final result = await hopdongRepository.renewContract(
        hopDongId: hopDongId,
        ngayHetHanMoi: ngayHetHanMoi,
        ghiChu: ghiChu,
        files: files,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteHopDong(String hopDongId) async {
    try {
      // Nhận về đối tượng HopDong bị xóa từ server
      final deletedHopDong = await hopdongRepository.deleteContract(hopDongId);
      //xoas local ko cần gọi api
      _listHD.removeWhere((hd) => hd.hopDongID == deletedHopDong.hopDongID);
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi deleteHopDong Provider: $e");
      }
      return false;
    }
  }

  Future<bool> cancelHopDong(String hopDongId) async {
    try {
      final canceledHopDong = await hopdongRepository.cancelContract(hopDongId);

      // Xóa local ngay lập tức khỏi list mà không cần gọi lại API tải danh sách
      _listHD.removeWhere((hd) => hd.hopDongID == canceledHopDong.hopDongID);
      notifyListeners();

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi cancelHopDong Provider: $e");
      }
      rethrow;
    }
  }

  Future<bool> terminateHopDong(String hopDongId) async {
    try {
      await hopdongRepository.terminateContract(hopDongId);
      await getListHD();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi terminateHopDong Provider: $e");
      }
      rethrow;
    }
  }

  Future<List<RoomAvailableDTO>> getRoomsAvailable() async {
    try {
      final list = await hopdongRepository.getRoomsAvailableForContract();
      return list;
    } catch (e) {
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
