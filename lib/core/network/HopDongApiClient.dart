import 'dart:convert';
import 'dart:io';

import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/HopDongDTO.dart';
import 'package:AppTroNhaToi/models/DTO/RoomAvailableDTO.dart';
import 'package:AppTroNhaToi/models/hop_dong.dart';
import 'package:AppTroNhaToi/views/MainPage/PhongPage/ChiTietPhongPage/PhieuLuanChuyenForm/ItemHopDong.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HopDongApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<HopDongDTO>> getListHopDong() async {
    try {
      final request = await _dio.get("hop-dong/findAll");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final List<dynamic> data = request.data;
        return data
            .map((json) => HopDongDTO.fromMap(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        "Tải danh sách hợp đồng thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Loi HopDongApiClient $e");
      }
      rethrow;
    }
  }

  Future<HopDong> createContract(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) async {
    final formData = FormData.fromMap({
      'phongId': hopDongPayload['phongId'],
      'idntDaiDien': hopDongPayload['idntDaiDien'],
      'ngayKy': hopDongPayload['ngayKy'],
      'ngayHetHan': hopDongPayload['ngayHetHan'],
      'tienCoc': hopDongPayload['tienCoc'],
      'giaPhongThucTe': hopDongPayload['giaPhongThucTe'],
      'ghiChu': hopDongPayload['ghiChu'],
      'danhSachNguoiOGhep': jsonEncode(hopDongPayload['danhSachNguoiOGhep']),

      // Danh sách file ảnh thật (binary)
      'files': [
        for (var file in imageHopDong)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      ],
    });
    try {
      final request = await _dio.post(
        "hop-dong/createContract",
        data: formData,
        options: RetrofitClient.uploadOptions,
      );
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception("Lưu hợp đồng thất bại, (Mã lỗi: ${request.statusCode})");
    } catch (e) {
      if (kDebugMode) {
        print("Loi HopDongApiClient $e");
      }
      rethrow;
    }
  }

  Future<HopDong> updateContract(
    Map<String, dynamic> hopDongPayload,
    List<File> imageHopDong,
  ) async {
    final formData = FormData.fromMap({
      'phongId': hopDongPayload['phongId'],
      'idntDaiDien': hopDongPayload['idntDaiDien'],
      'ngayKy': hopDongPayload['ngayKy'],
      'ngayHetHan': hopDongPayload['ngayHetHan'],
      'tienCoc': hopDongPayload['tienCoc'],
      'giaPhongThucTe': hopDongPayload['giaPhongThucTe'],
      'ghiChu': hopDongPayload['ghiChu'],
      'danhSachNguoiOGhep': jsonEncode(hopDongPayload['danhSachNguoiOGhep']),

      // Danh sách file ảnh thật (binary)
      'files': [
        for (var file in imageHopDong)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      ],
    });
    try {
      final hopDongId = hopDongPayload['hopDongId'];
      final request = await _dio.post(
        "hop-dong/$hopDongId/updateContract",
        data: formData,
        options: RetrofitClient.uploadOptions,
      );
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception(
        "Cập nhật hợp đồng thất bại, (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Loi updateContract HopDongApiClient $e");
      }
      rethrow;
    }
  }

  Future<HopDong> renewContract({
    required String hopDongId,
    required DateTime ngayHetHanMoi,
    String? ghiChu,
    List<File>? files,
  }) async {
    final formData = FormData.fromMap({
      'ngayHetHanMoi': ngayHetHanMoi.toIso8601String().split('T').first,
      if (ghiChu != null && ghiChu.trim().isNotEmpty) 'ghiChu': ghiChu.trim(),
      if (files != null && files.isNotEmpty)
        'files': [
          for (var file in files)
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
        ],
    });

    try {
      final request = await _dio.post(
        "hop-dong/$hopDongId/giaHan",
        data: formData,
        options: RetrofitClient.uploadOptions,
      );
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception(
        "Gia hạn hợp đồng thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi renewContract HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<List<RoomAvailableDTO>> getRoomsAvailableForContract() async {
    try {
      final response = await _dio.get("hop-dong/roomsAvailable");
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data = response.data;
        return data
            .map(
              (json) => RoomAvailableDTO.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
      throw Exception(
        "Lấy ds phòng available thất bại (Mã lỗi: ${response.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Loi getRoomsAvailableForContract trong HopDongApiClient $e");
      }
      rethrow;
    }
  }

  Future<HopDong> deleteContract(String hopDongId) async {
    try {
      final request = await _dio.delete("hop-dong/$hopDongId");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception("Ẩn hợp đồng thất bại! (Mã lỗi: ${request.statusCode})");
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi deleteContract HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<HopDong> cancelContract(String hopDongId) async {
    try {
      final request = await _dio.post("hop-dong/$hopDongId/cancel");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception("Hủy hợp đồng thất bại! (Mã lỗi: ${request.statusCode})");
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi cancelContract HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<HopDong> terminateContract(String hopDongId) async {
    try {
      final request = await _dio.post("hop-dong/$hopDongId/terminate");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final responseData = request.data['data'] ?? request.data;
        return HopDong.fromMap(responseData as Map<String, dynamic>);
      }
      throw Exception(
        "Kết thúc hợp đồng thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) print("Lỗi terminateContract HopDongApiClient: $e");
      rethrow;
    }
  }

  Future<List<HopDongDTO>> getLichSuThuePhong(int phongId) async {
    try {
      final request = await _dio.get("hop-dong/$phongId/lich-su");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final List<dynamic> data = request.data;
        return data
            .map((json) => HopDongDTO.fromMap(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        "Tải danh sách lịch sử thuê phòng thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getLichSuThuePhong trong HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<List<HopDong>> getRoomByNguoithue(int idnt) async {
    try {
      final resquest = await _dio.get("nguoi-thue/$idnt/listRoomNguoiThue");
      if (resquest.statusCode == 200 || resquest.statusCode == 201) {
        final List<dynamic> data = resquest.data;
        return data
            .map((json) => HopDong.fromMap(json as Map<String, dynamic>))
            .toList();
      }
      throw DioException(
        requestOptions: resquest.requestOptions,
        response: resquest,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      print("Loi HopDongApiCline $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getNguoiOGhep(String hopDongId) async {
    try {
      final request = await _dio.get("hop-dong/$hopDongId/nguoi-o-ghep");
      if (request.statusCode == 200 || request.statusCode == 201) {
        return (request.data['data'] ?? request.data) as Map<String, dynamic>;
      }
      throw Exception(
        "Lấy danh sách người ở ghép thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getNguoiOGhep HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<void> addNguoiOGhep(
    String hopDongId,
    List<Map<String, dynamic>> danhSachNguoiOGhep,
  ) async {
    try {
      final request = await _dio.post(
        "hop-dong/$hopDongId/nguoi-o-ghep",
        data: {'danhSachNguoiOGhep': danhSachNguoiOGhep},
      );
      if (request.statusCode != 200 && request.statusCode != 201) {
        throw Exception(
          "Thêm người ở ghép thất bại! (Mã lỗi: ${request.statusCode})",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi addNguoiOGhep HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<void> removeNguoiOGhep(String hopDongId, String cccd) async {
    try {
      final request = await _dio.delete(
        "hop-dong/$hopDongId/nguoi-o-ghep/$cccd",
      );
      if (request.statusCode != 200 && request.statusCode != 201) {
        throw Exception(
          "Gỡ người ở ghép thất bại! (Mã lỗi: ${request.statusCode})",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi removeNguoiOGhep HopDongApiClient: $e");
      }
      rethrow;
    }
  }

  Future<List<ItemHopDong>> getHopDongByPhong(int phongId) async {
    try {
      final request = await _dio.get("hop-dong/phong/$phongId");
      if (request.statusCode == 200 || request.statusCode == 201) {
        final List<dynamic> data = request.data;
        return data
            .map((json) => ItemHopDong.fromMap(json as Map<String, dynamic>))
            .toList();
      }
      throw Exception(
        "Tải danh sách hợp đồng theo phòng thất bại! (Mã lỗi: ${request.statusCode})",
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi getHopDongByPhong HopDongApiClient: $e");
      }
      rethrow;
    }
  }
}
