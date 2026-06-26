import 'package:AppTroNhaToi/core/network/retrofit_client.dart';
import 'package:AppTroNhaToi/models/thiet_bi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ThietBiApiClient {
  final Dio _dio = RetrofitClient().dio;

  Future<List<ThietBi>> getListThietBi() async {
    try {
      final response = await _dio.get("thiet-bi/findall");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => ThietBi.fromMap(json)).toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi ThietBiApiClient $e");
      }

      return [];
    }
  }

  Future<ThietBi?> themThietBi(ThietBi thietBi) async {
    try {
      final response = await _dio.post(
        "thiet-bi",
        data: thietBi.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ThietBi.fromMap(response.data);
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi thêm thiết bị $e");
      }

      return null;
    }
  }

  Future<bool> xoaThietBi(int thietBiID) async {
    try {
      final response = await _dio.delete("thiet-bi/$thietBiID");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi xóa thiết bị $e");
      }

      rethrow;
    }
  }

  Future<ThietBi?> capNhatThietBi(ThietBi thietBi) async {
    try {
      final response = await _dio.patch(
        "thiet-bi/${thietBi.thietBiID}",
        data: thietBi.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ThietBi.fromMap(response.data);
      }

      return null;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Lỗi tầng ThietBiApiClient $e");
      }

      throw Exception(_mapErrorToMessage(e));
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi không xác định ThietBiApiClient");
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