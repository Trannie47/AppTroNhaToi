import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/DTO/ThuCongNoDTO.dart';
import 'package:AppTroNhaToi/models/phieu_thu_hd_th.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PhieuThuHdThApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<PhieuThuHdTh>> getPhieuThuTheoMaHoaDon(String maHoaDon) async {
    try {
      final response = await _dio.get("phieu-thu-hdth/hoa-don/$maHoaDon");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => PhieuThuHdTh.fromMap(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi PhieuThuHdThApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định PhieuThuHdThApiClient: $e");
      }

      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  Future<PhieuThuHdTh?> themPhieuThuHdTh(PhieuThuHdTh phieuThu) async {
    try {
      final response = await _dio.post(
        "phieu-thu-hdth",
        data: phieuThu.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuThuHdTh.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<PhieuThuHdTh?> capNhatPhieuThuHdTh(PhieuThuHdTh phieuThu) async {
    try {
      final response = await _dio.put(
        "phieu-thu-hdth/${phieuThu.maPhieuThu}",
        data: phieuThu.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PhieuThuHdTh.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<bool> xoaPhieuThuHdTh(int maPhieuThu) async {
    try {
      final response = await _dio.delete("phieu-thu-hdth/$maPhieuThu");

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Không có kết nối mạng, vui lòng thử lại";
    }

    switch (e.response?.statusCode) {
      case 404:
        return "Không tìm thấy dữ liệu";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }

  Future<bool> thuCongNo(ThuCongNoDTO dto) async {
    try {
      final result = await _dio.post(
        "phieu-thu-hdth/nguoi-thue",
        data: dto.toMap(),
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi thu công nợ $e");
      }

      return false;
    }
  }
}
