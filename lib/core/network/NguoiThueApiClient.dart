import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/nguoi_thue.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NguoiThueApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<NguoiThue>> getListNguoiThue() async {
    try {
      final response = await _dio.get("nguoi-thue/findall");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => NguoiThue.fromMap(json)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Loi NguoiThueApiClient $e");
      }
      return [];
    }
  }

  Future<bool> themNguoiThue(NguoiThue nguoiThue) async {
    try {
      final result = await _dio.post(
        "nguoi-thue/create",
        data: nguoiThue.toMap(),
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Loi them nguoi thue $e");
      }

      return false;
    }
  }

  Future<bool> xoaNguoiThue(int idnt) async {
    try {
      final response = await _dio.delete("nguoi-thue/$idnt");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi xóa người thuê $e');
      }
      rethrow;
    }
  }

  Future<List<NguoiThue>> getListNguoiThueFromIdPhong(int idPhong) async {
    try {
      final response = await _dio.get("phong/$idPhong/getListNguoiThue");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => NguoiThue.fromMap(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng NguoiThueApiClient $e");
      }
      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định, NguoiThueApiClient");
      }
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại");
    }
  }

  String _mapErrorToMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Kết nối quá chậm, vui lòng thử lại";
    }
    if (e.type == DioExceptionType.connectionError) {
      return "Không thể kết nối đến máy chủ, vui lòng thử lại sau";
    }
    final statusCode = e.response?.statusCode;
    switch (statusCode) {
      case 404:
        return "Lỗi máy chủ, vui lòng thử lại sau";
      case 500:
        return "Hệ thống đang gặp sự cố, vui lòng thử lại sau";
      default:
        return "Đã có lỗi xảy ra, vui lòng thử lại";
    }
  }
}
